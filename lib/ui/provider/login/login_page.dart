import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_homework/ui/provider/login/login_model.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class LoginPageProvider extends StatefulWidget {
  const LoginPageProvider({super.key});

  @override
  State<LoginPageProvider> createState() => _LoginPageProviderState();
}

class _LoginPageProviderState extends State<LoginPageProvider> {
  @override
  void initState() {
    super.initState();
  }

  late LoginModel model;

  bool _rememberMe = false;
  bool _obscurePassword = true;

  String? _emailErrorText;
  String? _passwordErrorText;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    model = Provider.of<LoginModel>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              enabled: !model.isLoading,
              onChanged: (value) {
                setState(() {
                  _emailErrorText = null;
                });
              },
              decoration: InputDecoration(
                  errorText: _emailErrorText,
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: 'E-mail',
                  hintText: 'Type in your e-mail here'),
            ),
            const SizedBox(height: 25),
            TextFormField(
              obscureText: _obscurePassword,
              controller: passwordController,
              enabled: !model.isLoading,
              onChanged: (value) {
                setState(() {
                  _passwordErrorText = null;
                });
              },
              decoration: InputDecoration(
                errorText: _passwordErrorText,
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: 'Password',
                hintText: 'Type in your password here',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text("Remember me"),
              value: _rememberMe,
              onChanged: !model.isLoading
                  ? (newValue) {
                      setState(() {
                        _rememberMe = !_rememberMe;
                      });
                    }
                  : null,
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String? emailErrorText;
                  if (!isEmail(emailController.text)) {
                    emailErrorText = 'Invalid e-mail';
                  }
                  setState(() {
                    _emailErrorText = emailErrorText;
                  });

                  String? passwordErrorText;
                  if (passwordController.text.length < 6) {
                    passwordErrorText = 'Password is too short';
                  }
                  setState(() {
                    _passwordErrorText = passwordErrorText;
                  });

                  bool fieldsAreValid =
                      emailErrorText == null && passwordErrorText == null;
                  if (fieldsAreValid) {
                    print('Logging in');
                    if (!model.isLoading) {
                      model.isLoading = true;
                      model
                          .login(emailController.text, passwordController.text,
                              _rememberMe)
                          .then((value) {
                        print('Value o.o');
                        // TODO: move to login func?
                        //model.isLoading = false;
                      }).catchError((error) {
                        // TODO: move to login func?
                        //model.isLoading = false;
                        var snackBar = SnackBar(
                          content: Text(error.message),
                          action: SnackBarAction(
                            label: 'Close',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    }
                  }
                },
                child: const Text('Login'),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
