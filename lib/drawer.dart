import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AppProviders/DrawerProvider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _DrawerState();
}

class _DrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(shrinkWrap: true,
      itemCount: Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems.length,

      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems[index]),
        );
         ListTile(
          title: Text(Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems[index]),
        );
      },
    );
  }
}
