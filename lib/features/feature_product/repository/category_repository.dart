import 'package:dio/dio.dart';
import 'package:shop_app/common/error_handling/app_exception.dart';
import 'package:shop_app/common/error_handling/check_exceptions.dart';
import 'package:shop_app/common/resources/data_state.dart';
import 'package:shop_app/features/feature_product/data/data_source/remote/category_api_provider.dart';
import 'package:shop_app/features/feature_product/data/models/categories_model.dart';

class CategoryRepository {
  final CategoryApiProvider apiProvider;

  CategoryRepository(this.apiProvider);

  Future<dynamic> fetchCategoriesData() async {
    try {
      Response response = await apiProvider.callCategoriesData();
      CategoriesModel categoriesModel = CategoriesModel.fromJson(response.data);
      return DataSuccess(categoriesModel);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }
}
