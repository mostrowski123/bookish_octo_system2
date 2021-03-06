import 'package:bookish_octo_system/tweets/tweets_logic.dart';
import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({Key? key, required this.tweet}) : super(key: key);

  final Tweet tweet;

  @override
  _ActionButtonState createState() => _ActionButtonState(tweet);
}

class _ActionButtonState extends State<ActionButton> {
  final Tweet tweet;
  final TweetsLogic logic = Get.put(TweetsLogic());

  Future<void> likeTweet() async {
    final result = await logic.likeTweet(tweet.retweetedStatus?.idStr ?? tweet.idStr ?? "");
    if (!result) {
      setState(() {
        tweet.favorited = false;
      });
    }
  }

  Future<void> removeLike() async {
    final result = await logic.removeLike(tweet.retweetedStatus?.idStr ?? tweet.idStr ?? "");
    if (!result) {
      setState(() {
        tweet.favorited = true;
      });
    }
  }
  _ActionButtonState(this.tweet);

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      size: 26,
      isLiked: tweet.favorited,
      likeCount: tweet.retweetedStatus?.favoriteCount ?? tweet.favoriteCount,
      countBuilder: (int? count, bool isLiked, String text) {
        var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
        Widget result;
        if (count == 0) {
          result = Text(
            'like',
            style: TextStyle(color: color),
          );
        } else
          result = Text(
            NumberFormat.compact().format(count),
            style: TextStyle(color: color),
          );
        return result;
      },
      likeCountPadding: const EdgeInsets.only(right: 3.0, left: 3.0),
      likeCountAnimationType: LikeCountAnimationType.all,
      onTap: (liked) async {
        if (liked) {
          tweet.favorited = false;
          removeLike();
          return false;
        } else {
          tweet.favorited = true;
          likeTweet();
          return true;
        }
      },
    );
  }
}
