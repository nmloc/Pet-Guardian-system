import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petcare_store_owner/src/common_widgets/appbar_basic.dart';
import 'package:petcare_store_owner/src/common_widgets/bottom_button_area.dart';
import 'package:petcare_store_owner/src/common_widgets/primary_button.dart';
import 'package:petcare_store_owner/src/constants/app_colors.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';
import 'package:petcare_store_owner/src/constants/app_text_styles.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:petcare_store_owner/src/utils/string.dart';

List<String> _categories = ['Grooming', 'Vaccine', 'Insurance'];
final _generatedMonthsProvider =
    StateProvider.autoDispose<List<int>>((ref) => []);
final _predictionProvider =
    StateProvider.autoDispose<List<double>>((ref) => []);
final _categoryProvider =
    StateProvider.autoDispose<String>((ref) => 'Grooming');

class DemandForecastScreen extends ConsumerWidget {
  DemandForecastScreen({super.key});
  final TextEditingController periodController = TextEditingController();

  Future<String> predict(List<Map<String, dynamic>> data) async {
    final response = await http.post(
      Uri.parse('https://function-1-zckl7wg2pa-uc.a.run.app'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to call Cloud Function');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, dynamic>> generateData(String category, int periods) {
      List<Map<String, dynamic>> data = [];

      // Get current year and month
      DateTime now = DateTime.now();
      int currentYear = now.year;
      int currentMonth = now.month;

      // Generate data for the next numberOfMonths months
      for (int i = 1; i <= periods; i++) {
        int year = currentYear;
        int month = currentMonth + i;

        // Adjust year and month if needed
        if (month > 12) {
          year += (month ~/ 12);
          month = month % 12;
        }

        // Add data for the current month
        data.add({
          "year": year,
          "month": month,
          "itemCategory": category,
        });
        ref.read(_generatedMonthsProvider.notifier).state.add(month);
      }

      return data;
    }

    void _showDialog(Widget child) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                spreadRadius: 1,
                blurRadius: 3.75,
              ),
            ],
          ),
          height: proportionateHeight(200),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const BasicAppBar(title: 'Demand Forecast'),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: proportionateHeight(20)),
                    const Text(
                      'Sales',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    BarChart(),
                    const Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Month',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomButtonArea(
                height: proportionateWidth(200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category',
                                style: AppTextStyles.bodySemiBold(
                                    16, AppColors.grey800)),
                            SizedBox(height: proportionateHeight(5)),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    ref.watch(_categoryProvider),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: CupertinoColors.black,
                                    ),
                                  ),
                                  SizedBox(width: proportionateWidth(10)),
                                  const Icon(
                                    CupertinoIcons.chevron_down,
                                    size: 16,
                                  )
                                ],
                              ),
                              onPressed: () => _showDialog(
                                CupertinoPicker(
                                    magnification: 1.22,
                                    squeeze: 1.2,
                                    useMagnifier: true,
                                    itemExtent: 32,
                                    onSelectedItemChanged: (int index) => ref
                                        .read(_categoryProvider.notifier)
                                        .state = _categories[index],
                                    children: _categories
                                        .map((value) =>
                                            Center(child: Text(value)))
                                        .toList()),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Periods',
                                style: AppTextStyles.bodySemiBold(
                                    16, AppColors.grey800)),
                            SizedBox(height: proportionateHeight(10)),
                            SizedBox(
                              width: proportionateWidth(80),
                              child: CupertinoTextField(
                                controller: periodController,
                                autofocus: true,
                                autocorrect: false,
                                placeholder: 'months',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    PrimaryButton(
                        text: 'Predict',
                        press: () async {
                          ref
                              .read(_generatedMonthsProvider.notifier)
                              .state
                              .clear();
                          final result = await predict(generateData(
                              ref.read(_categoryProvider),
                              int.parse(periodController.text)));
                          ref.read(_predictionProvider.notifier).state =
                              result.toDoubleList();
                        },
                        enable: true),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class BarChart extends ConsumerWidget {
  BarChart({super.key});

  final List<Color> gradientColors = [
    AppColors.chartCyan,
    AppColors.chartBlue,
  ];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    double formattedValue() {
      if (value >= 1 && value <= 12) {
        return value;
      } else {
        return ((value - 1) % 12) + 1;
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        formattedValue().toInt().toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 10:
        text = '10';
        break;
      case 30:
        text = '30';
        break;
      case 50:
        text = '50';
        break;
      case 70:
        text = '70';
        break;
      case 90:
        text = '90';
        break;
      default:
        return Container();
    }

    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      textAlign: TextAlign.left,
    );
  }

  final double _minX = (DateTime.now().month + 1).toDouble();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AspectRatio(
      aspectRatio: 0.9,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: AppColors.mainGridLine,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: AppColors.mainGridLine,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 28,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          minX: _minX,
          maxX:
              _minX + ref.watch(_generatedMonthsProvider).length.toDouble() - 1,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: ref
                  .watch(_predictionProvider)
                  .asMap()
                  .entries
                  .map((entry) =>
                      FlSpot(entry.key.toDouble() + _minX, entry.value))
                  .toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: const FlDotData(
                show: true,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
