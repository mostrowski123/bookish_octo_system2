import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';

class TweetsState {

  RxBool isLoading = true.obs;
  RxBool rateLimit = false.obs;
  DateTime rateLimitLift = DateTime.now();
  String lastId = "";
  RxList<Tweet> tweets = <Tweet>[].obs;

  TweetsState();
}
