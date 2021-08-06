import 'package:flutter/material.dart';

class Dialogs {
  static Future<bool> confirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text('Não'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Sim'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}
