import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_listview/src/controllers/smart_list_view_controller.dart';

class SmartListView extends StatefulWidget {
  const SmartListView({
    Key? key,
    required this.smartController,
    required this.onLoading,
  }) : super(key: key);

  final SmartListViewController smartController;

  /// Remember to complete the refresh on [SmartListViewController]
  final VoidCallback onLoading;

  @override
  State<SmartListView> createState() => _SmartListViewState();
}

class _SmartListViewState extends State<SmartListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        widget.smartController.handleScrollNotification(notification);
        return false;
      },
      child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            refreshTriggerPullDistance: 100.0,
            refreshIndicatorExtent: 60.0,
            onRefresh: () async {
              await Future<void>.delayed(const Duration(milliseconds: 1000));
              // setState(() {});
            },
          ),
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
              return SliverToBoxAdapter(
                child: Container(
                  height: 55,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (value == SmartListViewState.dragging)
                        Text('Pull down to load'),
                      if (value == SmartListViewState.armed)
                        Text('Release to load'),
                      if (value == SmartListViewState.loading) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(),
                            ),
                            Text('Loading....'),
                          ],
                        )
                      ]
                    ],
                  ),
                ),
              );
            },
            valueListenable: widget.smartController.notifier,
          )
        ],
      ),
    );
  }
}
