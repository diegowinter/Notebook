import 'package:flutter/material.dart';
import 'package:notebook/providers/user.dart';

import 'package:notebook/utils/app_routes.dart';
import 'package:provider/provider.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({ Key? key }) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  GlobalKey<FormState> _form = GlobalKey();
  Map<String, String> _formData = {
    'email': '',
    'password': ''
  };

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um erro'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Tentar novamente'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      )
    );
  }

  Future<void> _onSave() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<User>(context, listen: false)
        .login(_formData['email'], _formData['password']);
      Navigator.of(context).pushReplacementNamed(AppRoutes.DASHBOARD);
    } catch (error) {
      _showDialog(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
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
                    enabled: !_isLoading,
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
                    enabled: !_isLoading,
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
            _isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  child: Text('Entrar'),
                  onPressed: () => _onSave(),
                )
          ],
        ),
      ),
    );
  }
}