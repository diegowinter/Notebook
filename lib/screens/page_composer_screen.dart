import 'package:flutter/material.dart';
import 'package:notebook/utils/app_routes.dart';

class PageComposerScreen extends StatelessWidget {
  final _contentController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova página'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Título'
              ),
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
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Pré-visualizar'),
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.PAGE_VIEWER,
                    arguments: _contentController.text
                  ),
                ),
                TextButton(
                  child: Text('Salvar'),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}