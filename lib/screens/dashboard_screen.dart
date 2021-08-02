import 'package:flutter/material.dart';
import 'package:notebook/providers/user.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Coleções'),
      ),
      body: Center(
        child: Text(user.token),
      ),
    );
  }
}