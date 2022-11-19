import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginException extends Equatable implements Exception {
  final String message;

  const LoginException(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginModel extends ChangeNotifier {
  var isLoading = false;

  static const String accesTokenName = 'TEST_TOKEN';

  Future login(String email, String password, bool rememberMe) async {
    if(isLoading) return;
    isLoading = true;
    notifyListeners();
    Dio dio = GetIt.I<Dio>();
    SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();

    try {
      var response = await dio.post('/login', data: {'email': email, 'password': password});
      var token = response.data!['token'];
      dio.options.headers['Authorization'] = 'Bearer $token';
      if (rememberMe) {
        return sharedPreferences.setString(accesTokenName, token!);
      }
    } catch (error) {
      var parsedError = jsonDecode((error as dynamic).response.toString());
      isLoading = false;
      notifyListeners();
      throw LoginException(parsedError['message']);
    }

    

    // return dio.post('/login', data: {'email': email, 'password': password}).then((response) {
    //   var token = response.data!['token'];
    //   dio.options.headers['Authorization'] = 'Bearer $token';
    //   if (rememberMe) {
    //     sharedPreferences.setString(accesTokenName, token!);
    //   }
    //   notifyListeners();
    // }).catchError((error) {
    //   var parsedError = jsonDecode(error.response.toString());
    //   notifyListeners();
    //   throw LoginException(parsedError['message']);
    // });
  }

  bool tryAutoLogin() {
    SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();
    if(!sharedPreferences.containsKey(accesTokenName)) {
      return false;
    }
    Dio dio = GetIt.I<Dio>();
    String? token = sharedPreferences.getString(accesTokenName);
    dio.options.headers['Authorization'] = 'Bearer $token';
    return true;
  }
}
