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
    Dio dio = GetIt.I<Dio>();
    Map<String, String> data = {'email': email, 'password': password};
    return dio.post<Map<String, String>>('/login', data: data).then((response) {
      print(response);
      print('login model success');
      if (rememberMe) {
        var token = response.data!['token'];
        SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();
        sharedPreferences.setString(accesTokenName, token!);
      }
      else {
        var token = response.data!['token'];
        SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();
        sharedPreferences.setString('token_tmp', token!);
      }
      notifyListeners();
    }).catchError((error) {
      print('login model error');
      // TODO: handle as map
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
