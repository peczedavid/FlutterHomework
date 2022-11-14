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
    Dio dio = GetIt.I<Dio>();
    notifyListeners();
    SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();
    String? accesToken = sharedPreferences.getString(LoginModel.accesTokenName);
    return dio
        .get<List<Map<String, String>>>('/users',
            options: Options(headers: {"authorization": 'Bearer $accesToken'}))
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
          // TODO: handle as map
          isLoading = false;
          var parsedError = jsonDecode(error.response.toString());
          notifyListeners();
          throw ListException(parsedError['message']);
        });
  }
}
