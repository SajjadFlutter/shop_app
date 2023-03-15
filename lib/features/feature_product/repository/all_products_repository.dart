import 'package:dio/dio.dart';
import 'package:shop_app/common/error_handling/app_exception.dart';
import 'package:shop_app/common/error_handling/check_exceptions.dart';
import 'package:shop_app/common/params/products_params.dart';
import 'package:shop_app/common/resources/data_state.dart';
import 'package:shop_app/features/feature_product/data/data_source/remote/products_api_provider.dart';
import 'package:shop_app/features/feature_product/data/models/all_products_model.dart';

class AllProductsRepository {
  final ProductsApiProvider apiProvider;

  AllProductsRepository(this.apiProvider);

  Future<dynamic> fetchAllProductsData(ProductsParams productsParams) async {
    try {
      Response response = await apiProvider.callProductsData(productsParams);
      AllProductsModel allProductsModel =
          AllProductsModel.fromJson(response.data);

      return DataSuccess(allProductsModel);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  Future<List<Products>> fetchAllProductsDataSearch(
      ProductsParams productsParams) async {
    Response response = await apiProvider.callProductsData(productsParams);
    AllProductsModel allProductsModel =
        AllProductsModel.fromJson(response.data);

    return allProductsModel.data![0].products!;
  }
}
