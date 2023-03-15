import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/common/widgets/loading_animation.dart';
import 'package:shop_app/features/feature_product/data/models/categories_model.dart';
import 'package:shop_app/features/feature_product/presentation/bloc/category_cubit/category_cubit.dart';
import 'package:shop_app/features/feature_product/repository/category_repository.dart';
import 'package:shop_app/locator.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get size device
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => CategoryCubit(locator<CategoryRepository>()),
      child: Builder(builder: (context) {
        // call api
        BlocProvider.of<CategoryCubit>(context).loadCategoryEvent();

        return BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            // loading
            if (state.categoryDataStatus is CategoryDataLoading) {
              return const LoadingAnimation(size: 40.0);
            }
            // completed
            if (state.categoryDataStatus is CategoryDataCompleted) {
              final CategoryDataCompleted categoryDataCompleted =
                  state.categoryDataStatus as CategoryDataCompleted;

              final CategoriesModel categoriesModel =
                  categoryDataCompleted.categoriesModel;

              return ListView.separated(
                padding: const EdgeInsets.only(top: 20.0),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: CachedNetworkImage(
                                    imageUrl: categoriesModel.data![index].img!,
                                    width: 40.0,
                                    height: 40.0,
                                    fit: BoxFit.cover,
                                    useOldImageOnUrlChange: true,
                                  ),
                                ),
                                SizedBox(width: width * 0.05),
                                Text(
                                  categoriesModel.data![index].title!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.grey,size: 18.0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(height: height * 0.01),
                itemCount: 8,
              );
            }
            // error
            if (state.categoryDataStatus is CategoryDataError) {
              final CategoryDataError categoryDataError =
                  state.categoryDataStatus as CategoryDataError;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      categoryDataError.errorMessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      onPressed: () {
                        /// call all data again
                        BlocProvider.of<CategoryCubit>(context)
                            .loadCategoryEvent();
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
