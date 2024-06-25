import 'package:flutter/material.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_text_styles.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool? initiallyExpanded;
  final VisualDensity? visualDensity;
  final TextStyle? titleStyle;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.children,
    this.initiallyExpanded,
    this.visualDensity,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        visualDensity: visualDensity,
        tilePadding: EdgeInsets.zero,
        initiallyExpanded: initiallyExpanded ?? true,
        title: Text(
          title,
          style: titleStyle ?? AppTextStyles.bodySemiBold(16, AppColors.grey800),
        ),
        children: children,
      ),
    );
  }
}
