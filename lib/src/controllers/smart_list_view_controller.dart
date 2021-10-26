import 'package:flutter/material.dart';

enum SmartListViewState { idle, dragging, armed, loading }

class SmartListViewController extends ChangeNotifier {
  SmartListViewController() {
    _setupValueNotifier();
  }

  SmartListViewState _state = SmartListViewState.idle;

  SmartListViewState get state => _state;

  late ValueNotifier<SmartListViewState> _notifier;

  ValueNotifier<SmartListViewState> get notifier => _notifier;

  void _setupValueNotifier() {
    _notifier = ValueNotifier<SmartListViewState>(state);
  }

  void refreshComplete() {
    _state = SmartListViewState.idle;
    notifyListeners();
  }

  void handleScrollNotification(ScrollNotification notification) {
    if (state == SmartListViewState.loading) return;
    if (notification is ScrollStartNotification) {
      _state = SmartListViewState.dragging;
      notifyListeners();
    }

    if (notification is ScrollUpdateNotification) {
      final prevState = _state;

      if (notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
        _state = SmartListViewState.armed;
        if (prevState != _state) {
          notifyListeners();
        }
      } else {
        _state = SmartListViewState.dragging;
        // print(prevState);
        if (prevState != _state) {
          notifyListeners();
        }
      }
    }

    if (notification is ScrollEndNotification) {
      if (state == SmartListViewState.armed &&
          state != SmartListViewState.loading) {
        _state = SmartListViewState.loading;
        notifyListeners();
      } else {
        _state = SmartListViewState.idle;
        notifyListeners();
      }
    }
  }

  @override
  void notifyListeners() {
    _notifier.value = _state;
    _notifier.notifyListeners();
    super.notifyListeners();
  }
}