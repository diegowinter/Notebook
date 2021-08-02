import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notebook/utils/app_routes.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({ Key? key }) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> _form = GlobalKey();
  Map<String, String> _formData = {
    'email': '',
    'password': ''
  };

  Future<void> _onSave() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();

    final response = await http.post(
      Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBEOwKC9RRJMZ8HcbJpo0GY8OpavGS-Jmg'
      ),
      body: json.encode({
        'email': _formData['email'],
        'password': _formData['password'],
        'returnSecureToken': true
      })
    );

    if (response.statusCode != 200) {
      print(response.body);
      return;
    }

    print(response.body);

    Navigator.of(context).pushReplacementNamed(AppRoutes.DASHBOARD);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Notebook',
              style: TextStyle(
                fontSize: 28
              ),
            ),
            Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-mail'
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (!value!.contains('@') || value.trim().isEmpty) {
                        return 'Insira um e-mail válido!';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['email'] = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Senha'
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.trim().length < 6 || value.trim().isEmpty) {
                        return 'A senha deve ter 6 ou mais caracteres.';
                      }
                    },
                    onSaved: (value) => _formData['password'] = value!,
                  )
                ]
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Entrar'),
              onPressed: () => _onSave(),
            )
          ],
        ),
      ),
    );
  }
}