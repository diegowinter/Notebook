import 'package:flutter/material.dart';
import 'package:notebook/screens/page_viewer_screen.dart';
import 'package:page_transition/page_transition.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
        // centerTitle: true,
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
            tooltip: 'Opções do caderno',
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
                    Text('Editar caderno'),
                  ],
                ),
                value: ItemOptions.Edit,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 20),
                    Text('Excluir caderno'),
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
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 3, 16, 16),
                    itemCount: pages.pagesCount,
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: queryData.size.width ~/ 190,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, index) => GestureDetector(
                      // onTap: () {
                      //   Navigator.of(context).pushNamed(
                      //     AppRoutes.PAGE_VIEWER,
                      //     arguments: pages.pages[index],
                      //   );
                      // },
                      onTap: () => Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: PageViewerScreen(pages.pages[index]),
                        ),
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
                            ),
                            Text(
                              pages.pages[index].title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[300],
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
