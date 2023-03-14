import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/common/utils/prefs_operator.dart';
import 'package:shop_app/features/feature_home/data/data_source/remote/home_api_provider.dart';
import 'package:shop_app/features/feature_home/repository/home_repository.dart';

GetIt locator = GetIt.instance;

Future<void> initLocator() async {
  // Dio
  locator.registerSingleton<Dio>(Dio());

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPreferences);
  locator.registerSingleton<PrefsOperator>(PrefsOperator());

  // api provider
  locator.registerSingleton<HomeApiProvider>(HomeApiProvider(locator()));

  // repository
  locator.registerSingleton<HomeRepository>(HomeRepository(locator()));
}
