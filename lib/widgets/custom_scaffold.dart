import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget body;

  CustomScaffold({
    required this.title,
    this.actions = const [],
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (actions.isNotEmpty) Row(children: actions),
              ],
            ),
          ),
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
