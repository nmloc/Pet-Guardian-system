import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petcare_store_owner/src/constants/app_colors.dart';
import 'package:petcare_store_owner/src/constants/app_constants.dart';
import 'package:petcare_store_owner/src/constants/app_text_styles.dart';
import 'package:petcare_store_owner/src/layers/data/auth_repository.dart';
import 'package:petcare_store_owner/src/layers/data/user_repository.dart';
import '../../../../common_widgets/sign_in_button.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';

class SignInScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lightGray,
              AppColors.lightGray.withOpacity(0.0),
            ],
          ),
          image: const DecorationImage(
            alignment: Alignment.topCenter,
            fit: BoxFit.fitHeight,
            image: AssetImage('assets/images/sign_in.png'),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: proportionateHeight(150),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: proportionateWidth(10)),
                  child: Column(
                    children: [
                      SizedBox(height: proportionateHeight(20)),
                      Text(
                        "Sign in / Sign up",
                        style: AppTextStyles.titleBold(20, kTextColor),
                      ),
                      SizedBox(height: proportionateHeight(20)),
                      SignInButton(
                        logoUrl: 'assets/images/google-logo.png',
                        method: "Google",
                        press: () async {
                          await ref
                              .read(authRepositoryProvider)
                              .signInWithGoogle()
                              .then((_) {
                            ref
                                .read(userRepositoryProvider)
                                .checkIfUserIsNewToFirestore();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
