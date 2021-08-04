import 'package:flutter/material.dart';
import 'package:notebook/providers/collections.dart';
import 'package:provider/provider.dart';

class AddCollectionModal extends StatefulWidget {
  @override
  _AddCollectionModalState createState() => _AddCollectionModalState();
}

class _AddCollectionModalState extends State<AddCollectionModal> with SingleTickerProviderStateMixin {
  bool _isLoading = false;

  GlobalKey<FormState> _form = GlobalKey();

  Map<String, String> _formData = {
    'name': '',
    'description': ''
  };

  Future<void> _addCollection(BuildContext context) async {
    if (!_form.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState!.save();
    await Provider.of<Collections>(context, listen: false)
        .addCollection(_formData['name'] ?? '', _formData['description'] ?? '');
    
    Navigator.of(context).pop();

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        child: Container(
          padding: EdgeInsets.all(16),
          child: _isLoading
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Adicionando...')
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Como a coleção vai se chamar?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nome da coleção'
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'O nome não pode ser vazio.';
                            }
                            return null;
                          },
                          onSaved: (value) => _formData['name'] = value!,
                          textInputAction: TextInputAction.next,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Descrição da coleção'
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'A descrição não pode ser vazia.';
                            }
                            return null;
                          },
                          onSaved: (value) => _formData['description'] = value!,
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Adicionar'),
                        onPressed: () async {
                          await _addCollection(context);
                        },
                      )
                    ],
                  ),
                ],
            ),
        ),
      ),
    );
  }
}