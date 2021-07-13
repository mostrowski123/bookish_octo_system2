import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_logic.dart';
import 'login_state.dart';

class LoginStatePage extends StatelessWidget {
  final LoginStateLogic logic = Get.put(LoginStateLogic());
  final LoginState state = Get.find<LoginStateLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
