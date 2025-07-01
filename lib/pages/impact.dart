import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../main.dart';

class ImpactPage extends StatelessWidget {
  const ImpactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? ImpactWeb() : ImpactMobile();
  }
}

// =====================
// WEB VERSION
// =====================
class ImpactWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          WebHeader(),
          Container(
            constraints: BoxConstraints(maxWidth: 1100),
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Impact in Sri Lanka',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006622),
                  ),
                ),
                SizedBox(height: 24),
                ImpactStatsSection(),
                SizedBox(height: 40),
                Text(
                  'Top Food Heroes This Month',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006622),
                  ),
                ),
                SizedBox(height: 20),
                ImpactLeaderboardSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImpactStatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      {'label': 'Meals Shared', 'value': '14,275'},
      {'label': 'Active Donors', 'value': '932'},
      {'label': 'kg of Food Waste Saved', 'value': '2,831'},
      {'label': 'Local Businesses Joined', 'value': '215'},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: stats.map((stat) => ImpactStatCard(stat: stat)).toList(),
    );
  }
}

class ImpactStatCard extends StatelessWidget {
  final Map<String, String> stat;
  ImpactStatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Text(
            stat['value']!,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A75BB),
            ),
          ),
          SizedBox(height: 5),
          Text(
            stat['label']!,
            style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}

class ImpactLeaderboardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final leaders = [
      {'rank': 1, 'name': 'Janith\'s Bakery, Colombo', 'score': '387 meals'},
      {'rank': 2, 'name': 'Green Haven Hotel, Kandy', 'score': '251 meals'},
      {'rank': 3, 'name': 'Perera Family, Galle', 'score': '178 meals'},
    ];
    return Column(
      children:
          leaders.map((leader) => ImpactLeaderItem(leader: leader)).toList(),
    );
  }
}

class ImpactLeaderItem extends StatelessWidget {
  final Map<String, dynamic> leader;
  ImpactLeaderItem({required this.leader});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Text(
            '${leader['rank']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color(0xFFFF9E1B),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(width: 20),
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFE0E0E0),
            child: Icon(Icons.person, color: Colors.grey),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              leader['name'],
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            leader['score'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A75BB),
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
class ImpactMobile extends StatelessWidget {
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
        automaticallyImplyLeading: false, // Remove default hamburger on left
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
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Our Impact in Sri Lanka',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
          ),
          SizedBox(height: 16),
          ImpactStatsSectionMobile(),
          SizedBox(height: 32),
          Text(
            'Top Food Heroes This Month',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
          ),
          SizedBox(height: 16),
          ImpactLeaderboardSectionMobile(),
        ],
      ),
    );
  }
}

// Place this widget once in your codebase and reuse for all mobile pages
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

class ImpactStatsSectionMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      {'label': 'Meals Shared', 'value': '14,275'},
      {'label': 'Active Donors', 'value': '932'},
      {'label': 'kg of Food Waste Saved', 'value': '2,831'},
      {'label': 'Local Businesses Joined', 'value': '215'},
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: stats.map((stat) => ImpactStatCardMobile(stat: stat)).toList(),
    );
  }
}

class ImpactStatCardMobile extends StatelessWidget {
  final Map<String, String> stat;
  ImpactStatCardMobile({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text(
            stat['value']!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A75BB),
            ),
          ),
          SizedBox(height: 3),
          Text(
            stat['label']!,
            style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}

class ImpactLeaderboardSectionMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final leaders = [
      {'rank': 1, 'name': 'Janith\'s Bakery, Colombo', 'score': '387 meals'},
      {'rank': 2, 'name': 'Green Haven Hotel, Kandy', 'score': '251 meals'},
      {'rank': 3, 'name': 'Perera Family, Galle', 'score': '178 meals'},
    ];
    return Column(
      children:
          leaders
              .map((leader) => ImpactLeaderItemMobile(leader: leader))
              .toList(),
    );
  }
}

class ImpactLeaderItemMobile extends StatelessWidget {
  final Map<String, dynamic> leader;
  ImpactLeaderItemMobile({required this.leader});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Row(
        children: [
          Text(
            '${leader['rank']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFFFF9E1B),
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFFE0E0E0),
            child: Icon(Icons.person, color: Colors.grey),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              leader['name'],
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          Text(
            leader['score'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A75BB),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
