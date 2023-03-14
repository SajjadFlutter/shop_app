part of 'home_cubit.dart';

class HomeState {
  final HomeDataStatus homeDataStatus;

  HomeState({required this.homeDataStatus});

  HomeState copyWith({required HomeDataStatus? newHomeDataStatus}) {
    return HomeState(homeDataStatus: newHomeDataStatus ?? homeDataStatus);
  }
}
