import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/common/widgets/loading_animation.dart';
import 'package:shop_app/config/responsive.dart';
import 'package:shop_app/features/feature_home/data/models/home_model.dart';
import 'package:shop_app/features/feature_home/presentation/bloc/home_cubit/home_cubit.dart';
import 'package:shop_app/features/feature_home/presentation/widgets/deep_links.dart';
import 'package:shop_app/features/feature_home/repository/home_repository.dart';
import 'package:shop_app/locator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageViewController = PageController(initialPage: 0);
  int _currentSlide = 0;
  Timer? _timer;

  @override
  void dispose() {
    super.dispose();

    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    // get size device
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: BlocProvider(
        create: (context) => HomeCubit(locator<HomeRepository>()),
        child: Builder(builder: (context) {
          // call api
          BlocProvider.of<HomeCubit>(context).callHomeDataEvent();

          return BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) {
              if (previous.homeDataStatus == current.homeDataStatus) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              // Loading
              if (state.homeDataStatus is HomeDataLoading) {
                return const LoadingAnimation(size: 40.0);
              }
              // Completed
              if (state.homeDataStatus is HomeDataCompleted) {
                HomeDataCompleted homeDataCompleted =
                    state.homeDataStatus as HomeDataCompleted;
                HomeModel homeModel = homeDataCompleted.homeModel;

                _timer ??= Timer.periodic(
                  const Duration(seconds: 3),
                  (timer) {
                    if (_currentSlide < homeModel.data!.sliders!.length - 1) {
                      _currentSlide++;
                    } else {
                      _currentSlide = 0;
                    }

                    if (pageViewController.positions.isNotEmpty) {
                      pageViewController.animateToPage(_currentSlide,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    }
                  },
                );

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // sliders
                      homeModel.data!.sliders!.isNotEmpty
                          ? SizedBox(
                              width: width,
                              height: Responsive.isMobile(context) ? 180 : 320,
                              child: PageView.builder(
                                itemCount: homeModel.data!.sliders!.length,
                                controller: pageViewController,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: CachedNetworkImage(
                                        imageUrl: homeModel
                                            .data!.sliders![index].img!,
                                        placeholder: (context, url) =>
                                            const LoadingAnimation(size: 30.0),
                                        fit: BoxFit.fill,
                                        useOldImageOnUrlChange: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(),

                      // page indicator
                      homeModel.data!.sliders!.length > 1
                          ? SmoothPageIndicator(
                              controller: pageViewController,
                              count: homeModel.data!.sliders!.length,
                              effect: ExpandingDotsEffect(
                                dotHeight: width * 0.02,
                                dotWidth: width * 0.02,
                                activeDotColor: Colors.redAccent,
                                spacing: 5.0,
                              ),
                            )
                          : Container(),

                      SizedBox(height: height * 0.03),

                      // 8 categories
                      homeModel.data!.categories!.isNotEmpty
                          ? SizedBox(
                              height: 220,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemCount: homeModel.data!.categories!.length,
                                itemBuilder: (context, index) {
                                  final image =
                                      homeModel.data!.categories![index].img;
                                  final title =
                                      homeModel.data!.categories![index].title;

                                  return DeepLinks(
                                      image: image!, title: title!);
                                },
                              ),
                            )
                          : Container(),

                      SizedBox(height: height * 0.03),

                      /// middle banners
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: [
                            (homeModel.data!.banners!.isNotEmpty)
                                ? GestureDetector(
                                    onTap: () {
                                      // Navigator.pushNamed(context, SellerScreen.routeName);
                                      // if(homeModel.data!.banners![0].categoryId != null){
                                      //   Navigator.pushNamed(
                                      //     context,
                                      //     AllProductsScreen.routeName,
                                      //     arguments: ProductsArguments(categoryId: homeModel.data!.banners![0].categoryId!),);
                                      // }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            homeModel.data!.banners![0].image!,
                                        placeholder: (context, string) {
                                          return const LoadingAnimation(
                                              size: 35.0);
                                        },
                                        height: Responsive.isMobile(context)
                                            ? 160
                                            : 320,
                                        width: width,
                                        fit: BoxFit.cover,
                                        useOldImageOnUrlChange: true,
                                      ),
                                    ),
                                  )
                                : Container(),

                            SizedBox(height: height * 0.02),
                            //
                            (homeModel.data!.banners!.length > 1)
                                ? GestureDetector(
                                    onTap: () {
                                      // if(homeModel.data!.banners![1].categoryId != null){
                                      //   Navigator.pushNamed(
                                      //     context,
                                      //     AllProductsScreen.routeName,
                                      //     arguments: ProductsArguments(categoryId: homeModel.data!.banners![1].categoryId!),);
                                      // }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            homeModel.data!.banners![1].image!,
                                        placeholder: (context, string) {
                                          return const LoadingAnimation(
                                              size: 35.0);
                                        },
                                        height: Responsive.isMobile(context)
                                            ? 160
                                            : 320,
                                        width: width,
                                        fit: BoxFit.cover,
                                        useOldImageOnUrlChange: true,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      (homeModel.data!.banners!.isNotEmpty ||
                              homeModel.data!.banners!.length > 1)
                          ? const SizedBox(height: 20)
                          : Container(),
                    ],
                  ),
                );
              }
              // Error
              if (state.homeDataStatus is HomeDataError) {
                return const Text('Error');
              }
              return Container();
            },
          );
        }),
      ),
    );
  }
}
