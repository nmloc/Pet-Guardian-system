import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petcare_store_owner/src/constants/app_colors.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';

import 'src/routing/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppSizes().init(context);
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.lightBackground,
          foregroundColor: AppColors.grey800,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
        // https://github.com/firebase/flutterfire/blob/master/packages/firebase_ui_auth/doc/theming.md
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColors.blue500),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            foregroundColor:
                MaterialStateProperty.all<Color>(AppColors.blue500),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.blue500,
          foregroundColor: AppColors.grey0,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          shape: const CircleBorder(),
          iconSize: 30,
        ),
      ),
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: snackbarKey,
    );
  }
}
