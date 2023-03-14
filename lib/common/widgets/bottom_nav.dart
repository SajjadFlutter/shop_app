import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/common/bloc/bottom_nav_cubit/bottom_nav_cubit.dart';

class BottomNav extends StatelessWidget {
  final PageController controller;

  const BottomNav({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 70.0,
          child: BlocBuilder<BottomNavCubit, int>(
            builder: (context, state) {
              return Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 70.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<BottomNavCubit>(context)
                                    .changeIndexBottomNav(0);

                                controller.animateToPage(0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              icon: Image.asset(
                                state == 0
                                    ? 'assets/images/home_icon.png'
                                    : 'assets/images/home_icon2.png',
                                color: state == 0
                                    ? Colors.redAccent
                                    : Colors.grey.shade700,
                                width: 40.0,
                              ),
                            ),
                            Text(
                              'بیسینیور',
                              style: TextStyle(
                                  fontFamily: 'yekan',
                                  color: Colors.grey.shade700),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<BottomNavCubit>(context)
                                    .changeIndexBottomNav(1);

                                controller.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              icon: Image.asset(
                                state == 1
                                    ? 'assets/images/category_icon.png'
                                    : 'assets/images/category_icon2.png',
                                color: state == 1
                                    ? Colors.redAccent
                                    : Colors.grey.shade700,
                                width: 40.0,
                              ),
                            ),
                            Text(
                              'دسته بندی',
                              style: TextStyle(
                                  fontFamily: 'yekan',
                                  color: Colors.grey.shade700),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 70.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<BottomNavCubit>(context)
                                    .changeIndexBottomNav(2);

                                controller.animateToPage(2,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              icon: SvgPicture.asset(
                                state == 2
                                    ? 'assets/images/person_icon.svg'
                                    : 'assets/images/person_icon2.svg',
                                // ignore: deprecated_member_use
                                color: state == 2
                                    ? Colors.redAccent
                                    : Colors.grey.shade700,
                                width: 40.0,
                              ),
                            ),
                            Text(
                              'حساب کاربری',
                              style: TextStyle(
                                  fontFamily: 'yekan',
                                  color: Colors.grey.shade700),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<BottomNavCubit>(context)
                                    .changeIndexBottomNav(3);

                                controller.animateToPage(3,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              icon: Icon(
                                state == 3
                                    ? Icons.shopping_cart
                                    : Icons.shopping_cart_outlined,
                                color: state == 3
                                    ? Colors.redAccent
                                    : Colors.grey.shade700,
                                size: 32.0,
                              ),
                            ),
                            Text(
                              'سبد خرید',
                              style: TextStyle(
                                  fontFamily: 'yekan',
                                  color: Colors.grey.shade700),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
