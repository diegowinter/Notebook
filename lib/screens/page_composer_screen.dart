import 'package:flutter/material.dart';
import 'package:notebook/providers/pages.dart';
import 'package:notebook/utils/app_routes.dart';
import 'package:notebook/utils/dialogs.dart';
import 'package:notebook/utils/mode.dart';
import 'package:notebook/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class PageComposerScreen extends StatefulWidget {
  final CollectionPage? collectionPage;
  final String collectionId;
  final Mode mode;

  PageComposerScreen({
    this.collectionPage,
    required this.collectionId,
    required this.mode
  });

  @override
  _PageComposerScreenState createState() => _PageComposerScreenState();
}

class _PageComposerScreenState extends State<PageComposerScreen> {
  final _titleController = new TextEditingController();
  final _contentController = new TextEditingController();
  bool _isLoading = false;

  Future<void> _savePageEdit(String pageId, String newTitle, String newContent) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Pages>(context, listen: false).updatePage(pageId, newTitle, newContent);
      Navigator.of(context).pop(CollectionPage(
        pageId: pageId,
        collectionId: widget.collectionId,
        title: newTitle.isNotEmpty ? newTitle : 'Página sem título',
        content: newContent
      ));
    } catch (error) {
      print(error);
    }
    setState(() {
      _isLoading = false;
    });
  }

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
  void initState() {
    super.initState();
    if (widget.mode == Mode.EDIT) {
      _titleController.text = widget.collectionPage!.title;
      _contentController.text = widget.collectionPage!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () async {
            bool confirmation = await Dialogs.confirmationDialog(
              context: context,
              title: 'Sair do editor',
              content: 'Tem certeza que deseja sair sem salvar suas alterações?'
            );
            if (confirmation) {
              Navigator.of(context).pop();
            }
          },
          tooltip: 'Fechar editor',
        ),
        title: Text(
          widget.mode == Mode.CREATE
            ? 'Nova página'
            : 'Editar página'
        ),
      ),
      body: _isLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text(widget.mode == Mode.CREATE
                  ? 'Adicionando...'
                  : 'Salvando alterações...'
                )
              ],
            )
          )
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomTextFormField(
                  hint: 'Título',
                  controller: _titleController,
                  maxLength: 100,
                  onSaved: (value) {},
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return null;
                  },
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Conteúdo',
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none
                      ),
                      isCollapsed: true,
                      contentPadding: EdgeInsets.all(16)
                    ),
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    controller: _contentController,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength }) {
                      return Text(currentLength.toString());
                    },
                    textCapitalization: TextCapitalization.sentences,
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
                          pageId: '',
                          collectionId: 'collectionId',
                          title: _titleController.text, 
                          content: _contentController.text
                        )
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder()
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      child: Text('Salvar'),
                      onPressed: () {
                        if (widget.mode == Mode.CREATE) {
                          _savePage(context, widget.collectionId, _titleController.text, _contentController.text);
                        } else {
                          _savePageEdit(widget.collectionPage!.pageId, _titleController.text, _contentController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder()
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
    );
  }
}