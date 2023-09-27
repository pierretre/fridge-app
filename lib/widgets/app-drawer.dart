import 'package:flutter/material.dart';
import 'package:fridge_app/services/db-service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: const Text('delete database'),
            onTap: () => showDialog(
              context: context, 
              builder: (BuildContext context) {
                return AlertDialog.adaptive(
                  title: const Text('Delete data'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        DbService.dumpDatabase();
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('CANCEL'),
                      onPressed: () => Navigator.of(context).pop()
                    ),
                  ],
                );
              },
            )
          )
        ],
      )
    );
  }
}