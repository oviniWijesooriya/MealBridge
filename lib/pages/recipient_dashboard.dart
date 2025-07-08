import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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
  String? _locationError;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _submitLocation() {
    setState(() {
      _enteredLocation = _locationController.text.trim();
      _locationError = null;
    });
  }

  Future<void> _useMyLocation() async {
    setState(() {
      _isLoading = true;
      _locationError = null;
    });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError =
              "Location services are disabled. Please enable them in your device settings.";
          _isLoading = false;
        });
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError =
                "Location permissions are denied. Please allow location access.";
            _isLoading = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError =
              "Location permissions are permanently denied. Please enable them in your browser or device settings.";
          _isLoading = false;
        });
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String? city = placemarks.isNotEmpty ? placemarks[0].locality : null;
      if (city == null || city.isEmpty) {
        setState(() {
          _locationError =
              "Could not determine your city. Please enter it manually.";
          _isLoading = false;
        });
        return;
      }
      setState(() {
        _locationController.text = city;
        _enteredLocation = city;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _locationError = "Failed to get location: $e";
        _isLoading = false;
      });
    }
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
                            onPressed: _isLoading ? null : _useMyLocation,
                          ),
                        ],
                      ),
                      if (_locationError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _locationError!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Expanded(
                child:
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _FoodDonationsList(location: _enteredLocation),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodDonationsList extends StatelessWidget {
  final String? location;
  const _FoodDonationsList({required this.location});

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> stream;
    if (location != null && location!.isNotEmpty) {
      // Filter by city (case-insensitive)
      stream =
          FirebaseFirestore.instance
              .collection('donations')
              .where('status', isEqualTo: 'active')
              .where('city', isEqualTo: location!.toLowerCase())
              .snapshots();
    } else {
      // Show all active donations
      stream =
          FirebaseFirestore.instance
              .collection('donations')
              .where('status', isEqualTo: 'active')
              .snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
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
                        if (data['city'] != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "(${data['city']})",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
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
                        onPressed: () async {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please log in to request food."),
                              ),
                            );
                            return;
                          }
                          final maxPortions =
                              data['servings'] ?? data['quantity'] ?? 1;
                          final pickupAddress = data['pickupAddress'] ?? '';
                          final availableUntil = data['pickupUntil'] ?? '';
                          final donationId = donations[i].id;
                          showDialog(
                            context: context,
                            builder:
                                (context) => RequestFoodDialog(
                                  donationId: donationId,
                                  maxPortions:
                                      maxPortions is int ? maxPortions : 1,
                                  pickupAddress: pickupAddress,
                                  availableUntil: availableUntil,
                                ),
                          );
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

class RequestFoodDialog extends StatefulWidget {
  final String donationId;
  final int maxPortions;
  final String pickupAddress;
  final String availableUntil;
  const RequestFoodDialog({
    required this.donationId,
    required this.maxPortions,
    required this.pickupAddress,
    required this.availableUntil,
    Key? key,
  }) : super(key: key);

  @override
  State<RequestFoodDialog> createState() => _RequestFoodDialogState();
}

class _RequestFoodDialogState extends State<RequestFoodDialog> {
  int portions = 1;
  String pickupMethod = "Direct Pickup";
  String? specialInstructions;
  bool _isLoading = false;
  String? _error;

  Future<void> _submitRequest() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _error = "You must be logged in.");
        return;
      }
      await FirebaseFirestore.instance.collection('requests').add({
        'donationId': widget.donationId,
        'recipientUid': user.uid,
        'portions': portions,
        'pickupMethod': pickupMethod,
        'specialInstructions': specialInstructions,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Request submitted!")));
    } catch (e) {
      setState(() => _error = "Failed to request: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Request This Food Donation"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("How many portions do you need?"),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed:
                      portions > 1 ? () => setState(() => portions--) : null,
                ),
                Text("$portions", style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed:
                      portions < widget.maxPortions
                          ? () => setState(() => portions++)
                          : null,
                ),
              ],
            ),
            SizedBox(height: 12),
            Text("Pickup Method:"),
            RadioListTile(
              value: "Direct Pickup",
              groupValue: pickupMethod,
              onChanged: (v) => setState(() => pickupMethod = v as String),
              title: Text("Direct Pickup"),
            ),
            RadioListTile(
              value: "Volunteer Mediated Pickup",
              groupValue: pickupMethod,
              onChanged: (v) => setState(() => pickupMethod = v as String),
              title: Text("Volunteer Mediated Pickup"),
            ),
            SizedBox(height: 8),
            Text("Pickup Location: ${widget.pickupAddress}"),
            Text("Available until: ${widget.availableUntil}"),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(labelText: "Special Instructions"),
              onChanged: (v) => specialInstructions = v,
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_error!, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitRequest,
          child:
              _isLoading
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Text("Confirm Request"),
        ),
      ],
    );
  }
}
