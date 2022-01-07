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
    var queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: queryData.size.width > 1000
              ? ((queryData.size.width - 1000) / 2) + 16
              : 16,
          vertical: 3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(user.name.substring(0, 1)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
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
                        Text(user.email),
                      ],
                    ),
                    Spacer(),
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
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tema',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
