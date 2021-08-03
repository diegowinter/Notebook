import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User with ChangeNotifier{
  String _id = '';
  String _email = '';
  String _token = '';
  String _refreshToken = '';

  Future<void> login(String? email, String? password) async {
    final response = await http.post(
      Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBEOwKC9RRJMZ8HcbJpo0GY8OpavGS-Jmg'
      ),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      })
    );

    final responseBody = json.decode(response.body);

    if (responseBody['error'] != null) {
      throw 'Algo deu errado';
    } else {
      _id = responseBody['localId'];
      _email = responseBody['email'];
      _token = responseBody['idToken'];
      _refreshToken = responseBody['refreshToken'];

      notifyListeners();
    }
  }

  String get token {
    return _token;
  }

  String get id {
    return _id;
  }

  String get email {
    return _email;
  }

  String get refreshToken {
    return _refreshToken;
  }
}