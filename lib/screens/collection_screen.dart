import 'package:flutter/material.dart';
import 'package:notebook/utils/app_routes.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({ Key? key }) : super(key: key);

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coleção')
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.PAGE_COMPOSER),
      ),
      body: Center(
        child: Text('As páginas aparecerão aqui')
      ),
    );
  }
}