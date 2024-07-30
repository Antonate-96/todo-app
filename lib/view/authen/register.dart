import 'package:flutter/material.dart';
import 'package:todos/services/auth.dart';
import 'package:todos/shared/constant.dart';

import '../home/widget/loading.dart';

class Register extends StatefulWidget {
  final Function toggleview;
  Register({required this.toggleview});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
              title: const Text('Sign up'),
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('Sign In'),
                  onPressed: () {
                    widget.toggleview();
                  },
                )
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: ((value) =>
                            value!.isEmpty ? 'Enter an Email' : null),
                        onChanged: ((value) {
                          setState(() => email = value);
                        }),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        validator: ((value) => value!.length < 6
                            ? 'Enter a Password 6 chars long'
                            : null),
                        obscureText: true,
                        onChanged: ((value) {
                          setState(() => password = value);
                        }),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        child: const Text('Register'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .registerWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = 'please supply a valid email';
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  )),
            ),
          );
  }
}
