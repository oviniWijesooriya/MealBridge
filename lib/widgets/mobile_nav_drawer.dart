import 'package:flutter/material.dart';

class MobileNavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF009933)),
            child: Row(
              children: [
                Text(
                  'Meal',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Bridge',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9E1B),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Sri Lanka',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Color(0xFF009933)),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.of(context).pushReplacementNamed('/');
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.restaurant, color: Color(0xFF009933)),
            title: Text('Find Food'),
            onTap: () {
              Navigator.of(context).pop();
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.of(context).pushReplacementNamed('/find-food');
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.volunteer_activism, color: Color(0xFF009933)),
            title: Text('Donate'),
            onTap: () {
              Navigator.of(context).pop();
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.of(context).pushReplacementNamed('/donate');
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.emoji_events, color: Color(0xFF009933)),
            title: Text('Impact'),
            onTap: () {
              Navigator.of(context).pop();
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.of(context).pushReplacementNamed('/impact');
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.login, color: Color(0xFF009933)),
            title: Text('Login'),
            onTap: () {
              Navigator.of(context).pop();
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.of(context).pushReplacementNamed('/login');
              });
            },
          ),
        ],
      ),
    );
  }
}
