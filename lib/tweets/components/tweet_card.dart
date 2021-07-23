import 'package:bookish_octo_system/tweet/tweet_view.dart';
import 'package:bookish_octo_system/tweets/components/num_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

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
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        child: Hero(
                          tag: tweet.idStr ?? "",
                          child: CachedNetworkImage(
                            imageUrl: tweet.entities?.media?[0].mediaUrl ?? "",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Container(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                    height: 200,
                                    width: 200),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return TweetPage(
                              tweet: tweet,
                            );
                          }));
                        },
                      ),
                      if ((tweet.extendedEntities?.media?.length ?? 1) > 1)
                        NumImages(tweet: tweet)
                      else
                        Container()
                    ],
                  ),
                ),
              ],
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
                onPressed: () async {},
              ),
              ActionButton(
                tweet: tweet,
              ),
            ],
          )
        ],
      ),
    );
  }
}
