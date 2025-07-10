import 'package:flutter/material.dart';

class VolunteerWelcomePage extends StatelessWidget {
  final String? volunteerName;
  const VolunteerWelcomePage({this.volunteerName});

  @override
  Widget build(BuildContext context) {
    final name = volunteerName ?? "Volunteer";
    return Scaffold(
      backgroundColor: Color(0xFFF6F8FA),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.celebration, size: 60, color: Color(0xFFFF9E1B)),
              SizedBox(height: 18),
              Text(
                "Welcome to MealBridge, $name! 🎉",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006622),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14),
              Text(
                "Not everyone has a heart like yours — thank you for choosing to give it through volunteering.",
                style: TextStyle(fontSize: 17, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Card(
                color: Color(0xFFE8F5E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Text(
                        "Your first delivery could help feed a family today!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF006622),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Last month, MealBridge volunteers completed 300 successful deliveries!",
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF009933),
                  minimumSize: Size(double.infinity, 54),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.delivery_dining, size: 26),
                label: Text("View Available Deliveries"),
                onPressed:
                    () => Navigator.pushNamed(context, '/volunteer-deliveries'),
              ),
              SizedBox(height: 14),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF009933), width: 2),
                  minimumSize: Size(double.infinity, 54),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.dashboard, size: 26, color: Color(0xFF009933)),
                label: Text(
                  "Explore My Dashboard",
                  style: TextStyle(color: Color(0xFF009933)),
                ),
                onPressed:
                    () => Navigator.pushNamed(context, '/volunteer-dashboard'),
              ),
              SizedBox(height: 18),
              ExpansionTile(
                title: Text(
                  "Learn How MealBridge Volunteering Works",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF009933),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 6,
                    ),
                    child: Text(
                      "1. What is MealBridge Volunteering?\n"
                      "• Connects donors with surplus food to those in need.\n"
                      "• Volunteers help deliver food safely and efficiently.\n\n"
                      "2. Recipient Choices: Direct Pickup vs. Volunteer-Mediated Pickup\n"
                      "• Recipients can choose direct pickup or volunteer delivery.\n\n"
                      "3. How Volunteer-Mediated Pickup Works\n"
                      "• System notifies volunteers in the area.\n"
                      "• Volunteers accept delivery requests via dashboard.\n"
                      "• Pickup from donor, deliver to recipient, update status.\n\n"
                      "4. Tracking Delivery Status\n"
                      "• Mark as Picked Up, En Route, or Delivered.\n"
                      "• Real-time updates for all parties.\n\n"
                      "5. Volunteer Responsibilities\n"
                      "• Communicate promptly, handle food with care, update status accurately.",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
