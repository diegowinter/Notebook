import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Page {
  final String collectionId;
  final String title;
  final String content;

  Page({
    required this.collectionId,
    required this.title,
    required this.content,
  });
}

class Pages with ChangeNotifier {
  String _userId;
  String _token;
  List<Page> _pages = [];

  Pages(this._userId, this._token, this._pages);

  Future<void> addPage(String collectionId, String title, String content) async {
    final response = await http.post(
      Uri.parse('https://notebook-77031-default-rtdb.firebaseio.com/collections/$_userId/$collectionId/pages.json?auth=$_token'),
      body: json.encode({
        'title': title,
        'content': content
      })
    );

    print(response.statusCode);
    print(response.body);
  }

  List<Page> get pages {
    return _pages;
  }
}