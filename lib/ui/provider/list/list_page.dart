import 'package:flutter/material.dart';
import 'package:flutter_homework/ui/provider/list/list_model.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login_model.dart';

class ListPageProvider extends StatefulWidget {
  const ListPageProvider({Key? key}) : super(key: key);

  @override
  State<ListPageProvider> createState() => _ListPageProviderState();
}

class _ListPageProviderState extends State<ListPageProvider> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      model.loadUsers().catchError((error) {
        var snackBar = SnackBar(
          content: Text(error.message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  }

  late ListModel model;

  @override
  Widget build(BuildContext context) {
    model = Provider.of<ListModel>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();
              bool isTokenSaved = sharedPreferences.containsKey(LoginModel.accesTokenName);
              if(isTokenSaved) {
                sharedPreferences.remove(LoginModel.accesTokenName).then((value) => 
                Navigator.pushReplacementNamed(context, "/"));
              }
              else {
                Navigator.pushReplacementNamed(context, "/");
              }
            },
          ),
        ],
      ),
      body: Center(
        child: model.isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      title: Text(model.users[i].name),
                      leading: Image.network(model.users[i].avatarUrl),
                    ),
                  );
                },
                itemCount: model.users.length,
              ),
      ),
    );
  }
}
