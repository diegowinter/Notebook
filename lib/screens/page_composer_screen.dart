import 'package:flutter/material.dart';

class PageComposerScreen extends StatelessWidget {
  const PageComposerScreen({ Key? key }) : super(key: key);

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
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Pré-visualizar'),
                  onPressed: () {},
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