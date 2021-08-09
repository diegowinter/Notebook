import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notebook/utils/constants.dart';
import 'package:notebook/utils/storage.dart';

class User with ChangeNotifier{
  String _id = '';
  String _email = '';
  String _token = '';
  late DateTime? _expiryDate;
  String _refreshToken = '';
  Timer? _updateTokenTimer;

  Future<void> login(String? email, String? password) async {
    final response = await http.post(
      Uri.parse(
        '${Constants.FIREBASE_AUTH_URL}:signInWithPassword?key=${Constants.FIREBASE_API_KEY}'
      ),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      })
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode != 200) {
      switch(responseBody['error']['message']) {
        case 'INVALID_PASSWORD':
          throw 'Senha incorreta.';
        case 'EMAIL_NOT_FOUND':
          throw 'E-mail não encontrado.';
        default:
          throw 'Ocorreu um erro';
      }
    } else {
      _id = responseBody['localId'];
      _email = responseBody['email'];
      _token = responseBody['idToken'];
      _refreshToken = responseBody['refreshToken'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseBody['expiresIn'])
      ));

      Storage.saveMap('userData', {
        'id': _id,
        'email': _email,
        'token': _token,
        'refreshToken': _refreshToken,
        'expiryDate': _expiryDate!.toIso8601String()
      });

      _autoUpdateToken();
      notifyListeners();
    }
  }

  bool get isAuth {
    return token != '';
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) {
      return Future.value();
    }

    final userData = await Storage.getMap('userData');
    if (userData == null) {
      return Future.value();
    }

    final expiryDate = DateTime.parse(userData['expiryDate']);

    _id = userData['id'];
    _email = userData['email'];
    _refreshToken = userData['refreshToken'];
    _expiryDate = expiryDate;

    if (expiryDate.isBefore(DateTime.now())) {
      await updateToken();
    } else {
      _token = userData['token'];
    }
    
    notifyListeners();

    return Future.value();
  }

  Future<void> updateToken() async {
    final response = await http.post(
      Uri.parse('${Constants.FIREBASE_REFRESH_TOKEN_URL}?key=${Constants.FIREBASE_API_KEY}'),
      body: json.encode({
        'grant_type': 'refresh_token',
        'refresh_token': _refreshToken
      })
    );
    
    final responseBody = json.decode(response.body);

    if (response.statusCode != 200) {
      print('Ocorreu um erro');
    } else {
      _token = responseBody['access_token'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseBody['expires_in'])
      ));

      print(_expiryDate);

      Storage.saveMap('userData', {
        'id': _id,
        'email': _email,
        'token': _token,
        'refreshToken': _refreshToken,
        'expiryDate': _expiryDate!.toIso8601String()
      });

      notifyListeners();
    }
  }

  void _autoUpdateToken() {
    if (_updateTokenTimer != null) {
      _updateTokenTimer!.cancel();
    }
    final timeToUpdateToken = _expiryDate!.difference(DateTime.now()).inSeconds;
    _updateTokenTimer = Timer(Duration(seconds: timeToUpdateToken), updateToken);
  }

  void logout() {
    _id = '';
    _email = '';
    _token = '';
    _expiryDate = null;
    _refreshToken = '';
    if (_updateTokenTimer != null) {
      _updateTokenTimer!.cancel();
      _updateTokenTimer = null;
    }
    Storage.remove('userData');
    notifyListeners();
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