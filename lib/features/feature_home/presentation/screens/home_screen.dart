// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    return BlocProvider(
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

              SuggestionProducts? organicProducts =
                  homeModel.data!.suggestionProducts![0];
              SuggestionProducts? discountProducts =
                  homeModel.data!.suggestionProducts![1];
              SuggestionProducts? thirdProductsList =
                  homeModel.data!.suggestionProducts![2];

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
                    SizedBox(height: height * 0.03),
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
                                      imageUrl:
                                          homeModel.data!.sliders![index].img!,
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

                    SizedBox(height: height * 0.01),

                    // 8 categories
                    homeModel.data!.categories!.isNotEmpty
                        ? SizedBox(
                            height: 250,
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

                                return DeepLinks(image: image!, title: title!);
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
                        ? SizedBox(height: height * 0.02)
                        : Container(),

                    // dicounts
                    (discountProducts != null)
                        ? DiscountWidget(
                            discountProducts: discountProducts,
                            height: height,
                            width: width,
                          )
                        : Container(),

                    /// bottom banners
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          (homeModel.data!.banners!.length > 2)
                              ? GestureDetector(
                                  onTap: () {
                                    // if(homeModel.data!.banners![2].categoryId != null){
                                    //   Navigator.pushNamed(
                                    //     context,
                                    //     AllProductsScreen.routeName,
                                    //     arguments: ProductsArguments(categoryId: homeModel.data!.banners![2].categoryId!),);
                                    // }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          homeModel.data!.banners![2].image!,
                                      placeholder: (context, string) {
                                        return LoadingAnimation(size: 35.0);
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
                          SizedBox(
                            height: height * 0.02,
                          ),
                          (homeModel.data!.banners!.length > 3)
                              ? GestureDetector(
                                  onTap: () {
                                    if (homeModel
                                            .data!.banners![3].categoryId !=
                                        null) {
                                      // Navigator.pushNamed(
                                      //   context,
                                      //   AllProductsScreen.routeName,
                                      //   arguments: ProductsArguments(categoryId: homeModel.data!.banners![3].categoryId!),);
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          homeModel.data!.banners![3].image!,
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
                    (homeModel.data!.banners!.length > 2 ||
                            homeModel.data!.banners!.length > 3)
                        ? SizedBox(
                            height: height * 0.02,
                          )
                        : Container(),

                    /// second green discounts
                    (organicProducts != null)
                        ? OrganicProductsWidget(
                            organicProducts: organicProducts,
                            height: height,
                            width: width,
                          )
                        : Container(),

                    /// second green discounts
                    (thirdProductsList != null)
                        ? ThirdProductsListWidget(
                            thirdProductsList: thirdProductsList,
                            height: height,
                            width: width)
                        : Container(),
                  ],
                ),
              );
            }
            // Error
            if (state.homeDataStatus is HomeDataError) {
              final HomeDataError homeDataError =
                  state.homeDataStatus as HomeDataError;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      homeDataError.errorMessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber.shade800),
                      onPressed: () {
                        /// call all data again
                        BlocProvider.of<HomeCubit>(context).callHomeDataEvent();
                      },
                      child: const Text("تلاش دوباره"),
                    )
                  ],
                ),
              );
            }
            return Container();
          },
        );
      }),
    );
  }
}

// ThirdProductsList Widget
class ThirdProductsListWidget extends StatelessWidget {
  const ThirdProductsListWidget({
    super.key,
    required this.thirdProductsList,
    required this.height,
    required this.width,
  });

  final SuggestionProducts? thirdProductsList;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 370,
          color: Colors.grey.shade200,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      thirdProductsList!.title ?? 'محصولات',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    // Row(
                    //   children: const [
                    //     Text('مشاهده همه', style: TextStyle(color: Colors.white),),
                    //     SizedBox(width: 5,),
                    //     Icon(Icons.arrow_back_ios_new,color: Colors.white,size: 18,),
                    //   ],
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: thirdProductsList!.items!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(
                            //   context,
                            //   ProductDetailScreen.routeName,
                            //   arguments: ProductDetailArguments(thirdProductsList.items![index].id!),);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                            ),
                            width: 170,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: CachedNetworkImage(
                                        imageUrl: thirdProductsList!
                                            .items![index].image!,
                                        fit: BoxFit.cover,
                                        useOldImageOnUrlChange: true,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    thirdProductsList!.items![index].name!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  const Text(
                                    'موجود در انبار بیسینیور',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11),
                                  ),
                                  SizedBox(
                                    height: height * 0.03,
                                  ),

                                  Row(
                                    children: [
                                      /// discount red container
                                      (thirdProductsList!
                                                  .items![index].discount! !=
                                              0)
                                          ? Container(
                                              width: 40,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(
                                                  child: Text(
                                                "${thirdProductsList!.items![index].discount!}%",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              )),
                                            )
                                          : Container(),

                                      const Spacer(),

                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                thirdProductsList!
                                                    .items![index].price!,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              ),
                                              (thirdProductsList!.items![index]
                                                          .priceBeforDiscount !=
                                                      "0")
                                                  ? Text(
                                                      thirdProductsList!
                                                          .items![index]
                                                          .priceBeforDiscount!,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          const Text(
                                            'تومان',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.03,
                                  ),

                                  /// stars icon
                                  Center(
                                    child: RatingBar.builder(
                                      itemSize: 20,
                                      initialRating: thirdProductsList!
                                          .items![index].star!
                                          .toDouble(),
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemBuilder: (context, _) {
                                        return const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 10,
                                        );
                                      },
                                      onRatingUpdate: (rating) {
                                        // print(rating);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Organic Products Widget
class OrganicProductsWidget extends StatelessWidget {
  const OrganicProductsWidget({
    super.key,
    required this.organicProducts,
    required this.height,
    required this.width,
  });

  final SuggestionProducts? organicProducts;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 370,
          color: Colors.grey.shade200,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      organicProducts!.title!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    // Row(
                    //   children: const [
                    //     Text('مشاهده همه', style: TextStyle(color: Colors.white),),
                    //     SizedBox(width: 5,),
                    //     Icon(Icons.arrow_back_ios_new,color: Colors.white,size: 18,),
                    //   ],
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: organicProducts!.items!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(
                            //   context,
                            //   ProductDetailScreen.routeName,
                            //   arguments: ProductDetailArguments(organicProducts.items![index].id!),);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                            ),
                            width: 170,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: CachedNetworkImage(
                                        // imageUrl: "https://niyaz.shop/uploads/products/thum-%D9%BE%D8%B1%D8%AA%D9%82%D8%A7%D9%84-%D8%B1%D8%B3%D9%85%DB%8C-16630019485051793.png",
                                        imageUrl: organicProducts!
                                            .items![index].image!,
                                        fit: BoxFit.cover,
                                        useOldImageOnUrlChange: true,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    organicProducts!.items![index].name!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  const Text(
                                    'موجود در انبار بیسینیور',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.03,
                                  ),

                                  Row(
                                    children: [
                                      /// discount red container
                                      (organicProducts!
                                                  .items![index].discount! !=
                                              0)
                                          ? Container(
                                              width: 40,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(
                                                  child: Text(
                                                "${organicProducts!.items![index].discount!}%",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              )),
                                            )
                                          : Container(),

                                      const Spacer(),

                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                organicProducts!
                                                    .items![index].price!,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              ),
                                              (organicProducts!.items![index]
                                                          .priceBeforDiscount !=
                                                      "0")
                                                  ? Text(
                                                      organicProducts!
                                                          .items![index]
                                                          .priceBeforDiscount!,
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          const Text(
                                            'تومان',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.03,
                                  ),

                                  /// stars icon
                                  Center(
                                    child: RatingBar.builder(
                                      itemSize: 20,
                                      initialRating: organicProducts!
                                          .items![index].star!
                                          .toDouble(),
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemBuilder: (context, _) {
                                        return const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 10,
                                        );
                                      },
                                      onRatingUpdate: (rating) {
                                        // print(rating);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Discount Widget
class DiscountWidget extends StatelessWidget {
  const DiscountWidget({
    super.key,
    required this.discountProducts,
    required this.height,
    required this.width,
  });

  final SuggestionProducts? discountProducts;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 330.0,
          color: Colors.grey.shade200,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: discountProducts!.items!.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            'assets/images/amazing.svg',
                            width: 120.0,
                            color: Colors.redAccent,
                          ),
                          Image.asset(
                            'assets/images/box.png',
                            width: 150.0,
                          ),
                        ],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        child: Container(
                          width: 170.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 13.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: height * 0.01),
                                const Text(
                                  'شگفت انگیز اختصاصی اپ',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: CachedNetworkImage(
                                      imageUrl: discountProducts!
                                          .items![index - 1].image!,
                                      fit: BoxFit.cover,
                                      useOldImageOnUrlChange: true,
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                Text(
                                  discountProducts!.items![index - 1].name!,
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: height * 0.01),
                                const Text(
                                  'موجود در بیسینیور',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 11),
                                ),
                                SizedBox(height: height * 0.03),

                                /// discount and price
                                Row(
                                  children: [
                                    /// discount red container
                                    discountProducts!
                                                .items![index - 1].discount !=
                                            0
                                        ? Container(
                                            width: 40.0,
                                            height: 30.0,
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${discountProducts!.items![index - 1].discount}%',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),

                                    const Spacer(),

                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              discountProducts!
                                                  .items![index - 1].price!,
                                              style: const TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            discountProducts!.items![index - 1]
                                                        .priceBeforDiscount !=
                                                    '0'
                                                ? Text(
                                                    discountProducts!
                                                        .items![index - 1]
                                                        .priceBeforDiscount!,
                                                    style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.grey,
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                        const Text(
                                          'تومان',
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.02),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
        SizedBox(height: height * 0.02),
      ],
    );
  }
}
