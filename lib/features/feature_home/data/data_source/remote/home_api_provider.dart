import 'package:dio/dio.dart';
import 'package:shop_app/common/error_handling/check_exceptions.dart';
import 'package:shop_app/config/constants.dart';

class HomeApiProvider {
  final Dio dio;

  HomeApiProvider(this.dio);

  dynamic callHomeData() async {
    try {
      var response = dio.get('${Constants.baseUrl}/mainData');

      return response;
    } on DioError catch (e) {
      return await CheckExceptions.response(e.response!);
    }
  }
}
