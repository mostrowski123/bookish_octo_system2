import 'package:bookish_octo_system/api/twitter/login.dart';
import 'package:get/get.dart';

import 'login_state.dart';

class LoginStateLogic extends GetxController {
  final state = LoginState();

  Future<void> login() async {
    var apiHelper = new TwitterApiHelper();
    final api = await apiHelper.getApi();
    state.isLoggedIn.value = true;
    state.api = api;
  }
}
