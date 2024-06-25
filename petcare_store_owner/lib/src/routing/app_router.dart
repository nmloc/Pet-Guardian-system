import 'package:flutter/material.dart';
import 'package:petcare_store_owner/src/layers/data/auth_repository.dart';
import 'package:petcare_store_owner/src/layers/data/splash_repository.dart';
import 'package:petcare_store_owner/src/layers/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:petcare_store_owner/src/layers/presentation/screens/demand_forecast/demand_forecast_screen.dart';
import 'package:petcare_store_owner/src/layers/presentation/screens/inventory/inventory_screen.dart';
import 'package:petcare_store_owner/src/layers/presentation/screens/orders/orders_screen.dart';
import 'package:petcare_store_owner/src/layers/presentation/screens/sign_in/sign_in_screen.dart';
import 'package:petcare_store_owner/src/layers/presentation/screens/splash/splash_screen.dart';
import 'package:petcare_store_owner/src/layers/presentation/screens/staffs/staffs_screen.dart';
import 'package:petcare_store_owner/src/routing/go_router_refresh_stream.dart';
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
  orders,
  profile,
  inventory,
  staffs,
  demandForecast,
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
    redirect: (context, state) {
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
        if (path.startsWith('/signIn')) {
          return '/dashboard';
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
            name: AppRoute.orders.name,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: OrdersScreen()),
          ),
          GoRoute(
            path: 'inventory',
            name: AppRoute.inventory.name,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: InventoryScreen()),
          ),
          GoRoute(
            path: 'staffs',
            name: AppRoute.staffs.name,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: StaffsScreen()),
          ),
          GoRoute(
            path: 'demand-forecast',
            name: AppRoute.demandForecast.name,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: DemandForecastScreen()),
          ),
        ],
      ),
    ],
    //errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
