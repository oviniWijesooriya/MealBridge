import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../main.dart'; // For MealBridgeHeader
import '../widgets/mobile_nav_drawer.dart';

class DonorSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return kIsWeb ? DonorSignUpWeb() : DonorSignUpMobile();
  }
}

// WEB VERSION
class DonorSignUpWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MealBridgeHeader(isWeb: true),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.volunteer_activism,
                size: 56,
                color: Color(0xFF009933),
              ),
              SizedBox(height: 24),
              Text(
                "Welcome, Generous Food Donor!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006622),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "Are you a returning donor or joining us for the first time?",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF009933),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Icon(Icons.person_add, color: Colors.white),
                      label: Text(
                        "I am a new donor",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed('/donor-type-selection');
                      },
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A75BB),
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Icon(Icons.login, color: Colors.white),
                      label: Text(
                        "I already have an account",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text(
                "Your generosity helps reduce food waste and feed communities across Sri Lanka.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// MOBILE VERSION
class DonorSignUpMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MealBridgeHeader(isWeb: false),
      ),
      endDrawer: MobileNavDrawer(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.volunteer_activism,
                size: 48,
                color: Color(0xFF009933),
              ),
              SizedBox(height: 20),
              Text(
                "Welcome, Generous Food Donor!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006622),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Are you a returning donor or joining us for the first time?",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF009933),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  minimumSize: Size(double.infinity, 0),
                ),
                icon: Icon(Icons.person_add, color: Colors.white),
                label: Text(
                  "I am a new donor",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed('/donor-type-selection');
                },
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A75BB),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  minimumSize: Size(double.infinity, 0),
                ),
                icon: Icon(Icons.login, color: Colors.white),
                label: Text(
                  "I already have an account",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
              SizedBox(height: 24),
              Text(
                "Your generosity helps reduce food waste and feed communities across Sri Lanka.",
                style: TextStyle(fontSize: 13, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
