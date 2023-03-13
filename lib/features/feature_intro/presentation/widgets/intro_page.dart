import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class IntroPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const IntroPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    // get size device
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // image
        Center(
          child: DelayedWidget(
            delayDuration: const Duration(milliseconds: 200),
            animationDuration: const Duration(seconds: 1),
            animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
            child: Image.asset(image, width: width * 0.9, height: height * 0.6),
          ),
        ),
        const SizedBox(height: 25),
        // title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: height * 0.03),
          child: DelayedWidget(
            delayDuration: const Duration(milliseconds: 400),
            animationDuration: const Duration(seconds: 1),
            animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: height * 0.025, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: height * 0.015),
        // description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: height * 0.03),
          child: DelayedWidget(
            delayDuration: const Duration(milliseconds: 600),
            animationDuration: const Duration(seconds: 1),
            animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
            child: Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: Colors.grey,
              child: Text(
                description,
                style: TextStyle(fontSize: height * 0.02),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
