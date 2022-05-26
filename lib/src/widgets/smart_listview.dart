import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_listview/src/controllers/smart_list_view_controller.dart';

class SmartListView extends StatelessWidget {
  const SmartListView({
    Key? key,
    required this.smartController,
    required this.onLoading,
    required this.onRefresh,
    //  required this.footer,
  }) : super(key: key);

  final SmartListViewController smartController;

  /// Remember to complete the refresh on [SmartListViewController]
  final VoidCallback onLoading;
  final Future<void> Function() onRefresh;

  // final SmartListViewFooter footer;

  @override
  Widget build(BuildContext context) {
    Widget widget = CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        if (Platform.isIOS) CupertinoSliverRefreshControl(onRefresh: onRefresh),
        SliverList(
          delegate: SliverChildBuilderDelegate((_, index) {
            return Container(
              height: 50,
              width: double.infinity,
              color: Colors.red,
              margin: const EdgeInsets.all(10),
            );
          }, childCount: 15),
        ),
        ValueListenableBuilder(
          builder: (context, value, child) {
            if (value == SmartListViewState.loading) onLoading();

            // if()

            late Widget body;

            if (value == SmartListViewState.idle) {
              body = const Text('Pull up to load');
            } else if (value == SmartListViewState.armed) {
              body = const Text('Release to load more');
            } else if (value == SmartListViewState.loading) {
              body = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(width: 8),
                  Text('Loading....'),
                ],
              );
            } else {
              body = const Text('No more data');
            }

            return SliverToBoxAdapter(
              child: Container(
                  height: 55, alignment: Alignment.center, child: body),
            );
          },
          valueListenable: smartController.notifier,
        )
      ],
    );

    if (Platform.isAndroid) {
      widget = RefreshIndicator(
        onRefresh: onRefresh,
        child: widget,
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        smartController.handleScrollNotification(notification);
        return false;
      },
      child: widget,
    );
  }
}
