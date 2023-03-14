import 'package:dio/dio.dart';
import 'package:shop_app/common/error_handling/app_exception.dart';
import 'package:shop_app/common/error_handling/check_exceptions.dart';
import 'package:shop_app/common/resources/data_state.dart';
import 'package:shop_app/features/feature_home/data/data_source/remote/home_api_provider.dart';
import 'package:shop_app/features/feature_home/data/models/home_model.dart';

class HomeRepository {
  final HomeApiProvider apiProvider;

  HomeRepository(this.apiProvider);

  Future<dynamic> fetchHomeData() async {
    try {
      Response response = await apiProvider.callHomeData();
      final HomeModel homeModel = HomeModel.fromJson(response.data);

      return DataSuccess(homeModel);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }
}
