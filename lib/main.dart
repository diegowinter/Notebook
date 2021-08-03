import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './utils/app_routes.dart';
import './screens/auth_screen.dart';
import './screens/dashboard_screen.dart';
import './providers/collections.dart';
import './providers/user.dart';
import './screens/collection_screen.dart';
import './screens/page_composer_screen.dart';
import './screens/page_viewer_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new User(),
        ),
        ChangeNotifierProxyProvider<User, Collections>(
          create: (_) => new Collections('', '', []),
          update: (ctx, user, previousCollections) => new Collections(
            user.token,
            user.id,
            previousCollections!.collections
          ) ,
        )
      ],
      child: MaterialApp(
        title: 'Notebook',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          //primaryColor: Colors.green,
          primarySwatch: Colors.green,
          backgroundColor: Colors.black87
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: AuthScreen(),
        routes: {
          AppRoutes.AUTH: (ctx) => AuthScreen(),
          AppRoutes.DASHBOARD: (ctx) => DashboardScreen(),
          AppRoutes.COLLECTION: (ctx) => CollectionScreen(),
          AppRoutes.PAGE_COMPOSER: (ctx) => PageComposerScreen(),
          AppRoutes.PAGE_VIEWER: (ctx) => PageViewerScreen()
        },
      ),
    );
  }
}

