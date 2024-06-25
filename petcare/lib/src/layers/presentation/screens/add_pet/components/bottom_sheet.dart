import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/utils/datetime.dart';

import '../../../common_widgets/primary_button.dart';

class Month {
  int num;
  String name;

  Month({required this.num, required this.name});
}

class BottomSheetContent extends ConsumerStatefulWidget {
  final int tabIndex;

  const BottomSheetContent({
    Key? key,
    required this.tabIndex,
  }) : super(key: key);

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends ConsumerState<BottomSheetContent>
    with TickerProviderStateMixin {
  List<Month> monthsList = [
    Month(num: 1, name: 'January'),
    Month(num: 2, name: 'February'),
    Month(num: 3, name: 'March'),
    Month(num: 4, name: 'April'),
    Month(num: 5, name: 'May'),
    Month(num: 6, name: 'June'),
    Month(num: 7, name: 'July'),
    Month(num: 8, name: 'August'),
    Month(num: 9, name: 'September'),
    Month(num: 10, name: 'October'),
    Month(num: 11, name: 'November'),
    Month(num: 12, name: 'December'),
  ];
  List<int> yearsList =
      List.generate(30, (index) => DateTime.now().year + 1 - (30 - index));
  late TabController _tabController;
  late StateProvider<int> _yearProvider;
  late StateProvider<int> _monthProvider;
  late StateProvider<int> _dayProvider;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: widget.tabIndex, length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    final DateTime date = widget.tabIndex == 0
        ? ref.read(newPetProvider).birthDate
        : ref.read(newPetProvider).adoptionDate;
    _yearProvider = StateProvider<int>(
        (ref) => date.isDefault() ? DateTime.now().year : date.year);
    _monthProvider = StateProvider<int>(
        (ref) => date.isDefault() ? DateTime.now().month : date.month);
    _dayProvider = StateProvider<int>(
        (ref) => date.isDefault() ? DateTime.now().day : date.day);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey0,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26),
          ),
        ),
        height: proportionateHeight(650),
        child: Column(
          children: [
            SizedBox(
              height: proportionateHeight(54),
              child: TabBar(
                controller: _tabController,
                padding:
                    EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
                unselectedLabelColor: AppColors.grey600,
                unselectedLabelStyle:
                    AppTextStyles.bodyMedium(14, AppColors.grey600),
                labelColor: AppColors.yellow500,
                labelStyle: AppTextStyles.bodyBold(14, AppColors.yellow500),
                indicatorColor: AppColors.yellow500,
                indicatorWeight: 3,
                tabs: <Widget>[
                  _buildTab('cake', 'Birth date', 0),
                  _buildTab('house', 'Adoption date', 1),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildBottomSheetContent(),
                  _buildBottomSheetContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String iconName, String tabName, int tabIndex) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tabController.index == tabIndex
              ? Image.asset('assets/icons/$iconName-yellow.png',
                  height: proportionateHeight(14),
                  width: proportionateWidth(14))
              : Image.asset('assets/icons/$iconName-grey.png',
                  height: proportionateHeight(14),
                  width: proportionateWidth(14)),
          SizedBox(width: proportionateWidth(6)),
          Text(tabName),
        ],
      ),
    );
  }

  Widget _buildBottomSheetContent() {
    return Column(
      children: [
        SizedBox(height: proportionateHeight(24)),
        // Section 1 - Year Slider
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: proportionateHeight(46),
              width: proportionateWidth(84),
              decoration: BoxDecoration(
                color: AppColors.blue100.withOpacity(0.5),
                border: Border.all(color: AppColors.blue100),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: proportionateHeight(46),
                viewportFraction: 0.2,
                initialPage: yearsList.indexOf(ref.read(_yearProvider)),
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  ref.read(_yearProvider.notifier).state = yearsList[index];
                  ref.read(_dayProvider.notifier).state = 0;
                },
              ),
              items: List.generate(
                yearsList.length,
                (index) => Container(
                  height: proportionateHeight(46),
                  width: proportionateWidth(84),
                  alignment: Alignment.center,
                  child: Text(
                    yearsList[index].toString(),
                    style: index == yearsList.indexOf(ref.watch(_yearProvider))
                        ? AppTextStyles.bodySemiBold(26, AppColors.blue500)
                        : AppTextStyles.bodyMedium(20, AppColors.grey600),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: proportionateHeight(24)),
          child: Divider(
            thickness: 1,
            color: AppColors.grey150,
            indent: proportionateWidth(24),
            endIndent: proportionateWidth(24),
          ),
        ),
        // Section 2 - Month Slider
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: proportionateHeight(46),
              width: proportionateWidth(158),
              decoration: BoxDecoration(
                color: AppColors.blue100.withOpacity(0.5),
                border: Border.all(color: AppColors.blue100),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: proportionateHeight(46),
                viewportFraction: 0.4,
                initialPage: monthsList.indexWhere(
                    (month) => month.num == ref.read(_monthProvider)),
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  ref.read(_dayProvider.notifier).state = 0;
                  ref.read(_monthProvider.notifier).state =
                      monthsList[index].num;
                },
              ),
              items: List.generate(
                monthsList.length,
                (index) => Container(
                  height: proportionateHeight(46),
                  width: proportionateWidth(158),
                  alignment: Alignment.center,
                  child: Text(
                    monthsList[index].name,
                    style: index ==
                            monthsList.indexWhere((month) =>
                                month.num == ref.watch(_monthProvider))
                        ? AppTextStyles.bodySemiBold(26, AppColors.blue500)
                        : AppTextStyles.bodyMedium(20, AppColors.grey600),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: proportionateHeight(24)),
        Divider(
          thickness: 1,
          color: AppColors.grey150,
          indent: proportionateWidth(24),
          endIndent: proportionateWidth(24),
        ),

        // Section 3 - Date Picker
        Padding(
            padding: EdgeInsets.symmetric(horizontal: proportionateWidth(12)),
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                firstDate: DateTime(
                    ref.watch(_yearProvider), ref.watch(_monthProvider), 1),
                lastDate: DateTime(
                    ref.watch(_yearProvider), ref.watch(_monthProvider) + 1, 0),
                nextMonthIcon: const Icon(null),
                lastMonthIcon: const Icon(null),
                weekdayLabels: [
                  'Sun',
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat'
                ],
                weekdayLabelTextStyle:
                    AppTextStyles.bodyRegular(12, AppColors.grey500),
                firstDayOfWeek: 1,
                controlsHeight: 20,
                controlsTextStyle: const TextStyle(fontSize: 0),
                dayTextStyle: AppTextStyles.bodyMedium(16, AppColors.grey700),
                selectedDayTextStyle:
                    AppTextStyles.bodySemiBold(16, AppColors.blue500),
                disabledDayTextStyle:
                    AppTextStyles.bodyMedium(16, AppColors.grey500),
                selectableDayPredicate: (day) {
                  final now = DateTime.now();
                  if (ref.watch(_yearProvider) == now.year &&
                      ref.watch(_monthProvider) == now.month) {
                    return day.day <= now.day;
                  } else if (ref.watch(_yearProvider) == now.year &&
                      ref.watch(_monthProvider) > now.month) {
                    return false;
                  }
                  return true;
                },
                disableModePicker: true,
                dayBuilder: ({
                  required date,
                  textStyle,
                  decoration,
                  isSelected,
                  isDisabled,
                  isToday,
                }) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDisabled!
                          ? AppColors.grey100
                          : isSelected!
                              ? AppColors.blue100.withOpacity(0.5)
                              : AppColors.grey0,
                      border: Border.all(
                          color: isSelected!
                              ? AppColors.blue100
                              : AppColors.grey150),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: textStyle,
                      ),
                    ),
                  );
                },
              ),
              value: [
                DateTime(
                  ref.watch(_yearProvider),
                  ref.watch(_monthProvider),
                  ref.watch(_dayProvider),
                )
              ],
              onValueChanged: (value) =>
                  ref.read(_dayProvider.notifier).state = value[0]!.day,
            )),
        SizedBox(height: proportionateHeight(24)),
        // Section 4 - Done Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
          child: PrimaryButton(
            text: 'Done',
            press: () {
              final newPetController = ref.read(newPetProvider.notifier);
              _tabController.index == 0
                  ? newPetController.updateBirthDate(DateTime(
                      ref.read(_yearProvider),
                      ref.read(_monthProvider),
                      ref.read(_dayProvider),
                    ))
                  : newPetController.updateAdoptionDate(DateTime(
                      ref.read(_yearProvider),
                      ref.read(_monthProvider),
                      ref.read(_dayProvider),
                    ));
              context.pop();
            },
            enable: true,
          ),
        ),
      ],
    );
  }
}
