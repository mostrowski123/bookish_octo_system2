import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';

class TweetsState {

  RxBool isLoading = true.obs;
  RxBool rateLimit = false.obs;
  DateTime rateLimitLift = DateTime.now().subtract(new Duration(seconds: 1));
  String lastId = "";
  RxList<Tweet> tweets = <Tweet>[].obs;

  TweetsState();
}
