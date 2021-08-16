import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_routes.dart';
import '../providers/user.dart';
import '../widgets/custom_text_form_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = false;
  bool _isLoading = false;
  GlobalKey<FormState> _form = GlobalKey();
  Map<String, String> _formData = {'email': '', 'password': ''};

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
      ),
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
      if (_isSignUp) {
        await Provider.of<User>(context, listen: false)
            .register(_formData['email'], _formData['password']);
      } else {
        await Provider.of<User>(context, listen: false)
            .login(_formData['email'], _formData['password']);
      }
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
              style: TextStyle(fontSize: 28),
            ),
            SizedBox(height: 16),
            Form(
              key: _form,
              child: Column(
                children: [
                  CustomTextFormField(
                    hint: 'E-mail',
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoading,
                    validator: (value) {
                      if (!value!.contains('@') || value.trim().isEmpty) {
                        return 'Insira um e-mail válido!';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['email'] = value!,
                    textInputAction: TextInputAction.next,
                    maxLength: 100,
                  ),
                  SizedBox(height: 10),
                  CustomTextFormField(
                    hint: 'Senha',
                    obscureText: true,
                    enabled: !_isLoading,
                    validator: (value) {
                      if (value!.trim().length < 6 || value.trim().isEmpty) {
                        return 'A senha deve ter 6 ou mais caracteres.';
                      }
                    },
                    onSaved: (value) => _formData['password'] = value!,
                    textInputAction: TextInputAction.done,
                    maxLength: 100,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    child: Text(_isSignUp ? 'Cadastrar' : 'Entrar'),
                    onPressed: () => _onSave(),
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  ),
            SizedBox(height: 10),
            _isSignUp
                ? GestureDetector(
                    child: Text('Já possui conta? Entrar.'),
                    onTap: () {
                      setState(() {
                        _isSignUp = false;
                      });
                    },
                  )
                : GestureDetector(
                    child: Text('Não possui conta? Cadastre-se.'),
                    onTap: () {
                      setState(() {
                        _isSignUp = true;
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
