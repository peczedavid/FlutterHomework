import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login_model.dart';

class ListException extends Equatable implements Exception {
  final String message;

  const ListException(this.message);

  @override
  List<Object?> get props => [message];
}

class ListModel extends ChangeNotifier {
  var isLoading = false;
  var users = <UserItem>[];

  Future loadUsers() async {
    isLoading = true;
    notifyListeners();
    Dio dio = GetIt.I<Dio>();
    SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();
    var token = sharedPreferences.getString(LoginModel.accesTokenName);
    print(token);
    return dio
        .get('/users')
        .then((value) {
          users.clear();
          for (var mapUserItem in value.data!) {
            String? name = mapUserItem['name'];
            String? avatarUrl = mapUserItem['avatarUrl'];
            users.add(UserItem(name!, avatarUrl!));
          }
          isLoading = false;
          notifyListeners();
        }).catchError((error) {
          isLoading = false;
          notifyListeners();
          var parsedError = jsonDecode(error.response.toString());
          throw ListException(parsedError['message']);
        });
  }
}