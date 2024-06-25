import 'package:flutter/material.dart';
import 'package:petcare_staff/src/layers/data/auth_repository.dart';
import 'package:petcare_staff/src/layers/data/splash_repository.dart';
import 'package:petcare_staff/src/layers/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:petcare_staff/src/layers/presentation/screens/inventory/inventory_screen.dart';
import 'package:petcare_staff/src/layers/presentation/screens/tasks/tasks_screen.dart';
import 'package:petcare_staff/src/layers/presentation/screens/sign_in/sign_in_screen.dart';
import 'package:petcare_staff/src/layers/presentation/screens/splash/splash_screen.dart';
import 'package:petcare_staff/src/layers/presentation/screens/user_profile/user_profile_screen.dart';
import 'package:petcare_staff/src/routing/go_router_refresh_stream.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

part 'app_router.g.dart';

final snackbarKey = GlobalKey<ScaffoldMessengerState>();

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  splash,
  signIn,
  dashboard,
  petProfile,
  tasks,
  profile,
  userProfile,
  inventory
}

@riverpod
// ignore: unsupported_provider_value
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final splashRepository = ref.watch(splashRepositoryProvider).requireValue;
  return GoRouter(
    initialLocation: '/signIn',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final didCompleteSplash = splashRepository.isSplashCompleted();
      final path = state.uri.path;
      if (!didCompleteSplash) {
        // Always check state.subloc before returning a non-null route
        // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart#L78
        if (path != '/splash') {
          return '/splash';
        }
      }
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        final permission = await authRepository
            .permissionGranted(authRepository.currentUser!.email!);
        if (permission != null && permission != '') {
          if (path.startsWith('/signIn')) {
            return '/dashboard';
          }
        }
      } else {
        if (path.startsWith('/dashboard')) {
          return '/signIn';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/splash',
        name: AppRoute.splash.name,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: SplashScreen()),
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: SignInScreen()),
      ),
      GoRoute(
        path: '/dashboard',
        name: AppRoute.dashboard.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: DashboardScreen()),
        routes: [
          GoRoute(
            path: 'orders',
            name: AppRoute.tasks.name,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: TasksScreen()),
          ),
          GoRoute(
            path: 'inventory',
            name: AppRoute.inventory.name,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: InventoryScreen()),
          ),
          GoRoute(
            path: 'userProfile',
            name: AppRoute.userProfile.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: UserProfileScreen()),
          ),
        ],
      ),
    ],
    //errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
