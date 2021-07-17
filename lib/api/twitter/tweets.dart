import 'package:dart_twitter_api/twitter_api.dart';

class TweetsRepository {
  final TwitterApi api;

  TweetsRepository(this.api);

  Future<List<Tweet>> getPhotoTweets({String pastId = ""}) async {
    final List<Tweet> timeline;
    if (pastId != "") {
      timeline =
          await api.timelineService.homeTimeline(count: 25, maxId: pastId);
      timeline.removeAt(0);
    } else {
      timeline = await api.timelineService.homeTimeline(count: 25);
    }

    return await photoTweets(timeline);
  }

  Future<List<Tweet>> getNewPhotoTweets({String sinceId = ""}) async {
    final List<Tweet> timeline;

    if (sinceId != "") {
      timeline =
          await api.timelineService.homeTimeline(count: 25, sinceId: sinceId);
    } else {
      timeline = await api.timelineService.homeTimeline(count: 25);
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
    } catch (err) {
      return false;
    }
    return true;
  }
}
