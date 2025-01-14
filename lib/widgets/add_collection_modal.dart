import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/collections.dart';
import '../utils/mode.dart';
import 'custom_text_form_field.dart';

class AddCollectionModal extends StatefulWidget {
  final String collectionId;
  final Mode mode;

  AddCollectionModal({
    this.collectionId = '',
    required this.mode,
  });

  @override
  _AddCollectionModalState createState() => _AddCollectionModalState();
}

class _AddCollectionModalState extends State<AddCollectionModal> {
  bool _isLoading = false;

  GlobalKey<FormState> _form = GlobalKey();

  Map<String, String> _formData = {
    'name': '',
    'description': '',
  };

  Future<void> _editCollection() async {
    if (!_form.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState!.save();

    await Provider.of<Collections>(context, listen: false).updateCollection(
      widget.collectionId,
      _formData['name'] ?? '',
      _formData['description'] ?? '',
    );

    Navigator.of(context).pop();

    return Future.value();
  }

  Future<void> _addCollection() async {
    if (!_form.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState!.save();
    await Provider.of<Collections>(context, listen: false).addCollection(
      _formData['name'] ?? '',
      _formData['description'] ?? '',
    );

    Navigator.of(context).pop();

    return Future.value();
  }

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.mode == Mode.EDIT) {
      _nameController.text = Provider.of<Collections>(context, listen: false)
          .getCollectionTitle(widget.collectionId);
      _descriptionController.text =
          Provider.of<Collections>(context, listen: false)
              .getCollectionDescription(widget.collectionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: queryData.size.width > 1000
                  ? ((queryData.size.width - 1000) / 2) + 16
                  : 16,
              vertical: 16),
          child: _isLoading
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      widget.mode == Mode.CREATE
                          ? 'Criando caderno...'
                          : 'Salvando alterações...',
                    )
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Como o caderno vai se chamar?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Form(
                      key: _form,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: _nameController,
                            hint: 'Nome do caderno',
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'O nome não pode ser vazio.';
                              }
                              return null;
                            },
                            onSaved: (value) => _formData['name'] = value!,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            maxLength: 50,
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            controller: _descriptionController,
                            hint: 'Descrição do caderno',
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'A descrição não pode ser vazia.';
                              }
                              return null;
                            },
                            onSaved: (value) =>
                                _formData['description'] = value!,
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.sentences,
                            maxLength: 100,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            shape: StadiumBorder(),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          child: Text(
                            widget.mode == Mode.CREATE
                                ? 'Adicionar'
                                : 'Atualizar',
                          ),
                          onPressed: () async {
                            widget.mode == Mode.CREATE
                                ? await _addCollection()
                                : await _editCollection();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
