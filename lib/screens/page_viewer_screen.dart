import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:notebook/providers/pages.dart';
import 'package:provider/provider.dart';

enum ItemOptions {
  Edit,
  Delete
}

class PageViewerScreen extends StatelessWidget {
  const PageViewerScreen({ Key? key }) : super(key: key);

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Excluir página'),
        content: Text('Tem certeza que deseja excluir esta página?'),
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

  Future<void> _deletePage(BuildContext context, String pageId) async {
    bool confirmation = await _showDeleteConfirmationDialog(context);
    if (confirmation) {
      Provider.of<Pages>(context, listen: false).deletePage(pageId);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final CollectionPage page = ModalRoute.of(context)!.settings.arguments as CollectionPage;

    return Scaffold(
      appBar: AppBar(
        title: Text(page.title),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              value == ItemOptions.Edit
                ? _editPage()
                : _deletePage(context, page.pageId);
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
              )
            ],
          ),
        ],
      ),
      body: Markdown(
        data: page.content,
        selectable: true,
        extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
          [...md.ExtensionSet.gitHubFlavored.inlineSyntaxes]
        ),
      )
    );
  }
}