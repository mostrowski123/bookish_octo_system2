import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:octo_image/octo_image.dart';

import 'action_button.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;

  const TweetCard({Key? key, required this.tweet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 5,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: OctoImage(
                image: CachedNetworkImageProvider(
                    tweet.entities?.media?[0].mediaUrl ?? ""),
                placeholderBuilder: (context) => Container(
                    child: CircularProgressIndicator(),
                    height: 200,
                    width: 200),
                errorBuilder: OctoError.icon(color: Colors.red),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SizedBox(height: 4),
          tweet.entities?.userMentions?.length != 0
              ? Text(
                  '@${tweet.entities?.userMentions?[0].name ?? ""}',
                  style: TextStyle(color: HexColor('#FFFFFFE6'), fontSize: 9.5),
                )
              : Text(
                  '@${tweet.user?.name ?? ""}',
                  style: TextStyle(color: HexColor('#FFFFFFE6'), fontSize: 9.5),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                padding: EdgeInsets.all(0),
                shape: CircleBorder(),
                minWidth: 3,
                height: 2,
                child: Icon(Icons.download, color: Colors.grey, size: 25),
                onPressed: () => {print('hello')},
              ),
              ActionButton(),
            ],
          )
        ],
      ),
    );
  }
}