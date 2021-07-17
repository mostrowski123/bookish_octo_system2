import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final controller = ScrollController();

  @override
  initState() {
    super.initState();
    logic.getPosts();
  }

  void _onRefresh() async {
    final curNumPosts = state.tweets.length;
    logic.getPosts(refresh: true);
    if (curNumPosts == state.tweets.length) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(
        controller: controller, // Note the controller here
        title: Text("Tweets"),
        
      ),
      body: Obx(
        () => SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: StaggeredGridView.countBuilder(
            controller: controller,
            crossAxisCount: (context.mediaQuerySize.width / 200).truncate(),
            itemCount: state.tweets.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (state.tweets.length - 2 == index) {
                logic.getPosts();
              }
              if (state.tweets.length == index) {
                return Center(child: CircularProgressIndicator());
              }
              return TweetCard(tweet: state.tweets.value[index]);
            },
            staggeredTileBuilder: (int index) {
              if (index == state.tweets.length) {
                return StaggeredTile.extent(
                    (context.mediaQuerySize.width / 200).truncate(), 100);
              } else {
                return const StaggeredTile.fit(1);
              }
            },
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
        ),
      ),
    );
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
