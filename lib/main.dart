import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shop_app/features/feature_intro/presentation/bloc/splash_cubit/splash_cubit.dart';
import 'package:shop_app/features/feature_intro/presentation/screens/intor_main_wrapper.dart';
import 'package:shop_app/features/feature_intro/presentation/screens/splash_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'vazir'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('fa', ''),
      supportedLocales: const [
        Locale('fa', ''), // persian
        Locale('en', ''), // English
      ],
      initialRoute: '/',
      routes: {
        IntroMainWrapper.routeName: (context) => const IntroMainWrapper(),
      },
      home: const SplashScreen(),
    );
  }
}
