import 'package:bookish_octo_system/api/twitter/models/tweet_extended.dart';
import 'package:get/get.dart';

class TweetsState {

  RxBool isLoading = true.obs;
  RxBool rateLimit = false.obs;
  DateTime rateLimitLift = DateTime.now().subtract(new Duration(seconds: 1));
  String lastId = "";
  RxList<ImagePost> tweets = <ImagePost>[].obs;

  TweetsState();
}
