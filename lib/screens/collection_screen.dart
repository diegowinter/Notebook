import 'package:flutter/material.dart';
import 'package:notebook/providers/pages.dart';
import 'package:notebook/utils/app_routes.dart';
import 'package:provider/provider.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({ Key? key }) : super(key: key);

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  late final Future _pages = Provider.of<Pages>(context).loadPages('-Mg8joB-Y-UkOJDfxKA6');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coleção')
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.PAGE_COMPOSER),
      ),
      body: Center(
        child: FutureBuilder(
          future: _pages,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Consumer<Pages>(
              builder: (ctx, pages, child) {
                return ListView.builder(
                  itemCount: pages.pages.length,
                  itemBuilder: (ctx, index) => Card(
                    child: ListTile(
                      title: Text(pages.pages[index].title)
                    ),
                  ),
                );
              },
            );
          },
        )
      ),
    );
  }
}