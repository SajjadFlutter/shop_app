import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/bottom_nav.dart';
import 'package:shop_app/common/widgets/search_textfield.dart';
import 'package:shop_app/features/feature_home/presentation/screens/home_screen.dart';
import 'package:shop_app/features/feature_home/presentation/screens/profile_screen.dart';
import 'package:shop_app/features/feature_product/presentation/screens/category_screen.dart';
import 'package:shop_app/features/feature_product/repository/all_products_repository.dart';
import 'package:shop_app/locator.dart';

class MainWrapper extends StatelessWidget {
  static String routeName = '/main_wrapper';
  MainWrapper({super.key});

  final PageController pageController = PageController();
  final TextEditingController searchController = TextEditingController();

  final List<Widget> topLevelScreens = [
    const HomeScreen(),
    const CategoryScreen(),
    ProfileScreen(),
    Container(color: Colors.amber),
  ];

  @override
  Widget build(BuildContext context) {
    // get size device
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // search box
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color: Colors.grey.shade400,
                  offset: const Offset(0, 3),
                ),
              ]),
              child: Padding(
                padding:
                    const EdgeInsets.all(10.0),
                child: SearchTextField(
                  controller: searchController,
                  allProductsRepository: locator<AllProductsRepository>(),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: topLevelScreens,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(controller: pageController),
    );
  }
}
