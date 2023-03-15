// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop_app/common/resources/data_state.dart';
import 'package:shop_app/features/feature_product/data/models/categories_model.dart';
import 'package:shop_app/features/feature_product/repository/category_repository.dart';

part 'category_state.dart';
part 'category_data_status.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository categoryRepository;
  CategoryCubit(this.categoryRepository)
      : super(CategoryState(categoryDataStatus: CategoryDataLoading()));

  Future<void> loadCategoryEvent() async {
    // loading
    emit(state.copyWith(newCategoryDataStatus: CategoryDataLoading()));

    final DataState dataState = await categoryRepository.fetchCategoriesData();

    // completed
    if (dataState is DataSuccess) {
      emit(state.copyWith(
          newCategoryDataStatus: CategoryDataCompleted(dataState.data)));
    }

    // error
    if (dataState is DataFailed) {
      emit(state.copyWith(
          newCategoryDataStatus: CategoryDataError(dataState.error!)));
    }
  }
}
