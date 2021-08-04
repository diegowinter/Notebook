import 'package:flutter/material.dart';
import 'package:notebook/providers/collections.dart';
import 'package:notebook/providers/user.dart';
import 'package:notebook/utils/app_routes.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _nameController = new TextEditingController();
  final _descriptionController = new TextEditingController();

  _newCollectionModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        ),
      ),
      isScrollControlled: true,
      builder: (_) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Como a coleção vai se chamar?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nome da coleção'
                  ),
                  controller: _nameController,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Descrição da coleção'
                  ),
                  controller: _descriptionController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Adicionar'),
                      onPressed: () async {
                        await _addCollection();
                        _nameController.clear();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Future<void> _addCollection() async {
    return Provider.of<Collections>(context, listen: false).addCollection(_nameController.text, _descriptionController.text);
  }

  Future<void> _refreshCollections() async {
    return Provider.of<Collections>(context, listen: false).loadCollections();
  }

  late final Future _collections = Provider.of<Collections>(context, listen: false).loadCollections();

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Coleções'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _newCollectionModal(),
      ),
      body: Center(
        child: FutureBuilder(
          future: _collections,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.error != null) {
              return Center(child: Text('Ocorreu um erro.'));
            }
            return Consumer<Collections>(
              builder: (ctx, collections, child) {
                return RefreshIndicator(
                  onRefresh: () => _refreshCollections(),
                  child: ListView.builder(
                    itemCount: collections.itemsCount,
                    itemBuilder: (ctx, index) => Card(
                      child: ListTile(
                        title: Text(collections.collections[index].title),
                        subtitle: Text(collections.collections[index].description),
                        onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.COLLECTION,
                          arguments: collections.collections[index].id,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        )
      ),
    );
  }
}