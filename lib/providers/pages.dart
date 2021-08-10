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
  DateTime? _expiryDate;

  Pages(this._userId, this._token, this._pages, this._expiryDate);

  Future<void> addPage(String collectionId, String title, String content) async {
    final String pageTitle = title.isNotEmpty ? title : 'Página sem título';

    final response = await http.post(
      Uri.parse('${Constants.FIREBASE_URL}/pages/$_userId/$collectionId.json?auth=$_token'),
      body: json.encode({
        'title': pageTitle,
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
      title: pageTitle,
      content: content
    ));
    notifyListeners();
  }

  Future<void> loadPages(String collectionId) async {
    final response = await http.get(
      Uri.parse('${Constants.FIREBASE_URL}/pages/$_userId/$collectionId.json?auth=$_token'),
    );

    if (response.statusCode != 200) {
      throw 'Ocorreu um erro ao carregar as páginas';
    }

    final responseBody = json.decode(response.body);

    if (responseBody != null) {
      _pages.clear();
      responseBody.forEach((pageId, pageData) {
        _pages.add(CollectionPage(
          pageId: pageId,
          collectionId: collectionId,
          title: pageData['title'],
          content: pageData['content']
        ));
      });
      notifyListeners();
    } else {
      _pages.clear();
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> updatePage(String pageId, String newTitle, String newContent) async {
    final String newPageTitle = newTitle.isNotEmpty ? newTitle : 'Página sem título';

    final int index = _pages.indexWhere((page) => page.pageId == pageId);
    if (index >= 0) {
      final page = _pages[index];
      _pages.remove(page);
      _pages.insert(index, CollectionPage(
        pageId: pageId,
        collectionId: page.collectionId,
        title: newPageTitle,
        content: newContent
      ));
      notifyListeners();

      await http.patch(
        Uri.parse('${Constants.FIREBASE_URL}/pages/$_userId/${page.collectionId}/$pageId.json?auth=$_token'),
        body: json.encode({
          'title': newPageTitle,
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