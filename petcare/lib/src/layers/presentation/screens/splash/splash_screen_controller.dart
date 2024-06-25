
import 'dart:async';

import 'package:petcare/src/layers/data/splash_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_screen_controller.g.dart';

@riverpod
class SplashScreenController extends _$SplashScreenController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> completeSplash() async {
    final splashRepository =
        ref.watch(splashRepositoryProvider).requireValue;
    state = const AsyncLoading();
    state = await AsyncValue.guard(splashRepository.setSplashComplete);
  }
}