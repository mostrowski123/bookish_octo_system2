import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


class TweetPage extends StatelessWidget {
  const TweetPage({Key? key, required this.tweet}) : super(key: key);

  final Tweet tweet;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(
                  tweet.extendedEntities?.media?[index].mediaUrl ?? "",),
                heroAttributes: PhotoViewHeroAttributes(tag: tweet.idStr ?? "")
            );
          },
          itemCount: tweet.extendedEntities?.media?.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(),
            ),
          ),
        )
      ),
      onDoubleTap: () {
        Get.back();
        },
    );
  }
}