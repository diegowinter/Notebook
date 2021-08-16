import 'package:flutter/material.dart';
import 'package:notebook/providers/user.dart';
import 'package:notebook/utils/app_routes.dart';
import 'package:notebook/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

import '../providers/preferences.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<Preferences>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);

    return CustomScaffold(
      leading: IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Voltar',
      ),
      title: 'Configurações',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 5),
              child: Text(
                'Conta',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 5),
                  child: Text('E-mail: ' + user.email),
                ),
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    user.logout();
                    Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH);
                  },
                )
              ],
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Voltar',
        ),
        title: Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
