import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/preferences.dart';
import '../providers/user.dart';
import '../utils/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<Preferences>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text('E-mail: ' + user.email),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      user.logout();
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.AUTH);
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 5),
              child: Text(
                'Tema',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            RadioListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              title: Text('Tema claro'),
              value: ThemeMode.light,
              groupValue: preferences.themeMode,
              onChanged: preferences.setThemeMode,
            ),
            RadioListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              title: Text('Tema escuro'),
              value: ThemeMode.dark,
              groupValue: preferences.themeMode,
              onChanged: preferences.setThemeMode,
            ),
            RadioListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              title: Text('Tema atual do sistema'),
              value: ThemeMode.system,
              groupValue: preferences.themeMode,
              onChanged: preferences.setThemeMode,
            ),
          ],
        ),
      ),
    );
  }
}
