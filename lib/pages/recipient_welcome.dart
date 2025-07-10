import 'package:flutter/material.dart';
import '../widgets/mobile_nav_drawer.dart';

class RecipientWelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Green header with logo and navigation bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MealBridgeHeader(isWeb: true),
      ),
      endDrawer: MobileNavDrawer(),
      backgroundColor: const Color(0xFFF6F8FA),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 420),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and icon row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant, size: 44, color: Color(0xFF009933)),
                  SizedBox(width: 10),
                  Text(
                    "Meal",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF009933),
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    "Bridge",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9E1B),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              // Welcome header
              Text(
                "Welcome! Let’s Help You Find a Meal",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006622),
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14),
              // Prompt
              Text(
                "Are you a returning recipient or joining us for the first time?",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 36),
              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF009933),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  icon: Icon(
                    Icons.person_add_alt_1,
                    size: 28,
                    color: Colors.white,
                  ),
                  label: Text(
                    "I am new (Sign Up)",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed:
                      () => Navigator.pushNamed(context, '/recipient-register'),
                ),
              ),
              SizedBox(height: 18),
              // Login Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF009933), width: 2),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: Icon(Icons.login, size: 28, color: Color(0xFF009933)),
                  label: Text(
                    "I already have an account (Login)",
                    style: TextStyle(color: Color(0xFF009933)),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                ),
              ),
              SizedBox(height: 32),
              // Optional friendly illustration or icon
              Icon(
                Icons.emoji_food_beverage,
                size: 60,
                color: Color(0xFFFF9E1B),
              ),
              SizedBox(height: 10),
              Text(
                "MealBridge connects you to real, fresh meals in your community.",
                style: TextStyle(fontSize: 15, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Green header, logo, and navigation bar (reuse from your earlier code)
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
