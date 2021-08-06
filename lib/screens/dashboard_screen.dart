import 'package:flutter/material.dart';
import 'package:notebook/providers/collections.dart';
import 'package:notebook/utils/app_routes.dart';
import 'package:notebook/widgets/add_collection_modal.dart';
import 'package:provider/provider.dart';

enum ItemOptions {
  Edit,
  Delete
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
      builder: (_) => AddCollectionModal()
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Excluir coleção'),
        content: Text('Tem certeza que deseja excluir esta coleção?'),
        actions: [
          TextButton(
            child: Text('Não'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Sim'),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      )
    );
  }

  Future<void> _editPage() async {
    print('edit...');
  }

  Future<void> _deletePage(BuildContext context, String collectionId) async {
    bool confirmation = await _showDeleteConfirmationDialog(context);
    if (confirmation) {
      Provider.of<Collections>(context, listen: false).deleteCollection(collectionId);
    }
  }

  Future<void> _refreshCollections() async {
    return Provider.of<Collections>(context, listen: false).loadCollections();
  }

  late final Future _collections = Provider.of<Collections>(context, listen: false).loadCollections();

  @override
  Widget build(BuildContext context) {
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
            }
            return Consumer<Collections>(
              builder: (ctx, collections, child) {
                if (collections.itemsCount == 0) {
                  return Center(child: Text('As coleções aparecerão aqui.'));
                }
                return RefreshIndicator(
                  onRefresh: () => _refreshCollections(),
                  child: ListView.builder(
                    itemCount: collections.itemsCount,
                    itemBuilder: (ctx, index) => Card(
                      child: ListTile(
                        leading: Container(
                          height: double.infinity,
                          child: Icon(Icons.book)
                        ),
                        title: Text(collections.collections[index].title),
                        subtitle: Text(collections.collections[index].description),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          onSelected: (value) {
                            value == ItemOptions.Edit
                              ? _editPage()
                              : _deletePage(context, collections.collections[index].id);
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 20),
                                  Text('Editar'),
                                ],
                              ),
                              value: ItemOptions.Edit
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 20),
                                  Text('Excluir'),
                                ],
                              ),
                              value: ItemOptions.Delete,
                            )
                          ],
                        ),
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