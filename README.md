[![Build Status](https://app.bitrise.io/app/fbfde42680bab180/status.svg?token=9PhTjAWkvcWc7v0t2YfT6A&branch=master)](https://app.bitrise.io/app/fbfde42680bab180)
# Bookish Octo System 2

A very early WIP mobile application for viewing images on twitter. Project name is WIP.

## Building

You must have your own api keys in a file called
`environment_config.dart` in the `lib` folder. It should look like

```dart
class EnvironmentConfig {
  static const String TWITTER_API_KEY = 'Your twitter api key';
  static const String TWITTER_API_SECRET_KEY = 'Your twitter api secret key';
}
```

This project uses environment config package so if you have `API_KEY`
and `API_SECRET_KEY` set as environment variables set on your system,
you can run `flutter pub run environment_config:generate` to generate
the above file.

