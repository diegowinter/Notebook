import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class PageViewerScreen extends StatelessWidget {
  const PageViewerScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Página'),
      ),
      body: Markdown(
        data: content.toString(),
        selectable: true,
        extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
          [...md.ExtensionSet.gitHubFlavored.inlineSyntaxes]
        ),
      ),
    );
  }
}