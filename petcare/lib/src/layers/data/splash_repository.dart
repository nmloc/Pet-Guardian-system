import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_repository.g.dart';

class SplashRepository {
  SplashRepository(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const splashCompletedKey = 'splashCompleted';

  Future<void> setSplashComplete() async {
    await sharedPreferences.setBool(splashCompletedKey, true);
  }

  bool isSplashCompleted() =>
      sharedPreferences.getBool(splashCompletedKey) ?? false;
}

@Riverpod(keepAlive: true)
Future<SplashRepository> splashRepository(SplashRepositoryRef ref) async {
  return SplashRepository(await SharedPreferences.getInstance());
}
