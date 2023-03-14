import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:shop_app/common/resources/data_state.dart';
import 'package:shop_app/features/feature_home/data/models/home_model.dart';
import 'package:shop_app/features/feature_home/repository/home_repository.dart';

part 'home_state.dart';
part 'home_data_status.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  HomeCubit(this.homeRepository)
      : super(HomeState(homeDataStatus: HomeDataLoading()));

  Future<void> callHomeDataEvent() async {
    // emit loading
    emit(state.copyWith(newHomeDataStatus: HomeDataLoading()));

    final DataState dataState = await homeRepository.fetchHomeData();

    // emit completed
    if (dataState is DataSuccess) {
      emit(
          state.copyWith(newHomeDataStatus: HomeDataCompleted(dataState.data)));
    }

    // emit error
    if (dataState is DataFailed) {
      emit(state.copyWith(newHomeDataStatus: HomeDataError(dataState.error!)));
    }
  }
}
