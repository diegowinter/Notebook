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
    var queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadernos',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 16,
        // centerTitle: true,
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
        // shadowColor: Colors.black,
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
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 3, 16, 16),
                    itemCount: collections.itemsCount,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, index) => GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.COLLECTION,
                        arguments: collections.collections[index].id,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: PopupMenuButton(
                                // icon: Icon(Icons.more_vert),
                                child: Container(
                                  width: 48,
                                  height: 36,
                                  alignment: Alignment.topRight,
                                  child: Icon(Icons.more_horiz),
                                ),
                                tooltip: 'Opções do caderno',
                                padding: EdgeInsets.zero,
                                onSelected: (value) {
                                  value == ItemOptions.Edit
                                      ? _editCollection(
                                          collections.collections[index].id)
                                      : _deleteCollection(context,
                                          collections.collections[index].id);
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(width: 20),
                                          Text('Editar caderno'),
                                        ],
                                      ),
                                      value: ItemOptions.Edit),
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(width: 20),
                                        Text('Excluir caderno'),
                                      ],
                                    ),
                                    value: ItemOptions.Delete,
                                  )
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  collections.collections[index].title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  collections.collections[index].description,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
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
