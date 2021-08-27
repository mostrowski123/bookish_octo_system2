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
    if (state.rateLimitLift.millisecondsSinceEpoch >
        DateTime.now().millisecondsSinceEpoch) {
      return state.tweets;
    } else {
      state.rateLimit.value = false;
    }
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
        state.lastId = newTweets.last.idStr ?? "";
      } else {
        tweets = await tweetRepo.getPhotoTweets(pastId: state.lastId);
        state.tweets.addAll(tweets);
      }

      state.lastId = state.tweets[state.tweets.length - 1].idStr ?? "";
    } on RateLimitExceededException catch (err) {
      state.rateLimit.value = true;
      state.rateLimitLift = err.rateLimitLift;
    } catch (err) {} finally {
      state.isLoading.value = false;
    }
    return state.tweets;
  }

  Future<List<Tweet>> getInBetweenPosts() async {
    state.isLoading.value = true;
    if (api == null) return List.empty();

    if (state.rateLimitLift.millisecondsSinceEpoch >
        DateTime.now().millisecondsSinceEpoch) {
      return state.tweets;
    } else {
      state.rateLimit.value = false;
    }

    try {
      var tweetRepo = new TweetsRepository(api!);
      var newTweets = await tweetRepo.getPhotoTweets(pastId: state.lastId);
      var indexOfLast =
          state.tweets.indexWhere((element) => element.idStr == state.lastId);

      for (var i = 0; i < newTweets.length; i++) {
        if (state.tweets[i].idStr == state.lastId) {
          state.lastId = state.tweets.last.idStr ?? "";
          break;
        }
        state.tweets.insert(indexOfLast + 1, state.tweets[i]);
      }
    } catch (err) {} finally {
      state.isLoading.value = false;
    }
    return state.tweets;
  }

  Future<bool> likeTweet(String id) async {
    var tweetRepo = new TweetsRepository(api!);
    return await tweetRepo.likeTweet(id);
  }

  Future<bool> removeLike(String id) async {
    var tweetRepo = new TweetsRepository(api!);
    return await tweetRepo.removeLike(id);
  }
}
