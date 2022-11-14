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

  static const String accesTokenName = 'access_token';

  Future login(String email, String password, bool rememberMe) async {
    Dio dio = GetIt.I<Dio>();
    Map<String, String> data = {'email': email, 'password': password};
    return dio.post<Map<String, String>>('/login', data: data).then((response) {
      isLoading = false;
      if (rememberMe) {
        var token = response.data!['token'];
        SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();
        sharedPreferences.setString(accesTokenName, token!);
      }
      notifyListeners();
    }).catchError((error) {
      // TODO: handle as map
      isLoading = false;
      var parsedError = jsonDecode(error.response.toString());
      notifyListeners();
      throw LoginException(parsedError['message']);
    });
  }

  bool tryAutoLogin() {
    print('try auto login');
    SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();
    String? token = sharedPreferences.getString(accesTokenName);
    return token != null;
  }
}
