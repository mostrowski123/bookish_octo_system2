import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';

class TweetsState {

  RxBool isLoading = true.obs;
  RxList<Tweet> tweets = <Tweet>[].obs;

  TweetsState();
}
