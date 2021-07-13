
import 'package:dart_twitter_api/twitter_api.dart';

class TweetsRepository {
  final TwitterApi api;

  TweetsRepository(this.api);
  Future<List<Tweet>> getPhotoTweets() async {
    final timeline = await api.timelineService.homeTimeline(
      count: 10,
    );

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
}