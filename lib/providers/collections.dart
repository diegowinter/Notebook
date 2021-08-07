import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notebook/utils/constants.dart';

class Collection {
  final String id;
  final String title;
  final String description;

  Collection({
    required this.id,
    required this.title,
    required this.description
  });
}

class Collections with ChangeNotifier {
  List<Collection> _collections = [];
  String _token;
  String _userId;

    Collections(this._token, this._userId, this._collections);

  Future<void> addCollection(String name, String description) async {
    final response = await http.post(
      Uri.parse(
        'https://notebook-77031-default-rtdb.firebaseio.com/collections/$_userId.json?auth=$_token'
      ),
      body: json.encode({
        'name': name,
        'description': description
      })
    );

    final responseBody = json.decode(response.body);

    _collections.add(
      Collection(
        id: responseBody['name'],
        title: name,
        description: description
      )
    );
    notifyListeners();

    print(response.body);
  }

  Future<void> loadCollections() async {
    final response = await http.get(
      Uri.parse(
        'https://notebook-77031-default-rtdb.firebaseio.com/collections/$_userId.json?auth=$_token'
      ),
    );

    final responseBody = json.decode(response.body);

    if (responseBody != null) {
      _collections.clear();
      responseBody.forEach((collectionId, collectionData) {
        _collections.add(Collection(
          id: collectionId,
          title: collectionData['name'],
          description: collectionData['description']
        ));
      });
      notifyListeners();
    }
    
    
    return Future.value();
  }

  Future<void> updateCollection(String collectionId, String newName, String newDescription) async {
    final int index = _collections.indexWhere((collection) => collection.id == collectionId);
    if (index >= 0) {
      final collection = _collections[index];
      _collections.remove(collection);
      _collections.insert(index, Collection(
        id: collectionId,
        title: newName,
        description: newDescription
      ));
      notifyListeners();

      await http.patch(
        Uri.parse('${Constants.FIREBASE_URL}/collections/$_userId/$collectionId.json?auth=$_token'),
        body: json.encode({
          'name': newName,
          'description': newDescription
        })
      );
    }
  }

  Future<void> deleteCollection(String collectionId) async {
    final int index = _collections.indexWhere((collection) => collection.id == collectionId);
    if (index >= 0) {
      final collection = _collections[index];
      _collections.remove(collection);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.FIREBASE_URL}/collections/$_userId/$collectionId.json?auth=$_token')
      );

      if (response.statusCode != 200) {
        _collections.insert(index, collection);
        notifyListeners();
        throw 'Ocorreu um erro ao excluir a coleção';
      }
    }
  }

  List<Collection> get collections {
    return _collections;
  }

  String getCollectionTitle(String collectionId) {
    return _collections.firstWhere((element) => element.id == collectionId).title;
  }

  String getCollectionDescription(String collectionId) {
    return _collections.firstWhere((element) => element.id == collectionId).description;
  }

  int get itemsCount {
    return _collections.length;
  }
}