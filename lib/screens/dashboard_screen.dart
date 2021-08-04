import 'package:flutter/material.dart';
import 'package:notebook/providers/collections.dart';
import 'package:notebook/utils/app_routes.dart';
import 'package:notebook/widgets/add_collection_modal.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  _newCollectionModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        ),
      ),
      isScrollControlled: true,
      builder: (_) => AddCollectionModal()
    );
  }

  Future<void> _refreshCollections() async {
    return Provider.of<Collections>(context, listen: false).loadCollections();
  }

  late final Future _collections = Provider.of<Collections>(context, listen: false).loadCollections();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coleções'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _newCollectionModal(),
      ),
      body: Center(
        child: FutureBuilder(
          future: _collections,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Consumer<Collections>(
              builder: (ctx, collections, child) {
                if (collections.itemsCount == 0) {
                  return Center(child: Text('As coleções aparecerão aqui.'));
                }
                return RefreshIndicator(
                  onRefresh: () => _refreshCollections(),
                  child: ListView.builder(
                    itemCount: collections.itemsCount,
                    itemBuilder: (ctx, index) => Card(
                      child: ListTile(
                        title: Text(collections.collections[index].title),
                        subtitle: Text(collections.collections[index].description),
                        onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.COLLECTION,
                          arguments: collections.collections[index].id,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        )
      ),
    );
  }
}