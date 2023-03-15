import 'package:dio/dio.dart';
import 'package:shop_app/common/error_handling/check_exceptions.dart';
import 'package:shop_app/common/params/products_params.dart';
import 'package:shop_app/config/constants.dart';

class ProductsApiProvider {
  final Dio dio;

  ProductsApiProvider(this.dio);

  dynamic callProductsData(ProductsParams productsParams) async {
    try {
      var response = await dio.post(
        '${Constants.baseUrl}/products',
        data: {
          'start': productsParams.start,
          'step': productsParams.step,
          'categories': productsParams.categories,
          'minPrice': productsParams.minPrice,
          'maxPrice': productsParams.maxPrice,
          'sortby': productsParams.sortBy,
          'search': productsParams.search,
        },
      );
      return response;
    } on DioError catch (e) {
      return await CheckExceptions.response(e.response!);
    }
  }
}
