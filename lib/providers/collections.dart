import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Collection {
  final String id;
  final String title;

  Collection({
    required this.id,
    required this.title
  });
}

class Collections with ChangeNotifier {
  List<Collection> _collections = [];
  String _token;
  String _userId;

    Collections(this._token, this._userId, this._collections);

  Future<void> addCollection(String name) async {
    final response = await http.post(
      Uri.parse(
        'https://notebook-77031-default-rtdb.firebaseio.com/collections/$_userId.json?auth=$_token'
      ),
      body: json.encode({
        'name': name
      })
    );

    final responseBody = json.decode(response.body);

    _collections.add(Collection(id: responseBody['name'], title: name));
    notifyListeners();

    print(response.body);
  }

  Future<void> loadCollections() async {
    final response = await http.get(
      Uri.parse(
        'https://notebook-77031-default-rtdb.firebaseio.com/collections/$_userId.json?auth=$_token'
      ),
    );
    Map<String, dynamic> data = json.decode(response.body);
    _collections.clear();

    print(data);
    data.forEach((collectionId, collectionData) {
      _collections.add(Collection(
        id: collectionId,
        title: collectionData['name']
      ));
    });
    notifyListeners();
    
    return Future.value();
  }

  List<Collection> get collections {
    return _collections;
  }

  String getCollectionTitle(String collectionId) {
    return _collections.firstWhere((element) => element.id == collectionId).title;
  }

  int get itemsCount {
    return _collections.length;
  }
}