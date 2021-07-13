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
    state.tweets.value = await tweetRepo.getPhotoTweets();
    return state.tweets;
  }
}
