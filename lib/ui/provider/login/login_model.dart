import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class LoginException extends Equatable implements Exception {
  final String message;

  const LoginException(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginModel extends ChangeNotifier {
  var isLoading = false;

  Future login(String email, String password, bool rememberMe) async {
    Dio dio = GetIt.I<Dio>();
    Map<String, String> data = {'email': email, 'password': password};
    dio.post('/login', data: data)
    .then((response) {
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      notifyListeners();
      isLoading = false;
      throw const LoginException("Invalid email or password");
    });
  }

  bool tryAutoLogin() {
    throw UnimplementedError('Missing implementation!');
  }
}
