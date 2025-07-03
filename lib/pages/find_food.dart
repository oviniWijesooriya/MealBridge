import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/mobile_nav_drawer.dart';

class FindFoodPage extends StatelessWidget {
  const FindFoodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? FindFoodWeb() : FindFoodMobile();
  }
}

// ========== WEB VERSION ==========

class FindFoodWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          MealBridgeHeader(isWeb: true),
          Container(
            constraints: BoxConstraints(maxWidth: 1100),
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Food Listings',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006622),
                  ),
                ),
                SizedBox(height: 24),
                Wrap(
                  spacing: 25,
                  runSpacing: 25,
                  children: [
                    FindFoodCardWeb(
                      title: "Rice & Curry Family Pack",
                      location: "Peradeniya Road, Kandy",
                      serves: "4 people",
                      availableUntil: "7:00 PM today",
                      price: "LKR 350",
                      isFree: false,
                    ),
                    FindFoodCardWeb(
                      title: "Bakery Items",
                      location: "Dalada Veediya, Kandy",
                      serves: "8-10 people",
                      availableUntil: "12:00 PM today",
                      price: "",
                      isFree: true,
                    ),
                    FindFoodCardWeb(
                      title: "Vegetable Selection",
                      location: "Market Street, Kandy",
                      serves: "Fresh produce - 5kg",
                      availableUntil: "4:00 PM today",
                      price: "",
                      isFree: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FindFoodCardWeb extends StatelessWidget {
  final String title, location, serves, availableUntil, price;
  final bool isFree;

  const FindFoodCardWeb({
    required this.title,
    required this.location,
    required this.serves,
    required this.availableUntil,
    required this.price,
    required this.isFree,
    Key? key,
  }) : super(key: key);

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
                if (isFree)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xFF009933),
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
                if (!isFree)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF9E1B),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$price Half Price',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF009933), size: 18),
                    SizedBox(width: 5),
                    Text(location),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Color(0xFF009933), size: 18),
                    SizedBox(width: 5),
                    Text(availableUntil),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.people, color: Color(0xFF009933), size: 18),
                    SizedBox(width: 5),
                    Text(serves),
                  ],
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFree ? Color(0xFF009933) : Color(0xFFFF9E1B),
                  ),
                  onPressed: () {},
                  child: Text(isFree ? "Request Now" : "Purchase"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ========== MOBILE VERSION ==========

class FindFoodMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            MealBridgeHeader(isWeb: false),
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
        backgroundColor: Color(0xFF009933),
        automaticallyImplyLeading: false,
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
            'Available Food Listings',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
          ),
          SizedBox(height: 16),
          FindFoodCardMobile(
            title: "Rice & Curry Family Pack",
            location: "Peradeniya Road, Kandy",
            serves: "4 people",
            availableUntil: "7:00 PM today",
            price: "LKR 350",
            isFree: false,
          ),
          FindFoodCardMobile(
            title: "Bakery Items",
            location: "Dalada Veediya, Kandy",
            serves: "8-10 people",
            availableUntil: "12:00 PM today",
            price: "",
            isFree: true,
          ),
          FindFoodCardMobile(
            title: "Vegetable Selection",
            location: "Market Street, Kandy",
            serves: "Fresh produce - 5kg",
            availableUntil: "4:00 PM today",
            price: "",
            isFree: true,
          ),
        ],
      ),
    );
  }
}

class FindFoodCardMobile extends StatelessWidget {
  final String title, location, serves, availableUntil, price;
  final bool isFree;

  const FindFoodCardMobile({
    required this.title,
    required this.location,
    required this.serves,
    required this.availableUntil,
    required this.price,
    required this.isFree,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fastfood,
                  size: 32,
                  color: isFree ? Colors.green : Colors.orange,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isFree)
                  Chip(
                    label: Text("Free"),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  )
                else
                  Chip(
                    label: Text("$price"),
                    backgroundColor: Colors.orange,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(location),
            Text('Serves: $serves'),
            Text('Available until: $availableUntil'),
            SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isFree ? Colors.green : Colors.orange,
              ),
              onPressed: () {},
              child: Text(isFree ? "Request Now" : "Purchase"),
            ),
          ],
        ),
      ),
    );
  }
}
