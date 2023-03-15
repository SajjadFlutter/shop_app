part of 'category_cubit.dart';

class CategoryState {
  final CategoryDataStatus categoryDataStatus;

  CategoryState({required this.categoryDataStatus});

  CategoryState copyWith({required CategoryDataStatus? newCategoryDataStatus}) {
    return CategoryState(
      categoryDataStatus: newCategoryDataStatus ?? categoryDataStatus,
    );
  }
}
