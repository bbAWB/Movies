import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/app_config.dart';
import 'package:flutter_application_1/pages/main_page.dart';
import 'package:flutter_application_1/pages/splash_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

void main() {
  GetIt.I.registerSingleton<AppConfig>(
    AppConfig(
      BASE_API_URL: 'https://api.themoviedb.org/3',
      BASE_IMAGE_API_URL: 'https://image.tmdb.org/t/p/original/',
      API_KEY: 'f4f352647c7f70897cafd9cac1e5f53c',
    ),
  );
  runApp(SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () => runApp(const ProviderScope(
            child: MyApp(),
          ))));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flicked',
        initialRoute: 'home',
        routes: {
          'home': (BuildContext context) => MainPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ));
  }
}
