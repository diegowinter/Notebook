import 'package:flutter/material.dart';
import 'package:notebook/providers/pages.dart';
import 'package:notebook/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PageComposerScreen extends StatefulWidget {
  @override
  _PageComposerScreenState createState() => _PageComposerScreenState();
}

class _PageComposerScreenState extends State<PageComposerScreen> {
  final _titleController = new TextEditingController();
  final _contentController = new TextEditingController();
  bool _isLoading = false;

  Future<void> _savePage(BuildContext context, String collectionId, String title, String content) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Pages>(context, listen: false).addPage(collectionId, title, content);
      Navigator.of(context).pop();
    } catch (error) {

    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String collectionId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Nova página'),
      ),
      body: _isLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Adicionando...')
              ],
            )
          )
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Título'
                  ),
                  controller: _titleController,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Conteúdo'
                    ),
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    controller: _contentController,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength }) => Text(
                      currentLength.toString()
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('Pré-visualizar'),
                      onPressed: () => Navigator.of(context).pushNamed(
                        AppRoutes.PAGE_VIEWER,
                        arguments: CollectionPage(
                          collectionId: 'collectionId',
                          title: _titleController.text, 
                          content: _contentController.text
                        )
                      ),
                    ),
                    TextButton(
                      child: Text('Salvar'),
                      onPressed: () => _savePage(context, collectionId, _titleController.text, _contentController.text),
                    ),
                  ],
                )
              ],
            ),
          ),
    );
  }
}