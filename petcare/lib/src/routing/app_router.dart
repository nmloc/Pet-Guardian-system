import 'package:flutter/material.dart';
import 'package:petcare/src/layers/data/auth_repository.dart';
import 'package:petcare/src/layers/data/splash_repository.dart';
import 'package:petcare/src/layers/domain/pet.dart';
import 'package:petcare/src/layers/presentation/screens/add_pet/add_pet_breed_screen.dart';
import 'package:petcare/src/layers/presentation/screens/add_pet/add_pet_gender_screen.dart';
import 'package:petcare/src/layers/presentation/screens/add_pet/add_pet_important_dates_screen.dart';
import 'package:petcare/src/layers/presentation/screens/add_pet/add_pet_name_screen.dart';
import 'package:petcare/src/layers/presentation/screens/add_pet/add_pet_signs_screen.dart';
import 'package:petcare/src/layers/presentation/screens/add_pet/add_pet_size_screen.dart';
import 'package:petcare/src/layers/presentation/screens/add_pet/add_pet_species_screen.dart';
import 'package:petcare/src/layers/presentation/screens/add_pet/add_pet_weight_screen.dart';
import 'package:petcare/src/layers/presentation/screens/booking/booking_screen.dart';
import 'package:petcare/src/layers/presentation/screens/branch/branches_screen.dart';
import 'package:petcare/src/layers/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:petcare/src/layers/presentation/screens/orders/orders_screen.dart';
import 'package:petcare/src/layers/presentation/screens/pet_profile/components/edit_pet_profile_screen.dart';
import 'package:petcare/src/layers/presentation/screens/pet_profile/pet_profile_screen.dart';
import 'package:petcare/src/layers/presentation/screens/sign_in/sign_in_screen.dart';
import 'package:petcare/src/layers/presentation/screens/splash/splash_screen.dart';
import 'package:petcare/src/layers/presentation/screens/branch/branch_detail_screen.dart';
import 'package:petcare/src/layers/presentation/screens/user_profile/user_profile_screen.dart';
import 'package:petcare/src/layers/presentation/screens/vaccines/vaccine_detail_screen.dart';
import 'package:petcare/src/layers/presentation/screens/vaccines/vaccines_screen.dart';
import 'package:petcare/src/routing/go_router_refresh_stream.dart';
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
  addPetSpecies,
  addPetBreed,
  addPetName,
  addPetGender,
  addPetSize,
  addPetWeight,
  addPetSigns,
  addPetImportantDates,
  petProfile,
  editPetProfile,
  orders,
  profile,
  userProfile,
  branches,
  branchDetail,
  vaccines,
  vaccineDetail,
  booking,
}

@riverpod
// ignore: unsupported_provider_value
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final splashRepository = ref.watch(splashRepositoryProvider).requireValue;
  return GoRouter(
    initialLocation: '/sign-in',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final didCompleteSplash = splashRepository.isSplashCompleted();
      final path = state.uri.path;

      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (path.startsWith('/sign-in')) {
          return '/';
        }
      } else {
        if (!didCompleteSplash) {
          if (path != '/splash') {
            return '/splash';
          }
        } else {
          if (path != '/sign-in') {
            return '/sign-in';
          }
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
        path: '/sign-in',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: SignInScreen()),
      ),
      GoRoute(
        path: '/',
        name: AppRoute.dashboard.name,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: DashboardScreen()),
        routes: [
          GoRoute(
            path: 'add-pet/species',
            name: AppRoute.addPetSpecies.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                // fullscreenDialog: true,
                child: APPSpeciesScreen(),
              );
            },
            routes: [
              GoRoute(
                path: 'breed',
                name: AppRoute.addPetBreed.name,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    child: APPBreedScreen(),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'name',
                    name: AppRoute.addPetName.name,
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        child: APPNameScreen(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'gender',
                        name: AppRoute.addPetGender.name,
                        pageBuilder: (context, state) {
                          return NoTransitionPage(
                            child: APPGenderScreen(),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'size',
                            name: AppRoute.addPetSize.name,
                            pageBuilder: (context, state) {
                              return NoTransitionPage(
                                child: APPSizeScreen(),
                              );
                            },
                            routes: [
                              GoRoute(
                                path: 'weight',
                                name: AppRoute.addPetWeight.name,
                                pageBuilder: (context, state) {
                                  return NoTransitionPage(
                                    child: APPWeightScreen(),
                                  );
                                },
                                routes: [
                                  GoRoute(
                                    path: 'signs',
                                    name: AppRoute.addPetSigns.name,
                                    pageBuilder: (context, state) {
                                      return NoTransitionPage(
                                        child: APPSignsScreen(),
                                      );
                                    },
                                    routes: [
                                      GoRoute(
                                        path: 'important-dates',
                                        name:
                                            AppRoute.addPetImportantDates.name,
                                        pageBuilder: (context, state) {
                                          return NoTransitionPage(
                                            child: APPImportantDatesScreen(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: 'pet-profile',
            name: AppRoute.petProfile.name,
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: PetProfileScreen());
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.editPetProfile.name,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    child: EditPetProfileScreen(pet: state.extra as Pet),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'userProfile',
            name: AppRoute.userProfile.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: UserProfileScreen()),
          ),
          GoRoute(
            path: 'orders',
            name: AppRoute.orders.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(child: OrdersScreen());
            },
          ),
          GoRoute(
            path: 'branches',
            name: AppRoute.branches.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(child: BranchesScreen());
            },
            routes: [
              GoRoute(
                path: ':branchId',
                name: AppRoute.branchDetail.name,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: BranchDetailScreen(
                          state.pathParameters['branchId']!));
                },
              ),
            ],
          ),
          GoRoute(
            path: 'vaccines',
            name: AppRoute.vaccines.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(child: VaccinesScreen());
            },
            routes: [
              GoRoute(
                path: ':vaccineId',
                name: AppRoute.vaccineDetail.name,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: VaccineDetailScreen(
                    vaccineId: state.pathParameters['vaccineId']!,
                  ));
                },
              ),
            ],
          ),
          GoRoute(
            path: 'booking/:category',
            name: AppRoute.booking.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                  child: BookingScreen(
                category: state.pathParameters['category']!,
                itemId: state.uri.queryParameters['itemId'],
              ));
            },
          ),
        ],
      ),
    ],
    //errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
