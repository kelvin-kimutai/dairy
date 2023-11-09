import 'package:flutter/material.dart';

import 'nav_drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            height: 120,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Milk Collection',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Administrator',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          NavDrawerItem(
              label: 'Collections',
              icon: Icons.access_time,
              function: () => Navigator.pushReplacementNamed(context, '/home')),
          NavDrawerItem(
              label: 'Farmers',
              icon: Icons.person,
              function: () =>
                  Navigator.pushReplacementNamed(context, '/farmers')),
          NavDrawerItem(
              label: 'Payments',
              icon: Icons.attach_money,
              function: () =>
                  Navigator.pushReplacementNamed(context, '/payments')),
          NavDrawerItem(
              label: 'Settings',
              icon: Icons.settings,
              function: () =>
                  Navigator.pushReplacementNamed(context, '/settings')),
          // NavDrawerItem(
          //     label: 'Logout',
          //     icon: Icons.logout,
          //     function: () async {
          //       await FirebaseAuth.instance.signOut();
          //       Navigator.popAndPushNamed(context, '/');
          //     }),
        ],
      ),
    );
  }

  void showAboutDialog(context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text(
          'About',
          style: TextStyle(color: Colors.blue),
        ),
        content: SingleChildScrollView(
            child: Center(
          child: Text('Developed by Vortech Studios.'),
        )),
      ),
    );
  }
}
