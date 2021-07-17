import 'package:bookish_octo_system/api/twitter/tweets.dart';
import 'package:bookish_octo_system/login/login_state.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';

import 'tweets_state.dart';

class TweetsLogic extends GetxController {
  final state = TweetsState();
  final TwitterApi? api = Get.find<LoginState>().api;

  Future<List<Tweet>> getPosts({bool refresh = false}) async {
    state.isLoading.value = true;
    if (api == null) return List.empty();
    try {
      var tweetRepo = new TweetsRepository(api!);
      List<Tweet> tweets;
      if (refresh) {
        final newTweets = await tweetRepo.getNewPhotoTweets(
            sinceId: state.tweets[0].idStr ?? "");

        newTweets.forEach((newTweet) {
          state.tweets.insert(0, newTweet);
        });
      } else {
        tweets = await tweetRepo.getPhotoTweets(pastId: state.lastId);
        state.tweets.addAll(tweets);
      }

      state.lastId = state.tweets[state.tweets.length - 1].idStr ?? "";
    } catch (err) {
      // TODO: catch error
    } finally {
      state.isLoading.value = false;
    }
    return state.tweets;
  }

  Future<bool> likeTweet(String id) async {
    var tweetRepo = new TweetsRepository(api!);
    return await tweetRepo.likeTweet(id);
  }
}
