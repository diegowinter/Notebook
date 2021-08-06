import 'package:flutter/material.dart';
import 'package:notebook/providers/collections.dart';
import 'package:notebook/providers/pages.dart';
import 'package:notebook/utils/Dialogs.dart';
import 'package:notebook/utils/app_routes.dart';
import 'package:notebook/utils/mode.dart';
import 'package:provider/provider.dart';

enum ItemOptions {
  Edit,
  Delete
}

class CollectionScreen extends StatelessWidget {
  final collectionId;
  CollectionScreen({ required this.collectionId});

  void _editPage(BuildContext context, CollectionPage collectionPage) {
    Navigator.of(context).pushNamed(
      AppRoutes.PAGE_COMPOSER,
      arguments: {
        'collectionId': collectionId,
        'collectionPage': collectionPage,
        'mode': Mode.EDIT
      }
    );
  }

  Future<void> _deletePage(BuildContext context, String pageId) async {
    bool confirmation = await Dialogs.confirmationDialog(
      context: context,
      title: 'Excluir página',
      content: 'Tem certeza que deseja excluir esta página?'
    );
    if (confirmation) {
      Provider.of<Pages>(context, listen: false).deletePage(pageId);
    }
  }

  void _editCollection() {
    print('edit...');
  }

  Future<void> _deleteCollection(BuildContext context, String collectionId) async {
    bool confirmation = await Dialogs.confirmationDialog(
      context: context,
      title: 'Excluir coleção',
      content: 'Tem certeza que deseja excluir esta coleção?'
    );
    if (confirmation) {
      Provider.of<Collections>(context, listen: false).deleteCollection(collectionId);
      Navigator.of(context).pop();
    }
  }

  Future<void> _refreshPages(BuildContext context, String collectionId) async {
    return Provider.of<Pages>(context, listen: false).loadPages(collectionId);
  }

  @override
  Widget build(BuildContext context) {
    final collections = Provider.of<Collections>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              collections.getCollectionTitle(collectionId),
            ),
            Text(
              collections.getCollectionDescription(collectionId),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal
              ),
            )
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              value == ItemOptions.Edit
                ? _editCollection()
                : _deleteCollection(context, collectionId);
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
                value: ItemOptions.Edit,
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
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRoutes.PAGE_COMPOSER,
            arguments: {
              'collectionId': collectionId,
              'mode': Mode.CREATE
            }
          );
        },
      ),
      body: Center(
        child: FutureBuilder(
          future: Provider.of<Pages>(context, listen: false).loadPages(collectionId),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Consumer<Pages>(
              builder: (ctx, pages, child) {
                if (pages.pagesCount == 0) {
                  return Center(
                    child: Text('As páginas desta coleção aparecerão aqui.'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => _refreshPages(context, collectionId),
                  child: ListView.builder(
                    itemCount: pages.pagesCount,
                    itemBuilder: (ctx, index) => Card(
                      child: ListTile(
                        leading: Container(
                          height: double.infinity,
                          child: Icon(Icons.article)
                        ),
                        title: Text(pages.pages[index].title),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          onSelected: (value) {
                            value == ItemOptions.Edit
                              ? _editPage(context, pages.pages[index])
                              : _deletePage(context, pages.pages[index].pageId);
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
                              value: ItemOptions.Edit,
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
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.PAGE_VIEWER,
                            arguments: pages.pages[index]
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )
      ),
    );
  }
}