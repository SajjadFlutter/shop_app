import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shop_app/common/widgets/loading_animation.dart';
import 'package:shop_app/features/feature_home/presentation/bloc/home_cubit/home_cubit.dart';
import 'package:shop_app/features/feature_home/repository/home_repository.dart';
import 'package:shop_app/locator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(locator<HomeRepository>()),
      child: Builder(builder: (context) {
        // call api
        BlocProvider.of<HomeCubit>(context).callHomeDataEvent();

        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            // Loading
            if (state.homeDataStatus is HomeDataLoading) {
              return const LoadingAnimation(size: 45.0);
            }
            // Completed
            if (state.homeDataStatus is HomeDataCompleted) {
              return const Center(child: Text('completed'));
            }
            // Error
            if (state.homeDataStatus is HomeDataError) {
              return const Text('Error');
            }
            return Container();
          },
        );
      }),
    );
    ;
  }
}
