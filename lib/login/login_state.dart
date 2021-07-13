import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';

class LoginState {
  RxBool isLoggedIn = false.obs;
  TwitterApi? api;

  LoginState();
}
