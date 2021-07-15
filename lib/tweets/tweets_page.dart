import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'components/tweet_card.dart';
import 'tweets_logic.dart';
import 'tweets_state.dart';

class TweetsPage extends StatefulWidget {
  @override
  _TweetsPageState createState() => _TweetsPageState();
}

class _TweetsPageState extends State<TweetsPage> {
  final TweetsLogic logic = Get.put(TweetsLogic());
  final TweetsState state = Get.find<TweetsLogic>().state;

  @override
  initState() {
    super.initState();

    logic.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Tweets'),
        ),
        body: Center(
            child: Obx(
          () => new StaggeredGridView.countBuilder(
            crossAxisCount: (context.mediaQuerySize.width / 200).truncate(),
            itemCount: state.tweets.length,
            itemBuilder: (BuildContext context, int index) {
              if (state.tweets.length - 2 == index) {
                logic.getPosts();
              }
              return TweetCard(tweet: state.tweets.value[index]);
            },
            staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
        )));
  }

  Widget buildItem(BuildContext c, Tweet item, int index) {
    return TweetCard(tweet: state.tweets.value[index]);
  }

  @override
  void dispose() {
    Get.delete<TweetsLogic>();
    super.dispose();
  }
}
