import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:notebook/providers/pages.dart';

class PageViewerScreen extends StatelessWidget {
  const PageViewerScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollectionPage page = ModalRoute.of(context)!.settings.arguments as CollectionPage;

    return Scaffold(
      appBar: AppBar(
        title: Text(page.title),
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