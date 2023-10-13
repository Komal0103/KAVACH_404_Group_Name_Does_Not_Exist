import 'package:flutter/material.dart';

class setting_page extends StatefulWidget {
  const setting_page({super.key});

  @override
  State<setting_page> createState() => _setting_pageState();
}

class _setting_pageState extends State<setting_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {},
            ),
          ),
          ListTile(
            title: Text('Notification'),
            trailing: Switch(
              value: false,
              onChanged: (bool value) {},
            ),
          ),
          ListTile(
            title: Text('Language'),
            subtitle: Text('English'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
