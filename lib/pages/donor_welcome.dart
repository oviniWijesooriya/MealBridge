import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../main.dart'; // For MealBridgeHeader
import '../widgets/mobile_nav_drawer.dart';

class DonorWelcomePage extends StatelessWidget {
  // Optionally pass donor name as argument for a personalized welcome
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final donorName = args?['donorName'] ?? 'Donor';

    final content = _DonorWelcomeContent(donorName: donorName);

    return kIsWeb
        ? Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: MealBridgeHeader(isWeb: true),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 540),
                padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                child: content,
              ),
            ),
          ),
        )
        : Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: MealBridgeHeader(isWeb: false),
          ),
          endDrawer: MobileNavDrawer(),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: content,
          ),
        );
  }
}

class _DonorWelcomeContent extends StatelessWidget {
  final String donorName;
  const _DonorWelcomeContent({required this.donorName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.celebration, size: 54, color: Color(0xFF009933)),
        SizedBox(height: 18),
        Text(
          "Welcome to MealBridge, $donorName! 🎉",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006622),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 14),
        Text(
          "Your donation could help feed a family or prevent food from going to waste today!",
          style: TextStyle(fontSize: 16, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF009933),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            minimumSize: Size(double.infinity, 0),
          ),
          icon: Icon(Icons.add_circle, color: Colors.white),
          label: Text(
            "Create My First Donation",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/donate-food');
          },
        ),
        SizedBox(height: 18),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Color(0xFF009933), width: 2),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            minimumSize: Size(double.infinity, 0),
          ),
          icon: Icon(Icons.dashboard, color: Color(0xFF009933)),
          label: Text(
            "Explore My Dashboard",
            style: TextStyle(color: Color(0xFF009933)),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          },
        ),
        SizedBox(height: 14),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/how-it-works');
          },
          child: Text(
            "Learn How MealBridge Works",
            style: TextStyle(fontSize: 15, color: Color(0xFF1A75BB)),
          ),
        ),
      ],
    );
  }
}
