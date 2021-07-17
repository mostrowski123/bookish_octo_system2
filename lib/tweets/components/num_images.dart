import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumImages extends StatelessWidget {
  const NumImages({Key? key, required this.tweet}) : super(key: key);
  final Tweet tweet;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      width: 20,
      height: 18,
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: Border.all(width: 0.0, color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(
                  0, 0), // shadow direction: bottom right
            )
          ],
          borderRadius:
          new BorderRadius.all(Radius.circular(40)),
        ),
        child: Text((tweet.extendedEntities?.media?.length ?? "").toString(), style: TextStyle(color: Colors.black87),
            textAlign: TextAlign.center),
      ),
    );
  }
}
