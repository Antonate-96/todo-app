import 'package:flutter/material.dart';
import 'package:todos/services/auth.dart';

import '../../shared/constant.dart';
import '../home/widget/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleview;
  SignIn({required this.toggleview});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final Authservice _auth = Authservice();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            // backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              elevation: 0.0,
              title: Text('Todos list'),
              actions: <Widget>[
                TextButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                  onPressed: () {
                    widget.toggleview();
                  },
                )
              ],
            ),
            body: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: ((value) =>
                              value!.isEmpty ? 'Enter an Email' : null),
                          onChanged: ((value) {
                            setState(() => email = value);
                          }),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          validator: ((value) => value!.length < 6
                              ? 'Enter a Password 6 chars long'
                              : null),
                          obscureText: true,
                          onChanged: ((value) {
                            setState(() => password = value);
                          }),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          child: Text('Sign in'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'COULD NOT SIGN IN WITH THOSE CREDENTIALS';
                                  loading = false;
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    )),
              ),
            ),
          );
  }
}
