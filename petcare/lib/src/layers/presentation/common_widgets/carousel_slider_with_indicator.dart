// ignore_for_file: library_private_types_in_public_api

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';

class CarouselSliderWithIndicator extends ConsumerStatefulWidget {
  const CarouselSliderWithIndicator({
    Key? key,
    required this.list,
    required this.items,
  }) : super(key: key);
  final List list;
  final List<Widget> items;

  @override
  _CarouselSliderWithIndicatorState createState() =>
      _CarouselSliderWithIndicatorState();
}

class _CarouselSliderWithIndicatorState
    extends ConsumerState<CarouselSliderWithIndicator> {
  int _carouselIndex = 0;
  late List _list;
  late List<Widget> _items;

  @override
  void initState() {
    super.initState();
    _list = widget.list;
    _items = widget.items;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 0.88,
            enableInfiniteScroll: false,
            // autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() => _carouselIndex = index);
            },
          ),
          items: _items,
        ),
        SizedBox(height: proportionateHeight(8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _list.asMap().entries.map((entry) {
            return _carouselIndex == entry.key
                ? Container(
                    width: proportionateWidth(22),
                    height: proportionateHeight(6),
                    decoration: BoxDecoration(
                      color: AppColors.yellow500,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  )
                : Container(
                    width: proportionateWidth(6),
                    height: proportionateHeight(6),
                    margin: EdgeInsets.symmetric(
                      vertical: proportionateHeight(8),
                      horizontal: proportionateWidth(2),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.grey200,
                    ),
                  );
          }).toList(),
        ),
      ],
    );
  }
}
