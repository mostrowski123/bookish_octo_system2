import 'dart:convert';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:http/http.dart';

class TweetsRepository {
  final TwitterApi api;

  TweetsRepository(this.api);

  Future<List<Tweet>> getPhotoTweets({String pastId = ""}) async {
    late List<Tweet> timeline;

    try {
      if (pastId != "") {
        timeline =
            await api.timelineService.homeTimeline(count: 45, maxId: pastId);
        timeline.removeAt(0);
      } else {
        timeline = await api.timelineService.homeTimeline(count: 45);
      }
    } on Response catch (err) {
      if (err.statusCode == 429) {
        var result = await api.client.get(Uri.https(
            'api.twitter.com', '1.1/application/rate_limit_status.json'));

        var resetTime = jsonDecode(result.body)["resources"]["statuses"]
            ["/statuses/home_timeline"]["reset"];
        throw new RateLimitExceededException(
            DateTime.fromMillisecondsSinceEpoch(resetTime * 1000));
      }
    }
    return await photoTweets(timeline);
  }

  Future<List<Tweet>> getNewPhotoTweets({String sinceId = ""}) async {
    late List<Tweet> timeline;

    try {
      if (sinceId != "") {
        timeline =
            await api.timelineService.homeTimeline(count: 45, sinceId: sinceId);
      } else {
        timeline = await api.timelineService.homeTimeline(count: 45);
      }
    } on Response catch (err) {
      if (err.statusCode == 429) {
        var result = await api.client.get(Uri.https(
            'api.twitter.com', '1.1/application/rate_limit_status.json'));

        var resetTime = jsonDecode(result.body)["resources"]["statuses"]
            ["/statuses/home_timeline"]["reset"];
        throw new RateLimitExceededException(
            DateTime.fromMicrosecondsSinceEpoch(resetTime));
      }
    }

    return await photoTweets(timeline);
  }

  Future<List<Tweet>> photoTweets(List<Tweet> tweets) async {
    var result = <Tweet>[];

    tweets.forEach((tweet) {
      if (tweet.entities?.media?.isNotEmpty ?? false) {
        result.add(tweet);
      }
    });

    return result;
  }

  // like a tweet
  Future<bool> likeTweet(String tweetId) async {
    try {
      await api.tweetService.createFavorite(id: tweetId);
    } on Response catch (err) {
      if (err.statusCode == 403) {
        return true;
      }
      return false;
    }
    return true;
  }

  Future<bool> removeLike(String tweetId) async {
    try {
      await api.tweetService.destroyFavorite(id: tweetId);
    } catch (err) {
      return false;
    }
    return true;
  }
}

class RateLimitExceededException implements Exception {
  DateTime rateLimitLift;

  RateLimitExceededException(this.rateLimitLift);
}
