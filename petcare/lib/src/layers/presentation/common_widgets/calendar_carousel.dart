import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/utils/int.dart';

// ignore: must_be_immutable
class CalendarCarousel extends ConsumerStatefulWidget {
  DateTime initialDate;
  StateProvider<DateTime> selectedDateProvider;

  CalendarCarousel({
    super.key,
    required this.initialDate,
    required this.selectedDateProvider,
  });

  @override
  _CalendarCarouselState createState() => _CalendarCarouselState();
}

class _CalendarCarouselState extends ConsumerState<CalendarCarousel> {
  final DateTime _now = DateTime.now();
  late int _daysInCurrentMonthYear;
  List<int> daysInMonth = [];

  @override
  void initState() {
    super.initState();
    _daysInCurrentMonthYear = DateTime(_now.year, _now.month + 1, 0).day;
    for (int day = 1; day <= _daysInCurrentMonthYear; day++) {
      daysInMonth.add(day);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<String> getFormattedDateList(DateTime date) =>
      DateFormat('EEEE, dd MMMM').format(date).split(', ');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
          child: Row(
            children: [
              Text(
                "${getFormattedDateList(widget.initialDate)[0]}, ",
                style: AppTextStyles.titleBold(26, AppColors.grey800),
              ),
              Text(
                getFormattedDateList(widget.initialDate)[1],
                style: AppTextStyles.titleRegular(26, AppColors.grey800),
              ),
            ],
          ),
        ),
        SizedBox(height: proportionateHeight(16)),
        CarouselSlider(
          options: CarouselOptions(
            height: proportionateHeight(60),
            viewportFraction: 0.15,
            enableInfiniteScroll: false,
            pageSnapping: false,
            initialPage: _now.day - 1,
            onPageChanged: (index, reason) => setState(() {
              DateTime _selectedDate =
                  DateTime(_now.year, _now.month, index + 1);
              widget.initialDate = _selectedDate;
              ref.read(widget.selectedDateProvider.notifier).state =
                  _selectedDate;
            }),
          ),
          items: daysInMonth
              .map((day) => _DateItemWidget(
                    day: day,
                    weekday: DateTime(
                      _now.year,
                      _now.month,
                      day,
                    ).weekday,
                    isSelected: widget.initialDate.day == day,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _DateItemWidget extends StatelessWidget {
  final int day;
  final int weekday;
  final bool isSelected;

  const _DateItemWidget({
    super.key,
    required this.day,
    required this.weekday,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: proportionateWidth(45),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.blue100 : AppColors.grey0,
        border: Border.all(
            color: isSelected ? AppColors.blue500 : AppColors.grey150),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isSelected
              ? Text(
                  day.toString(),
                  style: AppTextStyles.bodySemiBold(16, AppColors.blue500),
                )
              : Text(
                  day.toString(),
                  style: AppTextStyles.bodyMedium(16, AppColors.grey700),
                ),
          SizedBox(height: proportionateHeight(4)),
          isSelected
              ? Text(
                  weekday.toDayOfWeek(isShorten: true),
                  style: AppTextStyles.bodySemiBold(12, AppColors.blue500),
                )
              : Text(
                  weekday.toDayOfWeek(isShorten: true),
                  style: AppTextStyles.bodyRegular(12, AppColors.grey500),
                ),
        ],
      ),
    );
  }
}
