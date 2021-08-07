import 'package:flutter/material.dart';

class EmptyListMessage extends StatelessWidget {
  final Icon icon;
  final String title;
  final String subtitle;
  final Function onReloadPressed;

  EmptyListMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onReloadPressed
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 20
            ),
          ),
          Text(subtitle),
          TextButton(
            onPressed: () => onReloadPressed(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh),
                SizedBox(width: 5),
                Text('Recarregar')
              ],
            ),
          )
        ],
      ),
    );
  }
}