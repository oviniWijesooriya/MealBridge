import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'pages/find_food.dart';
import 'pages/donate.dart';
import 'pages/impact.dart';

void main() {
  usePathUrlStrategy();
  runApp(kIsWeb ? MealBridgeWebApp() : MealBridgeMobileApp());
}

// =====================
// WEB VERSION
// =====================
class MealBridgeWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealBridge Sri Lanka',
      theme: ThemeData(
        primaryColor: Color(0xFF009933),
        fontFamily: 'Segoe UI',
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MealBridgeWebHomePage(),
        '/find-food': (context) => FindFoodPage(),
        '/donate': (context) => DonatePage(),
        '/impact': (context) => ImpactPage(),
        // '/login': (context) => LoginPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MealBridgeWebHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          WebHeader(),
          WebHeroSection(),
          WebDualPathSection(),
          WebFoodListingsSection(),
          WebImpactStatsSection(),
          WebLeaderboardSection(),
          WebFooterSection(),
        ],
      ),
    );
  }
}

// Web Header
class WebHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF009933),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Meal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Bridge',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9E1B),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Sri Lanka',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          Row(
            children: [
              WebNavButton(
                'Home',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              WebNavButton(
                'Find Food',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/find-food');
                },
              ),

              WebNavButton(
                'Donate',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/donate');
                },
              ),
              WebNavButton(
                'Impact',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/impact');
                },
              ),
              WebNavButton(
                'Login',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WebNavButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  WebNavButton(this.label, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

// Web Hero
class WebHeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Text(
            'Bridging Food Surplus to Communities in Need',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Text(
            'A youth-led initiative connecting excess food from households, bakeries, restaurants, and hotels to individuals and communities across Sri Lanka.',
            style: TextStyle(fontSize: 18, color: Color(0xFF555555)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WebCTAButton('I Want to Donate Food', Color(0xFF009933)),
              SizedBox(width: 20),
              WebCTAButton('I Need Food', Color(0xFFFF9E1B)),
              SizedBox(width: 20),
              WebCTAButton('Volunteer with Us', Color(0xFF1A75BB)),
            ],
          ),
        ],
      ),
    );
  }
}

class WebCTAButton extends StatelessWidget {
  final String label;
  final Color color;
  WebCTAButton(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: () {},
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Web Dual Path
class WebDualPathSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 80),
      child: Column(
        children: [
          Text(
            'Choose Your Path',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WebPathCard(
                title: 'Donate Food',
                description:
                    'Share your surplus food directly with low-income families and charitable organizations for free.',
                color: Color(0xFF009933),
                buttonLabel: 'Donate Now',
              ),
              SizedBox(width: 40),
              WebPathCard(
                title: 'Half-Price Market',
                description:
                    'Sell your surplus food at half price to anyone looking for affordable meal options.',
                color: Color(0xFFFF9E1B),
                buttonLabel: 'Browse Half-Price',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WebPathCard extends StatelessWidget {
  final String title, description, buttonLabel;
  final Color color;
  WebPathCard({
    required this.title,
    required this.description,
    required this.color,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(Icons.fastfood, color: color, size: 48),
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color),
            onPressed: () {},
            child: Text(buttonLabel, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Web Food Listings
class WebFoodListingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foodItems = [
      {
        'title': 'Breakfast Bakery Items',
        'location': 'Peradeniya Road, Kandy',
        'availableUntil': '12:00 PM today',
        'serves': '8-10 people',
        'type': 'Free Donation',
        'price': '',
        'color': Color(0xFF009933),
      },
      {
        'title': 'Rice Curry Family Pack',
        'location': 'Dalada Veediya, Kandy',
        'availableUntil': '7:00 PM today',
        'serves': '4 people',
        'type': 'Half Price',
        'price': 'LKR 350',
        'color': Color(0xFFFF9E1B),
      },
      {
        'title': 'Vegetable Selection',
        'location': 'Market Street, Kandy',
        'availableUntil': '4:00 PM today',
        'serves': 'Fresh produce - 5kg',
        'type': 'Free Donation',
        'price': '',
        'color': Color(0xFF009933),
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Near Kandy',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 25,
            runSpacing: 25,
            children: foodItems.map((item) => WebFoodCard(item: item)).toList(),
          ),
        ],
      ),
    );
  }
}

class WebFoodCard extends StatelessWidget {
  final Map<String, dynamic> item;
  WebFoodCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            color: Color(0xFFE0E0E0),
            child: Center(
              child: Icon(Icons.image, size: 60, color: Colors.grey),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['type'] == 'Free Donation')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: item['color'],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Free Donation',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (item['type'] == 'Half Price')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: item['color'],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${item['price']} Half Price',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                Text(
                  item['title'],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF009933), size: 18),
                    SizedBox(width: 5),
                    Text(item['location']),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Color(0xFF009933), size: 18),
                    SizedBox(width: 5),
                    Text(item['availableUntil']),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.people, color: Color(0xFF009933), size: 18),
                    SizedBox(width: 5),
                    Text(item['serves']),
                  ],
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item['color'],
                  ),
                  onPressed: () {},
                  child: Text(
                    item['type'] == 'Half Price' ? 'Purchase' : 'Request Now',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Web Impact Stats
class WebImpactStatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      {'label': 'Meals Shared', 'value': '14,275'},
      {'label': 'Active Donors', 'value': '932'},
      {'label': 'kg of Food Waste Saved', 'value': '2,831'},
      {'label': 'Local Businesses Joined', 'value': '215'},
    ];
    return Container(
      color: Color(0xFFE8F5E9),
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 80),
      child: Column(
        children: [
          Text(
            'Our Impact in Sri Lanka',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: stats.map((stat) => WebStatCard(stat: stat)).toList(),
          ),
        ],
      ),
    );
  }
}

class WebStatCard extends StatelessWidget {
  final Map<String, String> stat;
  WebStatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: EdgeInsets.all(20),
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

// Web Leaderboard
class WebLeaderboardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final leaders = [
      {'rank': 1, 'name': 'Janith\'s Bakery, Colombo', 'score': '387 meals'},
      {'rank': 2, 'name': 'Green Haven Hotel, Kandy', 'score': '251 meals'},
      {'rank': 3, 'name': 'Perera Family, Galle', 'score': '178 meals'},
    ];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Food Heroes This Month',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
          ),
          SizedBox(height: 20),
          Column(
            children:
                leaders.map((leader) => WebLeaderItem(leader: leader)).toList(),
          ),
        ],
      ),
    );
  }
}

class WebLeaderItem extends StatelessWidget {
  final Map<String, dynamic> leader;
  WebLeaderItem({required this.leader});

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

// Web Footer
class WebFooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF333333),
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 80),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Meal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Bridge',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9E1B),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Sri Lanka',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WebFooterLink('About Us'),
              WebFooterLink('How It Works'),
              WebFooterLink('Safety Guidelines'),
              WebFooterLink('Partner With Us'),
              WebFooterLink('Contact'),
            ],
          ),
          SizedBox(height: 20),
          Text(
            '© 2025 MealBridge Sri Lanka - Connecting Communities Through Food',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class WebFooterLink extends StatelessWidget {
  final String label;
  WebFooterLink(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: TextButton(
        onPressed: () {},
        child: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// =====================
// MOBILE VERSION
// =====================
class MealBridgeMobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealBridge Sri Lanka',
      theme: ThemeData(
        primaryColor: Color(0xFF009933),
        fontFamily: 'Segoe UI',
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
      ),
      home: MealBridgeMobileHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MealBridgeMobileHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Meal', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Bridge',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9E1B),
              ),
            ),
            SizedBox(width: 8),
            Text('Sri Lanka', style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [IconButton(icon: Icon(Icons.menu), onPressed: () {})],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          MobileHeroSection(),
          SizedBox(height: 20),
          MobileDualPathSection(),
          SizedBox(height: 20),
          MobileFoodListingsSection(),
          SizedBox(height: 20),
          MobileImpactStatsSection(),
          SizedBox(height: 20),
          MobileLeaderboardSection(),
          SizedBox(height: 20),
          MobileFooterSection(),
        ],
      ),
    );
  }
}

// Mobile Hero
class MobileHeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Bridging Food Surplus to Communities in Need',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006622),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'A youth-led initiative connecting excess food from households, bakeries, restaurants, and hotels to individuals and communities across Sri Lanka.',
          style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            MobileCTAButton('I Want to Donate Food', Color(0xFF009933)),
            MobileCTAButton('I Need Food', Color(0xFFFF9E1B)),
            MobileCTAButton('Volunteer with Us', Color(0xFF1A75BB)),
          ],
        ),
      ],
    );
  }
}

class MobileCTAButton extends StatelessWidget {
  final String label;
  final Color color;
  MobileCTAButton(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: () {},
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

// Mobile Dual Path
class MobileDualPathSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Choose Your Path',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006622),
          ),
        ),
        SizedBox(height: 10),
        MobilePathCard(
          title: 'Donate Food',
          description:
              'Share your surplus food directly with low-income families and charitable organizations for free.',
          color: Color(0xFF009933),
          buttonLabel: 'Donate Now',
        ),
        SizedBox(height: 12),
        MobilePathCard(
          title: 'Half-Price Market',
          description:
              'Sell your surplus food at half price to anyone looking for affordable meal options.',
          color: Color(0xFFFF9E1B),
          buttonLabel: 'Browse Half-Price',
        ),
      ],
    );
  }
}

class MobilePathCard extends StatelessWidget {
  final String title, description, buttonLabel;
  final Color color;
  MobilePathCard({
    required this.title,
    required this.description,
    required this.color,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      margin: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        children: [
          Icon(Icons.fastfood, color: color, size: 40),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 7),
          Text(
            description,
            style: TextStyle(fontSize: 13, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color),
            onPressed: () {},
            child: Text(buttonLabel, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Mobile Food Listings
class MobileFoodListingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foodItems = [
      {
        'title': 'Breakfast Bakery Items',
        'location': 'Peradeniya Road, Kandy',
        'availableUntil': '12:00 PM today',
        'serves': '8-10 people',
        'type': 'Free Donation',
        'price': '',
        'color': Color(0xFF009933),
      },
      {
        'title': 'Rice Curry Family Pack',
        'location': 'Dalada Veediya, Kandy',
        'availableUntil': '7:00 PM today',
        'serves': '4 people',
        'type': 'Half Price',
        'price': 'LKR 350',
        'color': Color(0xFFFF9E1B),
      },
      {
        'title': 'Vegetable Selection',
        'location': 'Market Street, Kandy',
        'availableUntil': '4:00 PM today',
        'serves': 'Fresh produce - 5kg',
        'type': 'Free Donation',
        'price': '',
        'color': Color(0xFF009933),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Near Kandy',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006622),
          ),
        ),
        SizedBox(height: 10),
        Column(
          children:
              foodItems.map((item) => MobileFoodCard(item: item)).toList(),
        ),
      ],
    );
  }
}

class MobileFoodCard extends StatelessWidget {
  final Map<String, dynamic> item;
  MobileFoodCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            color: Color(0xFFE0E0E0),
            child: Center(
              child: Icon(Icons.image, size: 48, color: Colors.grey),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['type'] == 'Free Donation')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item['color'],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Free Donation',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (item['type'] == 'Half Price')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item['color'],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${item['price']} Half Price',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                SizedBox(height: 7),
                Text(
                  item['title'],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                SizedBox(height: 7),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF009933), size: 16),
                    SizedBox(width: 5),
                    Text(item['location'], style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Color(0xFF009933), size: 16),
                    SizedBox(width: 5),
                    Text(
                      item['availableUntil'],
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.people, color: Color(0xFF009933), size: 16),
                    SizedBox(width: 5),
                    Text(item['serves'], style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item['color'],
                  ),
                  onPressed: () {},
                  child: Text(
                    item['type'] == 'Half Price' ? 'Purchase' : 'Request Now',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Mobile Impact Stats
class MobileImpactStatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      {'label': 'Meals Shared', 'value': '14,275'},
      {'label': 'Active Donors', 'value': '932'},
      {'label': 'kg of Food Waste Saved', 'value': '2,831'},
      {'label': 'Local Businesses Joined', 'value': '215'},
    ];
    return Column(
      children: [
        Text(
          'Our Impact in Sri Lanka',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006622),
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: stats.map((stat) => MobileStatCard(stat: stat)).toList(),
        ),
      ],
    );
  }
}

class MobileStatCard extends StatelessWidget {
  final Map<String, String> stat;
  MobileStatCard({required this.stat});

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

// Mobile Leaderboard
class MobileLeaderboardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final leaders = [
      {'rank': 1, 'name': 'Janith\'s Bakery, Colombo', 'score': '387 meals'},
      {'rank': 2, 'name': 'Green Haven Hotel, Kandy', 'score': '251 meals'},
      {'rank': 3, 'name': 'Perera Family, Galle', 'score': '178 meals'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Food Heroes This Month',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006622),
          ),
        ),
        SizedBox(height: 10),
        Column(
          children:
              leaders
                  .map((leader) => MobileLeaderItem(leader: leader))
                  .toList(),
        ),
      ],
    );
  }
}

class MobileLeaderItem extends StatelessWidget {
  final Map<String, dynamic> leader;
  MobileLeaderItem({required this.leader});

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

// Mobile Footer
class MobileFooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Meal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Bridge',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9E1B),
              ),
            ),
            SizedBox(width: 6),
            Text('Sri Lanka', style: TextStyle(fontSize: 13)),
          ],
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            MobileFooterLink('About Us'),
            MobileFooterLink('How It Works'),
            MobileFooterLink('Safety Guidelines'),
            MobileFooterLink('Partner With Us'),
            MobileFooterLink('Contact'),
          ],
        ),
        SizedBox(height: 10),
        Text(
          '© 2025 MealBridge Sri Lanka - Connecting Communities Through Food',
          style: TextStyle(fontSize: 11, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class MobileFooterLink extends StatelessWidget {
  final String label;
  MobileFooterLink(this.label);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(label, style: TextStyle(fontSize: 12)),
    );
  }
}
