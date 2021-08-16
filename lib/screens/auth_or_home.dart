import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import 'auth_screen.dart';
import 'dashboard_screen.dart';

class AuthOrHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of(context);

    return FutureBuilder(
      future: user.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro.'));
        } else {
          return user.isAuth ? DashboardScreen() : AuthScreen();
        }
      },
    );
  }
}
