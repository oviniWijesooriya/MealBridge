import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/mobile_nav_drawer.dart';

class RecipientFindFoodPage extends StatefulWidget {
  @override
  State<RecipientFindFoodPage> createState() => _RecipientFindFoodPageState();
}

class _RecipientFindFoodPageState extends State<RecipientFindFoodPage> {
  final _locationController = TextEditingController();
  String? _enteredLocation;
  bool _isLoading = false;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _submitLocation() {
    setState(() {
      _enteredLocation = _locationController.text.trim();
    });
    // Optionally trigger a geocoding lookup or update food list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MealBridgeHeader(isWeb: true),
      ),
      endDrawer: MobileNavDrawer(),
      backgroundColor: Color(0xFFF6F8FA),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 700),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Text(
                "Welcome! Find a Meal Near You",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006622),
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 18),
              // Location entry
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: "Enter your city, town, or landmark",
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Color(0xFF009933),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onFieldSubmitted: (_) => _submitLocation(),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF009933),
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(Icons.search, color: Colors.white),
                              label: Text(
                                "Find Food",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: _submitLocation,
                            ),
                          ),
                          SizedBox(width: 10),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Color(0xFF009933)),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: Icon(
                              Icons.my_location,
                              color: Color(0xFF009933),
                            ),
                            label: Text(
                              "Use My Location",
                              style: TextStyle(color: Color(0xFF009933)),
                            ),
                            onPressed: () {
                              // TODO: Implement geolocation
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Food Listings
              Expanded(
                child:
                    _enteredLocation == null
                        ? Center(
                          child: Text(
                            "Enter your location to see available food donations near you.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        : _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _FoodDonationsList(location: _enteredLocation!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodDonationsList extends StatelessWidget {
  final String location;
  const _FoodDonationsList({required this.location});

  @override
  Widget build(BuildContext context) {
    // In a real app, you would use location to filter/sort donations by distance.
    // Here, we show all active donations for demo.
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('donations')
              .where('status', isEqualTo: 'active')
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final donations = snapshot.data?.docs ?? [];
        if (donations.isEmpty) {
          return Center(child: Text("No food donations available right now."));
        }
        return ListView.builder(
          itemCount: donations.length,
          itemBuilder: (context, i) {
            final data = donations[i].data() as Map<String, dynamic>;
            return Card(
              margin: EdgeInsets.only(bottom: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data['imageUrl'] != null && data['imageUrl'] != "")
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          data['imageUrl'],
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.fastfood, color: Color(0xFF009933)),
                        SizedBox(width: 8),
                        Text(
                          data['foodType'] ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF006622),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      data['description'] ?? "",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        if (data['servings'] != null)
                          Text(
                            "Servings: ${data['servings']}",
                            style: TextStyle(fontSize: 15),
                          ),
                        if (data['quantity'] != null &&
                            data['quantityUnit'] != null)
                          Text(
                            "Quantity: ${data['quantity']} ${data['quantityUnit']}",
                            style: TextStyle(fontSize: 15),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Color(0xFF009933),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Best Before: ${data['expiryDate'] != null ? (data['expiryDate'] as Timestamp).toDate().toString().split(' ')[0] : 'N/A'}",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 18,
                          color: Color(0xFF009933),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Available until: ${data['pickupUntil'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 18,
                          color: Color(0xFF009933),
                        ),
                        SizedBox(width: 4),
                        Text(
                          data['pickupAddress'] ?? '',
                          style: TextStyle(fontSize: 15),
                        ),
                        // TODO: Show distance if available
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF009933),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Show request modal
                        },
                        child: Text("Request Food"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
