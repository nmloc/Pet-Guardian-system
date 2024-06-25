import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare_staff/src/constants/app_constants.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';
import 'package:petcare_staff/src/layers/presentation/screens/splash/splash_screen_controller.dart';
import 'package:petcare_staff/src/routing/app_router.dart';

import '../../common_widgets/primary_button.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Pet Care, Let’s shop!",
      "image": "assets/images/splash_1.png"
    },
    {
      "text": "We help people connect with store \naround Vietnam",
      "image": "assets/images/splash_2.png"
    },
    {
      "text": "We show the easy way to shop. \nJust stay at home with us",
      "image": "assets/images/splash_3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => Column(
                    children: <Widget>[
                      Spacer(),
                      Text(
                        "Pet Care",
                        style: TextStyle(
                          fontSize: proportionateWidth(36),
                          // color: kPrimaryColor,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        splashData[index]["text"]!,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 2),
                      Image.asset(
                        splashData[index]["image"]!,
                        height: proportionateHeight(265),
                        width: proportionateWidth(235),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: proportionateWidth(20)),
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                          (index) => AnimatedContainer(
                            duration: kAnimationDuration,
                            margin: EdgeInsets.only(right: 5),
                            height: 6,
                            width: currentPage == index ? 20 : 6,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? kPrimaryColor
                                  : Color(0xFFD8D8D8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                      PrimaryButton(
                        text: "Continue",
                        press: () async {
                          await ref
                              .read(splashScreenControllerProvider.notifier)
                              .completeSplash();
                          if (context.mounted) {
                            context.goNamed(AppRoute.signIn.name);
                          }
                        },
                        enable: true,
                      ),
                      const Spacer(),
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
