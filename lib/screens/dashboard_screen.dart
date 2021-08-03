import 'package:flutter/material.dart';
import 'package:notebook/providers/collections.dart';
import 'package:notebook/providers/user.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _controller = new TextEditingController();

  _newCollectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        ),
      ),
      isScrollControlled: true,
      builder: (_) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Como a coleção vai se chamar?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Nome da coleção'
                        ),
                        controller: _controller,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () async {
                        await _addCollection();
                        _controller.clear();
                        Navigator.of(context).pop();
                      }
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Future<void> _addCollection() async {
    return Provider.of<Collections>(context, listen: false).addCollection(_controller.text);
  }

  Future<void> _refreshCollections() async {
    return Provider.of<Collections>(context, listen: false).loadCollections();
  }

  late final Future _collections = Provider.of<Collections>(context, listen: false).loadCollections();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Coleções'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _newCollectionModal(context),
      ),
      body: Center(
        child: FutureBuilder(
          future: _collections,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.error != null) {
              return Center(child: Text('Ocorreu um erro.'));
            }
            return Consumer<Collections>(
              builder: (ctx, collections, child) {
                return RefreshIndicator(
                  onRefresh: () => _refreshCollections(),
                  child: ListView.builder(
                    itemCount: collections.itemsCount,
                    itemBuilder: (ctx, index) => ListTile(
                      title: Text(collections.collections[index].title),
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