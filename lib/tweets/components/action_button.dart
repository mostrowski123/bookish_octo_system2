import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({Key? key}) : super(key: key);

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return LikeButton(
      size: 23,
      likeCount: 1100,
      countBuilder: (int? count, bool isLiked, String text) {
        var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
        Widget result;
        if (count == 0) {
          result = Text(
            "love",
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
    );
  }
}
