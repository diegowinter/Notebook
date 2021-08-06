import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './utils/app_routes.dart';
import './screens/auth_screen.dart';
import './screens/dashboard_screen.dart';
import './providers/collections.dart';
import './providers/user.dart';
import './providers/pages.dart';
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
        ),
        ChangeNotifierProxyProvider<User, Pages>(
          create: (_) => new Pages('', '', []),
          update: (ctx, user, previousPages) => new Pages(
            user.id,
            user.token,
            previousPages!.pages
          ),
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
          // AppRoutes.COLLECTION: (ctx) => CollectionScreen(),
          // AppRoutes.PAGE_COMPOSER: (ctx) => PageComposerScreen(),
          // AppRoutes.PAGE_VIEWER: (ctx) => PageViewerScreen()
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AppRoutes.COLLECTION:
              final String argument = settings.arguments.toString();
              return MaterialPageRoute(
                builder: (context) {
                  return CollectionScreen(collectionId: argument);
                }
              );
            case AppRoutes.PAGE_COMPOSER:
              final argument = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) {
                  return PageComposerScreen(
                    collectionId: argument['collectionId'],
                    collectionPage: argument['collectionPage'],
                    mode: argument['mode'],
                  );
                }
              );
            case AppRoutes.PAGE_VIEWER:
              final argument = settings.arguments as CollectionPage;
              return MaterialPageRoute(
                builder: (context) {
                  return PageViewerScreen(argument);
                }
              );
          }
        },
      ),
    );
  }
}

