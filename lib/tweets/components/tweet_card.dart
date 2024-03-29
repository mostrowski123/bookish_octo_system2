import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:bookish_octo_system/api/twitter/models/tweet_extended.dart';
import 'package:bookish_octo_system/tweet/tweet_view.dart';
import 'package:bookish_octo_system/tweets/components/num_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';

import 'action_button.dart';

class TweetCard extends StatelessWidget {
  final ImagePost tweet;
  final TargetPlatform? platform;

  const TweetCard({Key? key, required this.tweet, required this.platform})
      : super(key: key);

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

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
                          tag: '${tweet.post.idStr}0',
                          child: CachedNetworkImage(
                            imageUrl: tweet.getSmallImageUrl(),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Container(
                                    child: SizedBox(
                                      child: Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                      ),
                                    ),
                                    // calculate new height. w * h * 175 + arbitrary = new scale height
                                    height: (tweet.post.entities?.media?[0]
                                                    .sizes?.small?.h
                                                    ?.toDouble() ??
                                                200) /
                                            (tweet.post.entities?.media?[0]
                                                    .sizes?.small?.w ??
                                                200) *
                                            175 +
                                        20,
                                    width: 175),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return TweetPage(
                              tweet: tweet.post,
                            );
                          }));
                        },
                      ),
                      if ((tweet.post.extendedEntities?.media?.length ?? 1) > 1)
                        NumImages(tweet: tweet.post)
                      else
                        Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          tweet.post.entities?.userMentions?.length != 0
              ? Text(
                  '@${tweet.post.entities?.userMentions?[0].name ?? ""}',
                  style: TextStyle(color: HexColor('#FFFFFFE6'), fontSize: 9.5),
                )
              : Text(
                  '@${tweet.post.user?.name ?? ""}',
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
                onPressed: () async {
                  tweet.post.extendedEntities?.media?.forEach((url) async {
                    var urlSplit = url.mediaUrlHttps?.split('.');
                    var format = urlSplit?.last;
                    if (await _checkPermission()) {
                      return;
                    }
                    if (!await Directory(
                            await AndroidPathProvider.picturesPath +
                                '/BookishOctoSystem/')
                        .exists()) {
                      Directory(await AndroidPathProvider.picturesPath +
                              '/BookishOctoSystem/')
                          .create();
                    }

                    await FlutterDownloader.enqueue(
                        url:
                            '${url.mediaUrlHttps?.substring(0, (url.mediaUrlHttps?.length ?? 4) - 4)}?format=$format&name=orig',
                        savedDir: await AndroidPathProvider.picturesPath +
                            '/BookishOctoSystem/',
                        showNotification: true,
                        openFileFromNotification: true,
                        fileName: url.mediaUrlHttps?.substring(
                            'https://pbs.twimg.com/media/'.length));
                  });
                },
              ),
              ActionButton(
                tweet: tweet.post,
              ),
            ],
          )
        ],
      ),
    );
  }
}
