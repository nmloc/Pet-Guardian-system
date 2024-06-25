import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare_staff/src/constants/app_colors.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';
import 'package:petcare_staff/src/constants/app_text_styles.dart';

class DropdownAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DropdownAppBar({
    Key? key,
    required this.items,
    required this.currentItem,
    required this.onChanged,
  }) : super(key: key);
  final List<String> items;
  final String currentItem;
  final void Function(String?)? onChanged;

  @override
  _DropdownAppBarState createState() => _DropdownAppBarState();

  @override
  Size get preferredSize => const Size(double.infinity, 60);
}

class _DropdownAppBarState extends State<DropdownAppBar> {
  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Center(
              child: Text(
                item,
                style: AppTextStyles.titleBold(18, AppColors.grey800),
              ),
            ),
          ),
          if (item != items.last)
            DropdownMenuItem<String>(
              enabled: false,
              child: Divider(thickness: 1, color: AppColors.grey500),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<double> _getCustomItemsHeights() {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (widget.items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        alignment: Alignment.centerLeft,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.grey600,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
      title: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            items: _addDividersAfterItems(widget.items),
            value: widget.currentItem,
            onChanged: widget.onChanged,
            buttonStyleData: ButtonStyleData(
              height: proportionateHeight(40),
              width: proportionateWidth(90),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                CupertinoIcons.chevron_down,
                size: 16,
                color: AppColors.grey800,
              ),
              openMenuIcon: Icon(
                CupertinoIcons.chevron_up,
                size: 16,
                color: AppColors.grey800,
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: AppSizes.screenHeight,
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.grey150),
              offset: Offset(0, proportionateHeight(-8)),
              elevation: 0,
            ),
            menuItemStyleData: MenuItemStyleData(
              customHeights: _getCustomItemsHeights(),
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(proportionateHeight(14)),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                AppColors.radial,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
