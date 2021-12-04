import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/collections.dart';
import '../providers/user.dart';
import '../utils/app_routes.dart';
import '../utils/dialogs.dart';
import '../utils/mode.dart';
import '../widgets/add_collection_modal.dart';
import '../widgets/empty_list_message.dart';

enum ItemOptions {
  Edit,
  Delete,
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
          topRight: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      builder: (_) => AddCollectionModal(
        mode: Mode.CREATE,
      ),
    );
  }

  void _editCollection(String collectionId) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      builder: (_) => AddCollectionModal(
        collectionId: collectionId,
        mode: Mode.EDIT,
      ),
    );
  }

  Future<void> _deleteCollection(
      BuildContext context, String collectionId) async {
    bool confirmation = await Dialogs.confirmationDialog(
      context: context,
      title: 'Excluir coleção',
      content: 'Tem certeza que deseja excluir esta coleção?',
    );
    if (confirmation) {
      Provider.of<Collections>(context, listen: false)
          .deleteCollection(collectionId);
    }
  }

  Future<void> _refreshCollections() async {
    return Provider.of<Collections>(context, listen: false).loadCollections();
  }

  late final Future _collections =
      Provider.of<Collections>(context, listen: false).loadCollections();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadernos',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 16,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Nova coleção',
            onPressed: () => _newCollectionModal(),
          ),
          IconButton(
            icon: CircleAvatar(
              child: Text(user.email.substring(0, 1)),
            ),
            tooltip: 'Meu perfil',
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.SETTINGS),
          ),
        ],
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
                  return EmptyListMessage(
                    icon: Icon(Icons.book),
                    title: 'Ainda não há coleções',
                    subtitle: 'Crie uma nova no botão +',
                    onReloadPressed: _refreshCollections,
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => _refreshCollections(),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: collections.itemsCount,
                    itemBuilder: (ctx, index) => ListTile(
                      leading: Container(
                        height: double.infinity,
                        child: Icon(Icons.book),
                      ),
                      title: Text(collections.collections[index].title),
                      subtitle: Text(
                        collections.collections[index].description,
                      ),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        tooltip: 'Opções da coleção',
                        onSelected: (value) {
                          value == ItemOptions.Edit
                              ? _editCollection(
                                  collections.collections[index].id)
                              : _deleteCollection(
                                  context, collections.collections[index].id);
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 20),
                                  Text('Editar coleção'),
                                ],
                              ),
                              value: ItemOptions.Edit),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(width: 20),
                                Text('Excluir coleção'),
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
