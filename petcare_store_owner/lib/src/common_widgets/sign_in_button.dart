import 'package:flutter/material.dart';

import 'package:petcare_store_owner/src/constants/app_constants.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';
import 'package:petcare_store_owner/src/constants/app_text_styles.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    Key? key,
    this.logoUrl,
    required this.method,
    required this.press,
  }) : super(key: key);
  final String? logoUrl;
  final String method;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: proportionateHeight(40),
      width: proportionateWidth(300),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor, width: proportionateWidth(2)),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: press,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (logoUrl != null)
              Image.asset(
                logoUrl!,
                height: proportionateHeight(20),
                width: proportionateWidth(20),
              ),
            if (logoUrl != null) SizedBox(width: proportionateWidth(10)),
            Text(
              'Sign in with $method',
              style: AppTextStyles.bodySemiBold(15, kTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
