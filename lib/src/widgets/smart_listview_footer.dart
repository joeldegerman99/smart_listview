import 'package:flutter/material.dart';
import 'package:smart_listview/smart_listview.dart';

typedef SmartListViewFooterBuilder = Widget Function(
    BuildContext context, SmartListViewState state);

class SmartListViewFooter extends StatelessWidget {
  const SmartListViewFooter({Key? key, required this.builder})
      : super(key: key);

  final SmartListViewFooterBuilder builder;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // return builder.call(context, state);
  }
}
