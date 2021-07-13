import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;

  const TweetCard({Key? key, required this.tweet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
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
            tweet.entities?.userMentions?.length != 0
                ? Text(
                    '@${tweet.entities?.userMentions?[0].name ?? ""}',
                    style: const TextStyle(color: Colors.black54, fontSize: 8),
                  )
                : Text(
                    '@${tweet.user?.name ?? ""}',
                    style: const TextStyle(color: Colors.black54, fontSize: 8),
                  ),
          ],
        ),
      ),
    );
  }
}

/*
return OctoImage(
      image: CachedNetworkImageProvider(
          tweet.entities?.media?[0].mediaUrl ?? ""),
      errorBuilder: OctoError.icon(color: Colors.red),
      fit: BoxFit.fitWidth);
 */
