import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notebook/utils/constants.dart';

class CollectionPage {
  final String pageId;
  final String collectionId;
  final String title;
  final String content;

  CollectionPage({
    required this.pageId,
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
      Uri.parse('https://notebook-77031-default-rtdb.firebaseio.com/pages/$_userId/$collectionId.json?auth=$_token'),
      body: json.encode({
        'title': title,
        'content': content
      })
    );

    if (response.statusCode != 200) {
      throw 'Ocorreu um erro ao adicionar esta página';
    }

    final responseBody = json.decode(response.body);

    _pages.add(CollectionPage(
      pageId: responseBody['name'],
      collectionId: collectionId,
      title: title,
      content: content
    ));
    notifyListeners();
  }

  Future<void> loadPages(String collectionId) async {
    final response = await http.get(
      Uri.parse('https://notebook-77031-default-rtdb.firebaseio.com/pages/$_userId/$collectionId.json?auth=$_token'),
    );

    if (response.statusCode != 200) {
      throw 'Ocorreu um erro ao carregar as páginas';
    }

    _pages.clear();
    json.decode(response.body)!.forEach((pageId, pageData) {
      _pages.add(CollectionPage(
        pageId: pageId,
        collectionId: collectionId,
        title: pageData['title'],
        content: pageData['content']
      ));
    });
    notifyListeners();

    return Future.value();
  }

  Future<void> updatePage(String pageId, String newTitle, String newContent) async {
    final int index = _pages.indexWhere((page) => page.pageId == pageId);
    if (index >= 0) {
      final page = _pages[index];
      _pages.remove(page);
      _pages.insert(index, CollectionPage(
        pageId: pageId,
        collectionId: page.collectionId,
        title: newTitle,
        content: newContent
      ));
      notifyListeners();

      await http.patch(
        Uri.parse('${Constants.FIREBASE_URL}/pages/$_userId/${page.collectionId}/$pageId.json?auth=$_token'),
        body: json.encode({
          'title': newTitle,
          'content': newContent
        })
      );
    }
  }

  Future<void> deletePage(String pageId) async {
    final int index = _pages.indexWhere((page) => page.pageId == pageId);
    if (index >= 0) {
      final page = _pages[index];
      _pages.remove(page);
      notifyListeners();

      final collectionId = page.collectionId;

      final response = await http.delete(
        Uri.parse('${Constants.FIREBASE_URL}/pages/$_userId/$collectionId/$pageId.json?auth=$_token'),
      );

      if (response.statusCode != 200) {
        _pages.insert(index, page);
        notifyListeners();
        throw 'Ocorreu um erro ao excluir a página';
      }
    }
  }

  

  int get pagesCount {
    return _pages.length;
  }

  List<CollectionPage> get pages {
    return [..._pages];
  }
}