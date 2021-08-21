import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../utils/storage.dart';

class User with ChangeNotifier {
  String _name = '';
  String _id = '';
  String _email = '';
  String _token = '';
  late DateTime? _expiryDate;
  String _refreshToken = '';
  Timer? _updateTokenTimer;

  Future<void> _authenticate(
    String? name,
    String? email,
    String? password,
    String urlSegment,
  ) async {
    final response = await http.post(
      Uri.parse(
        '${Constants.FIREBASE_AUTH_URL}:$urlSegment?key=${Constants.FIREBASE_API_KEY}',
      ),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode != 200) {
      switch (responseBody['error']['message']) {
        case 'INVALID_PASSWORD':
          throw 'Senha incorreta.';
        case 'EMAIL_NOT_FOUND':
          throw 'E-mail não encontrado.';
        case 'EMAIL_EXISTS':
          throw 'E-mail já cadastrado.';
        default:
          throw 'Ocorreu um erro';
      }
    } else {
      _id = responseBody['localId'];
      _email = responseBody['email'];
      _token = responseBody['idToken'];
      _refreshToken = responseBody['refreshToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseBody['expiresIn'],
          ),
        ),
      );

      String userName = '';

      if (name != null && urlSegment == 'signUp') {
        await http.put(
          Uri.parse(
            '${Constants.FIREBASE_URL}/users/$_id.json?auth=$_token',
          ),
          body: json.encode({'name': name}),
        );
        userName = name;
      } else {
        final response = await http.get(Uri.parse(
          '${Constants.FIREBASE_URL}/users/$_id.json?auth=$_token',
        ));
        userName = json.decode(response.body)['name'];
      }

      _name = userName;

      Storage.saveMap('userData', {
        'name': userName,
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

  Future<void> login(String? email, String? password) async {
    return _authenticate(null, email, password, 'signInWithPassword');
  }

  Future<void> register(String? name, String? email, String? password) async {
    return _authenticate(name, email, password, 'signUp');
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
      Uri.parse(
        '${Constants.FIREBASE_REFRESH_TOKEN_URL}?key=${Constants.FIREBASE_API_KEY}',
      ),
      body: json.encode({
        'grant_type': 'refresh_token',
        'refresh_token': _refreshToken,
      }),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode != 200) {
      print('Ocorreu um erro');
    } else {
      _token = responseBody['access_token'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseBody['expires_in'],
          ),
        ),
      );

      Storage.saveMap('userData', {
        'id': _id,
        'email': _email,
        'token': _token,
        'refreshToken': _refreshToken,
        'expiryDate': _expiryDate!.toIso8601String()
      });

      notifyListeners();
      _autoUpdateToken();
    }
  }

  void _autoUpdateToken() {
    if (_updateTokenTimer != null) {
      _updateTokenTimer!.cancel();
    }
    final timeToUpdateToken = _expiryDate!.difference(DateTime.now()).inSeconds;
    _updateTokenTimer = Timer(
      Duration(seconds: timeToUpdateToken),
      updateToken,
    );
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

  String get name {
    return _name;
  }

  String get email {
    return _email;
  }

  String get refreshToken {
    return _refreshToken;
  }

  DateTime? get expiryDate {
    return _expiryDate;
  }
}
