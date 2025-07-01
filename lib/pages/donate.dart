import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../main.dart';

class DonatePage extends StatelessWidget {
  const DonatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? DonateWeb() : DonateMobile();
  }
}

// =====================
// WEB VERSION
// =====================
class DonateWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          WebHeader(),
          Container(
            constraints: BoxConstraints(maxWidth: 900),
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Donate Surplus Food',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006622),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Share your surplus food directly with low-income families and charitable organizations for free. Fill out the form below to list your donation.',
                  style: TextStyle(fontSize: 18, color: Color(0xFF555555)),
                ),
                SizedBox(height: 32),
                DonateFormWeb(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DonateFormWeb extends StatefulWidget {
  @override
  State<DonateFormWeb> createState() => _DonateFormWebState();
}

class _DonateFormWebState extends State<DonateFormWeb> {
  final _formKey = GlobalKey<FormState>();
  String? foodTitle, location, serves, expiry;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Food Title'),
            onSaved: (v) => foodTitle = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: 'Location'),
            onSaved: (v) => location = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: 'Serves (e.g. 4 people)'),
            onSaved: (v) => serves = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: 'Available Until'),
            onSaved: (v) => expiry = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF009933),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Donation submitted!')));
              }
            },
            child: Text(
              'Submit Donation',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================
// MOBILE VERSION
// =====================
class DonateMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF009933),
        title: Row(
          children: [
            Text(
              'Meal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Bridge',
              style: TextStyle(
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
        automaticallyImplyLeading: false, // Removes default left hamburger
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
          ),
        ],
      ),
      endDrawer: MobileNavDrawer(),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text(
            'Donate Surplus Food',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Share your surplus food directly with low-income families and charitable organizations for free. Fill out the form below to list your donation.',
            style: TextStyle(fontSize: 15, color: Color(0xFF555555)),
          ),
          SizedBox(height: 24),
          DonateFormMobile(),
        ],
      ),
    );
  }
}

// Place this widget in your codebase (once, and reuse for all mobile pages)
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

class DonateFormMobile extends StatefulWidget {
  @override
  State<DonateFormMobile> createState() => _DonateFormMobileState();
}

class _DonateFormMobileState extends State<DonateFormMobile> {
  final _formKey = GlobalKey<FormState>();
  String? foodTitle, location, serves, expiry;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Food Title'),
            onSaved: (v) => foodTitle = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(labelText: 'Location'),
            onSaved: (v) => location = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(labelText: 'Serves (e.g. 4 people)'),
            onSaved: (v) => serves = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(labelText: 'Available Until'),
            onSaved: (v) => expiry = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF009933),
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Donation submitted!')));
              }
            },
            child: Text(
              'Submit Donation',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
