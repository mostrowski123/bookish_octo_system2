import 'dart:isolate';
import 'dart:ui';

import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:humanizer/humanizer.dart';

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
  ReceivePort _port = ReceivePort();
  List<_TaskInfo>? _tasks;

  @override
  initState() {
    super.initState();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    //logic.getPosts();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    //print(
    //   'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      //print('UI Isolate Callback: $data');
      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      int? progress = data[2];

      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == id);
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
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
            crossAxisCount: (context.mediaQuerySize.width / 175).truncate(),
            itemCount: state.tweets.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (state.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (state.rateLimit.value) {
                return Center(
                    child: Text(
                        "Reached rate limit. Please try again in ${state.rateLimitLift.humanizeRelativeDateTime()}"));
              }
              if (state.tweets.length - 3 == index) {
                logic.getPosts();
              } else if (state.tweets.indexWhere(
                          (element) => element.post.idStr == state.lastId) -
                      2 ==
                  index) {
                logic.getInBetweenPosts();
              }
              if (state.tweets.length > 0) {
                return TweetCard(
                    tweet: state.tweets[index],
                    platform: Theme
                        .of(context)
                        .platform);
              }

              return Center();
            },
            staggeredTileBuilder: (int index) {
              if (index == state.tweets.length) {
                return StaggeredTile.extent(
                    (context.mediaQuerySize.width / 175).truncate(), 100);
              } else {
                return const StaggeredTile.fit(1);
              }
            },
            mainAxisSpacing: 3.0,
            crossAxisSpacing: 3.0,
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext c, Tweet item, int index) {
    return TweetCard(
        tweet: state.tweets[index], platform: Theme.of(context).platform);
  }

  @override
  void dispose() {
    Get.delete<TweetsLogic>();
    _unbindBackgroundIsolate();
    super.dispose();
  }
}

class _TaskInfo {
  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}
