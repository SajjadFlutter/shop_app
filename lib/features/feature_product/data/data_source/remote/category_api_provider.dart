import 'package:dio/dio.dart';
import 'package:shop_app/common/error_handling/check_exceptions.dart';
import 'package:shop_app/config/constants.dart';

class CategoryApiProvider {
  final Dio dio;

  CategoryApiProvider(this.dio);

  dynamic callCategoriesData() async {
    try {
      var response = await dio.get('${Constants.baseUrl}/categories/tree');
      return response;
    } on DioError catch (e) {
      return await CheckExceptions.response(e.response!);
    }
  }
}
