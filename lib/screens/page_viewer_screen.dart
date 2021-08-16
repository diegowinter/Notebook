import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/pages.dart';
import '../utils/Dialogs.dart';
import '../utils/app_routes.dart';
import '../utils/mode.dart';
import '../widgets/custom_scaffold.dart';

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
    return CustomScaffold(
      leading: IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Voltar',
      ),
      title: displayingPage.title.isEmpty
          ? 'Página sem título'
          : displayingPage.title,
      actions: displayingPage.pageId.isEmpty
          ? []
          : [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 30.0, maxWidth: 16.0),
                child: PopupMenuButton(
                  padding: EdgeInsets.zero,
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
              ),
            ],
      body: Markdown(
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
          code: TextStyle(
            backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
          ),
          codeblockDecoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
