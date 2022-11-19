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
    if (isLoading) return;
    isLoading = true;
    notifyListeners();
    Dio dio = GetIt.I<Dio>();
    try {
      var response = await dio.get('/users');
      users.clear();
      for (var mapUserItem in response.data!) {
        String? name = mapUserItem['name'];
        String? avatarUrl = mapUserItem['avatarUrl'];
        users.add(UserItem(name!, avatarUrl!));
      }
      isLoading = false;
      notifyListeners();
    } catch (error) {
      isLoading = false;
      notifyListeners();
      var parsedError = jsonDecode((error as dynamic).response.toString());
      throw ListException(parsedError['message']);
    }
  }
}
