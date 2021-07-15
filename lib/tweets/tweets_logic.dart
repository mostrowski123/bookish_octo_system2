import 'package:bookish_octo_system/api/twitter/tweets.dart';
import 'package:bookish_octo_system/login/login_state.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';

import 'tweets_state.dart';

class TweetsLogic extends GetxController {
  final state = TweetsState();
  final TwitterApi? api = Get.find<LoginState>().api;

  Future<List<Tweet>> getPosts() async {
    if (api == null) return List.empty();
    var tweetRepo = new TweetsRepository(api!);
    var tweets = await tweetRepo.getPhotoTweets(pastId: state.lastId);
    state.lastId = tweets[tweets.length - 1].idStr ?? "";
    state.tweets.addAll(tweets);
    return state.tweets;
  }
}
