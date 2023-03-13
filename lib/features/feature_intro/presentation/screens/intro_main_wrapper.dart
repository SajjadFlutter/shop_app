import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/features/feature_intro/presentation/bloc/intro_cubit/intro_cubit.dart';
import 'package:shop_app/features/feature_intro/presentation/widgets/get_start_btn.dart';
import 'package:shop_app/features/feature_intro/presentation/widgets/intro_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroMainWrapper extends StatelessWidget {
  static String routeName = '/intro_main_wrapper';
  IntroMainWrapper({super.key});

  final PageController pageController = PageController();

  final List<Widget> introPages = const [
    IntroPage(
      title: 'تخصص حرف اول رو میزنه!',
      description:
          'اپلیکیشن تخصصی خرید و فروش انواع قطعات یدکی خودروهای داخلی و خارجی با ضمانت اصالت کالا و نازلترین قیمت',
      image: "assets/images/benz.png",
    ),
    IntroPage(
      title: 'آسان خرید و فروش کن!',
      description: 'خرید و فروش سریع و آسان همراه با تیم پشتیبانی قوی',
      image: "assets/images/bmw.png",
    ),
    IntroPage(
      title: 'همه چی اینجا هست!',
      description: 'ثبت قطعات کمیاب و خرید و فروش عمده تنها با یک کلیک',
      image: "assets/images/tara.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // get size device
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => IntroCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: Stack(
            children: [
              // red color box
              Positioned(
                top: 0,
                child: Container(
                  width: width,
                  height: height * 0.6,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(150.0),
                    ),
                  ),
                ),
              ),

              // page view
              Positioned(
                child: PageView(
                  controller: pageController,
                  children: introPages,
                  onPageChanged: (page) {
                    if (page == 2) {
                      BlocProvider.of<IntroCubit>(context).changeGetStart(true);
                    } else {
                      BlocProvider.of<IntroCubit>(context)
                          .changeGetStart(false);
                    }
                  },
                ),
              ),

              // btn
              Positioned(
                bottom: height * 0.03,
                right: height * 0.03,
                child: BlocBuilder<IntroCubit, IntroState>(
                  builder: (context, state) {
                    if (state.showGetStart) {
                      return GetStartBtn(
                        pageController: pageController,
                        text: 'شروع کن',
                        onTap: () {
                          print('ok');
                        },
                      );
                    } else {
                      return GetStartBtn(
                        pageController: pageController,
                        text: 'ورق بزن',
                        onTap: () {
                          if (pageController.page!.toInt() < 2) {
                            if (pageController.page!.toInt() == 1) {
                              BlocProvider.of<IntroCubit>(context)
                                  .changeGetStart(true);
                            }
                            pageController.animateToPage(
                              pageController.page!.toInt() + 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),

              // page indicator
              Positioned(
                bottom: height * 0.03,
                left: height * 0.03,
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: introPages.length,
                  effect: ExpandingDotsEffect(
                    dotWidth: width * 0.02,
                    dotHeight: width * 0.02,
                    spacing: 5.0,
                    activeDotColor: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
