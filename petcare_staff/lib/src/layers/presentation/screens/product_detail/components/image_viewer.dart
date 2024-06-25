import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageViewer extends StatefulWidget {
  final List<String> photoURL;
  ImageViewer({required this.photoURL});

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  PageController productImageSlider = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset(
            'assets/icons/Arrow-left.svg',
            color: Colors.white,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: [
          PageView(
            physics: BouncingScrollPhysics(),
            controller: productImageSlider,
            children: List.generate(
              widget.photoURL.length,
              (index) => Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  widget.photoURL[index],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // indicator
          Positioned(
            bottom: 16,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: SmoothPageIndicator(
                controller: productImageSlider,
                count: widget.photoURL.length,
                effect: ExpandingDotsEffect(
                  dotColor: Colors.white.withOpacity(0.2),
                  activeDotColor: Colors.white.withOpacity(0.2),
                  dotHeight: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
