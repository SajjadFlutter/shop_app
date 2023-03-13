import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/common/widgets/loading_animation.dart';
import 'package:shop_app/features/feature_intro/presentation/bloc/splash_cubit/splash_cubit.dart';
import 'package:shop_app/features/feature_intro/presentation/screens/intro_main_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<SplashCubit>(context).checkConnectionEvent();
  }

  @override
  Widget build(BuildContext context) {
    // get size device
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: DelayedWidget(
                delayDuration: const Duration(milliseconds: 200),
                animationDuration: const Duration(milliseconds: 1500),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Image.asset(
                  'assets/images/besenior_logo.png',
                  width: width * 0.8,
                ),
              ),
            ),
            BlocConsumer<SplashCubit, SplashState>(
              listener: (context, state) {
                if (state.connectionStatus is ConnectionOn) {
                  goToHome();
                }
              },
              builder: (context, state) {
                if (state.connectionStatus is ConnectionInitial ||
                    state.connectionStatus is ConnectionOn) {
                  return const LoadingAnimation(size: 40.0);
                }

                if (state.connectionStatus is ConnectionOff) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<SplashCubit>(context)
                              .checkConnectionEvent();
                        },
                        icon: const Icon(
                          Icons.autorenew,
                          color: Colors.redAccent,
                        ),
                      ),
                      Text(
                        'شما به اینترنت متصل نیستید!',
                        style: TextStyle(
                            fontSize: height * 0.02, color: Colors.redAccent),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
            SizedBox(height: height * 0.025),
          ],
        ),
      ),
    );
  }

  Future<void> goToHome() async {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          IntroMainWrapper.routeName,
          ModalRoute.withName('/intro_main_wrapper'),
        );
      },
    );
  }
}
