import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'pages/find_food.dart';
import 'pages/impact.dart';
import 'pages/donor_signup_form.dart';
import 'pages/donor_signup.dart';
import 'widgets/mobile_nav_drawer.dart';
import 'pages/donor_type_selection.dart';
import 'pages/community_agreement.dart';
import 'pages/donor_welcome.dart';
import 'pages/donate_food_form.dart';
import 'pages/login-2.dart';
import 'pages/donor_dashboard.dart';

void main() {
  runApp(kIsWeb ? MealBridgeWebApp() : MealBridgeMobileApp());
}

// Shared green header/navigation bar
class MealBridgeHeader extends StatelessWidget {
  final bool isWeb;
  final String? title;
  const MealBridgeHeader({required this.isWeb, this.title, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isWeb) {
      return Container(
        color: Color(0xFF009933),
        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 40),
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
                _WebNavButton('Home', '/'),
                _WebNavButton('Find Food', '/find-food'),
                _WebNavButton('Donate', '/donate'),
                _WebNavButton('Impact', '/impact'),
                _WebNavButton('Login', '/login'),
              ],
            ),
          ],
        ),
      );
    } else {
      // Mobile: AppBar with right-side hamburger
      return AppBar(
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
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
          ),
        ],
      );
    }
  }
}

class _WebNavButton extends StatelessWidget {
  final String label;
  final String route;
  const _WebNavButton(this.label, this.route, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(route);
      },
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}

// Web app
class MealBridgeWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealBridge Sri Lanka',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/find-food': (context) => FindFoodPage(),
        '/impact': (context) => ImpactPage(),
        '/register': (context) => DonorSignUpFormPage(),
        '/donate': (context) => DonorSignUpPage(),
        '/donor-type-selection': (context) => DonorTypeSelectionPage(),
        '/agreement': (context) => CommunityAgreementPage(),
        '/donor-welcome': (context) => DonorWelcomePage(),
        '/donate-food': (context) => DonateFoodFormPage(),
        '/login': (context) => CommonLoginPage(),
        '/donor-dashboard': (context) => DonorDashboardPage(),
        // '/recipient-dashboard': (context) => RecipientDashboardPage(),
        // '/volunteer-dashboard': (context) => VolunteerDashboardPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Mobile app
class MealBridgeMobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealBridge Sri Lanka',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/find-food': (context) => FindFoodPage(),
        '/donate': (context) => DonorSignUpPage(),
        '/impact': (context) => ImpactPage(),
        '/register': (context) => DonorSignUpFormPage(),
        '/donor-type-selection': (context) => DonorTypeSelectionPage(),
        '/agreement': (context) => CommunityAgreementPage(),
        '/donor-welcome': (context) => DonorWelcomePage(),
        '/donate-food': (context) => DonateFoodFormPage(),
        '/login': (context) => CommonLoginPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MealBridgeHeader(isWeb: kIsWeb),
      ),
      endDrawer: MobileNavDrawer(),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: kIsWeb ? 400 : 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/hero_sri_lanka.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: kIsWeb ? 400 : 200,
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bridging food surplus to communities in need',
                      style: TextStyle(
                        fontSize: kIsWeb ? 32 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: kIsWeb ? 0 : 16,
                      ),
                      child: Text(
                        'A youth-led initiative connecting excess food from households, bakeries, restaurants, and hotels to individuals and communities across Sri Lanka.',
                        style: TextStyle(
                          fontSize: kIsWeb ? 18 : 14,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: kIsWeb ? 40 : 16),
          // Primary Actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 0 : 16),
            child:
                kIsWeb
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ActionButtonWeb(
                          'I want to donate food',
                          Icons.volunteer_activism,
                          Colors.green,
                          '/donate',
                        ),
                        SizedBox(width: 32),
                        _ActionButtonWeb(
                          'I need food',
                          Icons.restaurant_menu,
                          Colors.orange,
                          '/find-food',
                        ),
                        SizedBox(width: 32),
                        _ActionButtonWeb(
                          'Volunteer with us',
                          Icons.group,
                          Colors.blue,
                          '/impact',
                        ),
                      ],
                    )
                    : Column(
                      children: [
                        _ActionButtonMobile(
                          'I want to donate food',
                          Icons.volunteer_activism,
                          Colors.green,
                          '/donate',
                        ),
                        SizedBox(height: 12),
                        _ActionButtonMobile(
                          'I need food',
                          Icons.restaurant_menu,
                          Colors.orange,
                          '/find-food',
                        ),
                        SizedBox(height: 12),
                        _ActionButtonMobile(
                          'Volunteer with us',
                          Icons.group,
                          Colors.blue,
                          '/impact',
                        ),
                      ],
                    ),
          ),
          SizedBox(height: kIsWeb ? 60 : 28),
          // Impact Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 80 : 16),
            child:
                kIsWeb
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ImpactStat('Meals Shared', '14,275'),
                        _ImpactStat('Active Donors', '932'),
                        _ImpactStat('kg of Food Waste Saved', '2,831'),
                        _ImpactStat('Local Businesses Joined', '215'),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ImpactStat('Meals Shared', '14,275'),
                        _ImpactStat('Active Donors', '932'),
                      ],
                    ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ActionButtonWeb extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String route;
  const _ActionButtonWeb(
    this.label,
    this.icon,
    this.color,
    this.route, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(route);
      },
      icon: Icon(icon, size: 32, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}

class _ActionButtonMobile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String route;
  const _ActionButtonMobile(
    this.label,
    this.icon,
    this.color,
    this.route, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(route);
      },
      icon: Icon(icon, size: 24, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  final String label;
  final String value;
  const _ImpactStat(this.label, this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A75BB),
          ),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 16, color: Color(0xFF666666))),
      ],
    );
  }
}
