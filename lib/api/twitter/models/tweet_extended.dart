import 'package:dart_twitter_api/api/tweets/data/tweet.dart';

class ImagePost {
  final Tweet post;
  late String? image64;

  ImagePost(this.post);

  String getSmallImageUrl() {
    var url = post.entities?.media?[0].mediaUrlHttps ?? "";
    if (url == "") {
      return "";
    }
    var format = url.split(".").last;
    var beginningPart = url.substring(0, url.length - 4);
    return '$beginningPart?format=$format&name=small';
  }
}