import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/collections.dart';
import '../providers/pages.dart';
import '../utils/Dialogs.dart';
import '../utils/app_routes.dart';
import '../utils/mode.dart';
import '../widgets/add_collection_modal.dart';
import '../widgets/empty_list_message.dart';

enum ItemOptions {
  Edit,
  Delete,
}

class CollectionScreen extends StatelessWidget {
  final collectionId;
  CollectionScreen({
    required this.collectionId,
  });

  void _editPage(BuildContext context, CollectionPage collectionPage) {
    Navigator.of(context).pushNamed(
      AppRoutes.PAGE_COMPOSER,
      arguments: {
        'collectionId': collectionId,
        'collectionPage': collectionPage,
        'mode': Mode.EDIT,
      },
    );
  }

  Future<void> _deletePage(BuildContext context, String pageId) async {
    bool confirmation = await Dialogs.confirmationDialog(
      context: context,
      title: 'Excluir página',
      content: 'Tem certeza que deseja excluir esta página?',
    );
    if (confirmation) {
      Provider.of<Pages>(context, listen: false).deletePage(pageId);
    }
  }

  void _editCollection(BuildContext context, String collectionId) {
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
      Navigator.of(context).pop();
    }
  }

  Future<void> _refreshPages(BuildContext context, String collectionId) async {
    return Provider.of<Pages>(context, listen: false).loadPages(collectionId);
  }

  @override
  Widget build(BuildContext context) {
    final collections = Provider.of<Collections>(context);
    var queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Voltar',
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              collections.getCollectionTitle(collectionId),
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              collections.getCollectionDescription(collectionId),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            )
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Nova página',
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PAGE_COMPOSER,
                arguments: {
                  'collectionId': collectionId,
                  'mode': Mode.CREATE,
                },
              );
            },
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            tooltip: 'Opções da coleção',
            onSelected: (value) {
              value == ItemOptions.Edit
                  ? _editCollection(context, collectionId)
                  : _deleteCollection(context, collectionId);
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
                value: ItemOptions.Edit,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 20),
                    Text('Excluir coleção'),
                  ],
                ),
                value: ItemOptions.Delete,
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: Provider.of<Pages>(context, listen: false)
              .loadPages(collectionId),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Consumer<Pages>(
              builder: (ctx, pages, child) {
                if (pages.pagesCount == 0) {
                  return EmptyListMessage(
                    icon: Icon(Icons.article),
                    title: 'Ainda não há páginas',
                    subtitle: 'Crie uma nova no botão +',
                    onReloadPressed: () => _refreshPages(context, collectionId),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => _refreshPages(context, collectionId),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: pages.pagesCount,
                    itemBuilder: (ctx, index) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: queryData.size.width > 1000
                            ? ((queryData.size.width - 1000) / 2) + 16
                            : 16,
                      ),
                      child: ListTile(
                        leading: Container(
                          height: double.infinity,
                          child: Icon(Icons.article),
                        ),
                        title: Text(pages.pages[index].title),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          tooltip: 'Opções da página',
                          onSelected: (value) {
                            value == ItemOptions.Edit
                                ? _editPage(context, pages.pages[index])
                                : _deletePage(
                                    context, pages.pages[index].pageId);
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 20),
                                  Text('Editar página'),
                                ],
                              ),
                              value: ItemOptions.Edit,
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 20),
                                  Text('Excluir página'),
                                ],
                              ),
                              value: ItemOptions.Delete,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.PAGE_VIEWER,
                            arguments: pages.pages[index],
                          );
                        },
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
