import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';

class GetStartBtn extends StatelessWidget {
  final String text;
  final Function() onTap;

  const GetStartBtn({
    super.key,
    required this.pageController,
    required this.text,
    required this.onTap,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return DelayedWidget(
      delayDuration: const Duration(milliseconds: 650),
      animationDuration: const Duration(seconds: 1),
      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
      child: SizedBox(
        width: 120.0,
        height: 45.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )),
          onPressed: onTap,
          child: Text(text),
        ),
      ),
    );
  }
}
