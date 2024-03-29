import 'package:bookish_octo_system/tweets/tweets_page.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:get/get.dart';

import 'login_logic.dart';
import 'login_state.dart';

class LoginPage extends StatelessWidget {
  final LoginStateLogic logic = Get.put(LoginStateLogic());
  final LoginState state = Get.find<LoginStateLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.login();
    ever(state.isLoggedIn, (_) async {
      Get.put(state);
      Get.off(() => TweetsPage());
    });

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Login'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Login to twitter:',
            ),
            TwitterAuthButton(
              onPressed: () async {
                ever(state.isLoggedIn, (_) async {
                  Get.put(state);
                  Get.off(() => TweetsPage());
                });
                await logic.login();
              },
              darkMode: false, // if true second example
            ),
          ],
        ),
      ),
    );
  }
}
