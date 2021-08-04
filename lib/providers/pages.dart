import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CollectionPage {
  final String collectionId;
  final String title;
  final String content;

  CollectionPage({
    required this.collectionId,
    required this.title,
    required this.content,
  });
}

class Pages with ChangeNotifier {
  String _userId;
  String _token;
  List<CollectionPage> _pages = [];

  Pages(this._userId, this._token, this._pages);

  Future<void> addPage(String collectionId, String title, String content) async {
    final response = await http.post(
      Uri.parse('https://notebook-77031-default-rtdb.firebaseio.com/collections/$_userId/$collectionId/pages.json?auth=$_token'),
      body: json.encode({
        'title': title,
        'content': content
      })
    );

    if (response.statusCode != 200) {
      throw 'Ocorreu um erro ao adicionar esta página';
    }

    _pages.add(CollectionPage(
      collectionId: collectionId,
      title: title,
      content: content
    ));
    notifyListeners();
  }

  Future<void> loadPages(String collectionId) async {
    print(collectionId);

    final response = await http.get(
      Uri.parse('https://notebook-77031-default-rtdb.firebaseio.com/collections/$_userId/$collectionId/pages.json?auth=$_token'),
    );

    if (response.statusCode != 200) {
      throw 'Ocorreu um erro ao carregar as páginas';
    }

    _pages.clear();
    json.decode(response.body).forEach((pageId, pageData) {
      _pages.add(CollectionPage(
        collectionId: collectionId,
        title: pageData['title'],
        content: pageData['content']
      ));
    });
    notifyListeners();

    return Future.value();
  }

  int get pagesCount {
    return _pages.length;
  }

  List<CollectionPage> get pages {
    return [..._pages];
  }
}