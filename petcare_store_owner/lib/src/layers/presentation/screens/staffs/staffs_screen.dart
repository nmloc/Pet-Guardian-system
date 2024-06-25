import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare_store_owner/src/common_widgets/bottom_button_area.dart';
import 'package:petcare_store_owner/src/common_widgets/card_container.dart';
import 'package:petcare_store_owner/src/common_widgets/secondary_button.dart';
import 'package:petcare_store_owner/src/constants/app_colors.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';
import 'package:petcare_store_owner/src/common_widgets/appbar_basic.dart';
import 'package:petcare_store_owner/src/constants/app_text_styles.dart';
import 'package:petcare_store_owner/src/layers/data/staff_repository.dart';
import 'package:petcare_store_owner/src/layers/domain/staff.dart';
import 'package:petcare_store_owner/src/layers/presentation/screens/staffs/staffs_lazy_load.dart';

class StaffsScreen extends ConsumerWidget {
  StaffsScreen({super.key});

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lazyLoadAsync = ref.watch(staffsLazyLoadProvider);
    bool _hasMore = ref.watch(staffsLazyLoadProvider.notifier).hasMore;
    bool isInitialFetching =
        lazyLoadAsync.isLoading && (lazyLoadAsync.value ?? []).isEmpty;
    bool isFetchingMore =
        lazyLoadAsync.isLoading && (lazyLoadAsync.value ?? []).isNotEmpty;

    _scrollController.addListener(() {
      bool isBottom = _scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          _scrollController.position.outOfRange;
      if (isBottom && _hasMore && !isFetchingMore) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ref.read(staffsLazyLoadProvider.notifier).fetchMore();
        });
      }
    });

    Widget staffListWidget(List<Staff> staffs) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
        controller: _scrollController,
        itemCount: staffs.length + (isFetchingMore ? 1 : 0),
        separatorBuilder: (context, index) =>
            SizedBox(height: proportionateHeight(16)),
        itemBuilder: (context, index) {
          if (staffs.length == index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: proportionateHeight(30)),
              child: const CupertinoActivityIndicator(),
            );
          }

          final staff = staffs[index];
          return Dismissible(
            key: Key(staff.uid),
            background: CardContainer(
                background: AppColors.red500, enableShadow: false),
            onDismissed: (direction) => ref
                .read(staffRepositoryProvider)
                .remove(staff.branchId, staff.email)
                .then(
                  (_) => Fluttertoast.showToast(
                    msg: staff.displayName == ''
                        ? 'Removed staff ${staff.email}.'
                        : 'Removed staff ${staff.displayName}.',
                    backgroundColor: AppColors.blue500,
                    timeInSecForIosWeb: 4,
                  ),
                ),
            child: CardContainer(
              enableShadow: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: proportionateWidth(27),
                        foregroundImage: staff.photoURL != ""
                            ? NetworkImage(staff.photoURL)
                            : Image.asset('assets/images/blank-avatar.jpg')
                                .image,
                      ),
                      SizedBox(width: proportionateWidth(10)),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          staff.displayName != ""
                              ? Text(
                                  staff.displayName,
                                  style: AppTextStyles.bodySemiBold(
                                      14, AppColors.grey800),
                                )
                              : Text(
                                  'Pending Registration',
                                  style: AppTextStyles.bodySemiBold(
                                      14, AppColors.yellow500),
                                ),
                          SizedBox(width: proportionateWidth(2)),
                          Text(
                            staff.email,
                            style: AppTextStyles.bodyRegular(
                                14, AppColors.grey700),
                          ),
                        ],
                      )
                    ],
                  ),
                  if (staff.displayName != "")
                    Icon(
                      CupertinoIcons.chevron_forward,
                      size: 20,
                      color: AppColors.grey400,
                    )
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Section 1 - Custom Appbar
            const BasicAppBar(title: 'Staffs'),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: proportionateWidth(24),
                vertical: proportionateHeight(16),
              ),
              child: const CupertinoSearchTextField(
                placeholder: 'Search by staff ID',
              ),
            ),

            Expanded(
              child: isInitialFetching
                  ? const Center(child: CupertinoActivityIndicator())
                  : lazyLoadAsync.asData != null &&
                          (lazyLoadAsync.value ?? []).isEmpty
                      ? const Center(child: Text('Your store has no staff.'))
                      : staffListWidget(lazyLoadAsync.value!),
            ),

            BottomButtonArea(
              height: proportionateHeight(114),
              child: SecondaryButton(
                iconData: CupertinoIcons.add,
                text: 'Add new staff',
                press: () => showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text("Fill in the new staff's email."),
                    ),
                    content: CupertinoTextField(
                      controller: _emailController,
                      autofocus: true,
                      autocorrect: false,
                      placeholder: 'Email address',
                    ),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () => context.pop(),
                        child: const Text('Cancel'),
                      ),
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () async => await ref
                            .read(staffRepositoryProvider)
                            .addStaff(_emailController.text)
                            .then((_) {
                          _emailController.clear();
                          context.pop();
                        }),
                        child: Text(
                          'Add',
                          style:
                              AppTextStyles.bodyRegular(16, AppColors.blue500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
