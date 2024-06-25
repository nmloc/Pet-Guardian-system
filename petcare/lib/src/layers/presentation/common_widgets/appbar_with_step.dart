import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';

class AppBarWithStep extends ConsumerWidget {
  const AppBarWithStep({
    Key? key,
    required this.title,
    required this.stepName,
    required this.step,
    required this.totalStep,
    required this.press,
  }) : super(key: key);

  final String title;
  final String stepName;
  final int step;
  final int totalStep;
  final VoidCallback press;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: proportionateWidth(38),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.grey600,
                    size: 20,
                  ),
                  onPressed: press,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: AppTextStyles.titleBold(16, AppColors.grey800)),
                  Text(stepName,
                      style: AppTextStyles.bodyRegular(14, AppColors.grey600)),
                ],
              ),
              SizedBox(
                width: proportionateWidth(38),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Step',
                        style:
                            AppTextStyles.bodyRegular(12, AppColors.grey800)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(step.toString(),
                            style: AppTextStyles.bodySemiBold(
                                12, AppColors.grey800)),
                        Text('/${totalStep}',
                            style: AppTextStyles.bodyRegular(
                                12, AppColors.grey400)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: proportionateHeight(12)),
          LinearProgressIndicator(
            value: step / totalStep,
            backgroundColor: AppColors.grey150,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellow500),
            minHeight: proportionateHeight(6),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ],
      ),
    );
  }
}
