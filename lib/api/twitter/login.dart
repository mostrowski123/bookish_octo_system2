import 'package:bookish_octo_system/api/twitter/models/twitter_auth_creds.dart';
import 'package:bookish_octo_system/constants/TWITTER_API.dart';
import 'package:dart_twitter_api/api/twitter_client.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/src/response.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

class TwitterApiHelper {
  final String authTokenKey = "auth_token";
  final String authTokenSecretKey = "auth_token_secret";

  Future<TwitterApi> getApi() async {
    final authTokens = await loginTwitter();
    if (authTokens == null) {
      throw NullThrownError();
    }
    final twitterApi = TwitterApi(
      client: TwitterClient(
        consumerKey:TWITTER_API_KEY,
        consumerSecret: TWITTER_API_SECRET,
          secret: authTokens.authTokenSecret,
          token: authTokens.authToken
      )
    );

    return twitterApi;
  }
  
  Future<bool> testCreds(TwitterAuthCreds authTokens) async {

    final twitterApi = TwitterApi(
        client: TwitterClient(
            consumerKey:TWITTER_API_KEY,
            consumerSecret: TWITTER_API_SECRET,
            secret: authTokens.authTokenSecret,
            token: authTokens.authToken
        )
    );

    Response results;
    try {
      results = await twitterApi.client.get(
          Uri.https("api.twitter.com", "1.1/account/verify_credentials.json")
      );
    } catch (err) {
      return false;
    }

    return results.statusCode == 200;
  }

  Future<TwitterAuthCreds?> loginTwitter() async {
    final saved = await checkForSavedAuth();

    if (saved != null && await testCreds(saved)) {
      return saved;
    }

    final twitterLogin = TwitterLogin(
      // Consumer API keys
      apiKey: TWITTER_API_KEY,
      // Consumer API Secret keys
      apiSecretKey: TWITTER_API_SECRET,
      // Registered Callback URLs in TwitterApp
      // Android is a deeplink
      // iOS is a URLScheme
      redirectURI: 'bookish-octo-system://callback',
      // Forces the user to enter their credentials
      // to ensure the correct users account is authorized.
    );
    // If you want to implement Twitter account switching, set [force_login] to true
    // login(forceLogin: true);
    final authResult = await twitterLogin.login();
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
      // success
        print('====== Login success ======');
        if (authResult.authToken != null && authResult.authTokenSecret != null) {
          await saveAuth(authResult);
          return new TwitterAuthCreds(authResult.authToken as String,
              authResult.authTokenSecret as String);
        }
        break;
      case TwitterLoginStatus.cancelledByUser:
      // cancel
        print('====== Login cancel ======');
        break;
      case TwitterLoginStatus.error:
      case null:
      // error
        print('====== Login error ======');
        break;
    }
  }

  Future<TwitterAuthCreds?> checkForSavedAuth() async {
    final storage = new FlutterSecureStorage();

    String? authToken = await storage.read(key: authTokenKey);
    String? authTokenSecret = await storage.read(key: authTokenSecretKey);

    if (authToken == null || authTokenSecret == null) {
      return null;
    }

    return new TwitterAuthCreds(authToken, authTokenSecret);
  }

  Future saveAuth(AuthResult auth) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: authTokenKey, value: auth.authToken);
    await storage.write(key: authTokenSecretKey, value: auth.authTokenSecret);
  }
}