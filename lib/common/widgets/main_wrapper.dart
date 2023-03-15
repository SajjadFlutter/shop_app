import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/bottom_nav.dart';
import 'package:shop_app/features/feature_home/presentation/screens/home_screen.dart';
import 'package:shop_app/features/feature_home/presentation/screens/profile_screen.dart';
import 'package:shop_app/features/feature_product/presentation/screens/category_screen.dart';

class MainWrapper extends StatelessWidget {
  static String routeName = '/main_wrapper';
  MainWrapper({super.key});

  final PageController pageController = PageController();

  final List<Widget> topLevelScreens = [
    const HomeScreen(),
    const CategoryScreen(),
    ProfileScreen(),
    Container(color: Colors.amber),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: topLevelScreens,
      ),
      bottomNavigationBar: BottomNav(controller: pageController),
    );
  }
}
