import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/network/data_source_interceptor.dart';
import 'package:flutter_homework/ui/bloc/login/login_page.dart';
import 'package:flutter_homework/ui/provider/list/list_model.dart';
import 'package:flutter_homework/ui/provider/list/list_page.dart';
import 'package:flutter_homework/ui/provider/login/login_model.dart';
import 'package:flutter_homework/ui/provider/login/login_page.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//DO NOT MODIFY
void main() async {
  await configureFixDependencies();
  await configureCustomDependencies();
  runApp(const MyApp());
}

//DO NOT MODIFY
Future configureFixDependencies() async {
  var dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ),
  );
  dio.interceptors.add(DataSourceInterceptor());
  GetIt.I.registerSingleton(dio);
  GetIt.I.registerSingleton(await SharedPreferences.getInstance());
  GetIt.I.registerSingleton(<NavigatorObserver>[]);
}

//Add custom dependencies if necessary
Future configureCustomDependencies() async {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        "/": (context) => ChangeNotifierProvider(
              create: (_) => LoginModel(),
              child: const LoginPageProvider(),
            ),
        "/list": (context) => ChangeNotifierProvider(
              create: (_) => ListModel(),
              child: const ListPageProvider(),
            ),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",

      //DO NOT MODIFY
      navigatorObservers: GetIt.I<List<NavigatorObserver>>(),
      //DO NOT MODIFY
      debugShowCheckedModeBanner: false,
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (_) => LoginModel()),
  //       ChangeNotifierProvider(create: (_) => ListModel()),
  //     ],
  //     child: MaterialApp(
  //       title: 'Flutter Demo',
  //       routes: {
  //         "/": (context) => const LoginPageProvider(),
  //         "/list": (context) => const ListPageProvider(),
  //       },
  //       theme: ThemeData(
  //         primarySwatch: Colors.blue,
  //       ),
  //       initialRoute: "/",

  //       //DO NOT MODIFY
  //       navigatorObservers: GetIt.I<List<NavigatorObserver>>(),
  //       //DO NOT MODIFY
  //       debugShowCheckedModeBanner: false,
  //     ),
  //   );
  // }
}
