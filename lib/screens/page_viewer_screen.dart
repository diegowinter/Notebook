import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/pages.dart';
import '../utils/Dialogs.dart';
import '../utils/app_routes.dart';
import '../utils/mode.dart';

enum ItemOptions {
  Edit,
  Delete,
}

class PageViewerScreen extends StatefulWidget {
  final CollectionPage page;

  PageViewerScreen(this.page);

  @override
  _PageViewerScreenState createState() => _PageViewerScreenState();
}

class _PageViewerScreenState extends State<PageViewerScreen> {
  late CollectionPage displayingPage;

  @override
  void initState() {
    super.initState();
    displayingPage = widget.page;
  }

  void _editPage(
    BuildContext context,
    String collectionId,
    CollectionPage collectionPage,
  ) {
    Navigator.of(context).pushNamed(
      AppRoutes.PAGE_COMPOSER,
      arguments: {
        'collectionId': collectionId,
        'collectionPage': collectionPage,
        'mode': Mode.EDIT
      },
    ).then((value) {
      setState(() {
        if (value != null) {
          displayingPage = value as CollectionPage;
        }
      });
    });
  }

  Future<void> _deletePage(BuildContext context, String pageId) async {
    bool confirmation = await Dialogs.confirmationDialog(
      context: context,
      title: 'Excluir página',
      content: 'Tem certeza que deseja excluir esta página?',
    );
    if (confirmation) {
      Provider.of<Pages>(context, listen: false).deletePage(pageId);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: displayingPage.pageId.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayingPage.title.isEmpty
                        ? 'Página sem título'
                        : displayingPage.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(2)),
                    child: Text(
                      'Pré-visualização',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              )
            : Text(
                displayingPage.title,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
        // centerTitle: true,
        actions: displayingPage.pageId.isEmpty
            ? []
            : [
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  tooltip: 'Opções da página',
                  onSelected: (value) {
                    value == ItemOptions.Edit
                        ? _editPage(
                            context,
                            displayingPage.collectionId,
                            displayingPage,
                          )
                        : _deletePage(
                            context,
                            displayingPage.pageId,
                          );
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
              ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: queryData.size.width > 1000
              ? ((queryData.size.width - 1000) / 2) + 16
              : 16,
          vertical: 16,
        ),
        child: Markdown(
          data: displayingPage.content,
          selectable: true,
          extensionSet: md.ExtensionSet(
            md.ExtensionSet.gitHubFlavored.blockSyntaxes,
            [...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
          ),
          onTapLink: (text, href, title) => launch(href ?? ''),
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            blockquotePadding: EdgeInsets.only(left: 14),
            blockquoteDecoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Color.fromRGBO(66, 66, 66, 1),
                  width: 4,
                ),
              ),
            ),
            h1: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            h1Padding: EdgeInsets.only(top: 16),
            h2: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            h2Padding: EdgeInsets.only(top: 16),
            h3: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            h3Padding: EdgeInsets.only(top: 16),
            h4: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            h4Padding: EdgeInsets.only(top: 16),
            h5: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            h5Padding: EdgeInsets.only(top: 16),
            h6: TextStyle(
              fontSize: 16,
            ),
            h6Padding: EdgeInsets.only(top: 16),
            a: TextStyle(fontSize: 16),
            img: TextStyle(fontSize: 16),
            em: TextStyle(fontSize: 16),
            del: TextStyle(fontSize: 16),
            p: TextStyle(fontSize: 16),
            code: TextStyle(
              backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
            ),
            codeblockDecoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}
