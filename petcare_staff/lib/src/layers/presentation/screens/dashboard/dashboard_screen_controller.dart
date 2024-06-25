import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_screen_controller.g.dart';

@riverpod
class ZDrawer extends _$ZDrawer {
  final _zoomDrawerController = ZoomDrawerController();

  @override
  ZoomDrawerController build() => _zoomDrawerController;
}

@riverpod
class CarouselIndex extends _$CarouselIndex {
  @override
  int build() => 0;
  void set(int index) => state = index;
}
