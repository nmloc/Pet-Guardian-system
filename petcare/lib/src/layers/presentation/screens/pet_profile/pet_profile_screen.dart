import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/presentation/common_widgets/appbar_with_pet.dart';
import 'package:petcare/src/layers/presentation/screens/pet_profile/components/grooming/grooming_tab.dart';
import 'package:petcare/src/layers/presentation/screens/pet_profile/components/insurance/insurance_tab.dart';
import 'package:petcare/src/layers/presentation/screens/pet_profile/components/vaccines/vaccines_tab.dart';

import 'components/about_tab.dart';

class PetProfileScreen extends ConsumerStatefulWidget {
  const PetProfileScreen({Key? key}) : super(key: key);

  @override
  _PetProfileScreenState createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends ConsumerState<PetProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Tab customTab(String title) => Tab(
          child: Container(
            alignment: Alignment.bottomCenter,
            height: proportionateHeight(40),
            width: proportionateWidth(100),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.blue500),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
              ),
            ),
          ),
        );

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Section 1 - Custom Appbar
              AppBarWithPet(),

              SizedBox(
                height: proportionateHeight(55),
                child: TabBar(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  dividerColor: Colors.transparent,
                  isScrollable: true,
                  padding: EdgeInsets.only(top: proportionateHeight(12)),
                  indicatorColor: AppColors.lightBackground,
                  labelColor: Colors.white,
                  labelStyle: AppTextStyles.bodySemiBold(14, Colors.white),
                  unselectedLabelColor: AppColors.grey600,
                  unselectedLabelStyle:
                      AppTextStyles.bodyMedium(14, AppColors.grey600),
                  physics: const ClampingScrollPhysics(),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.blue500,
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: <Widget>[
                    customTab('About'),
                    customTab('Insurance'),
                    customTab('Vaccines'),
                    customTab('Grooming'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    AboutTab(),
                    InsuranceTab(),
                    VaccinesTab(),
                    GroomingTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
