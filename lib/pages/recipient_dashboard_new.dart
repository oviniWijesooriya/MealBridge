import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/mobile_nav_drawer.dart';
import '../main.dart';

class RecipientDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Recipient Dashboard"),
          backgroundColor: Color(0xFF009933),
        ),
        body: Center(child: Text("Please log in to view your dashboard.")),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MealBridgeHeader(isWeb: true, title: "Recipient Dashboard"),
      ),
      endDrawer: MobileNavDrawer(),
      backgroundColor: Color(0xFFF6F8FA),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return Center(child: Text("Profile not found."));
          }
          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
          final name = userData['fullName'] ?? user.email ?? "Recipient";
          final address = userData['address'] ?? "";
          final profilePhotoUrl = userData['profilePhotoUrl'] ?? "";

          return ListView(
            padding: EdgeInsets.all(24),
            children: [
              // Welcome & Profile Section
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage:
                            profilePhotoUrl.isNotEmpty
                                ? NetworkImage(profilePhotoUrl)
                                : null,
                        child:
                            profilePhotoUrl.isEmpty
                                ? Icon(
                                  Icons.person,
                                  size: 36,
                                  color: Color(0xFF009933),
                                )
                                : null,
                        backgroundColor: Color(0xFFE8F5E9),
                      ),
                      SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome, $name!",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF006622),
                              ),
                            ),
                            Text(
                              address,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                // TODO: Profile settings
                              },
                              icon: Icon(Icons.settings, size: 18),
                              label: Text("Profile Settings"),
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xFF009933),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Main Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
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
                      icon: Icon(Icons.fastfood, size: 26),
                      label: Text("Browse Available Food"),
                      onPressed:
                          () => Navigator.pushNamed(
                            context,
                            '/recipient-find-food',
                          ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF9E1B),
                        minimumSize: Size(double.infinity, 54),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.assignment, size: 26),
                      label: Text("My Requests"),
                      onPressed:
                          () => Navigator.pushNamed(
                            context,
                            '/recipient-requests',
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Notifications Panel
              _RecipientNotificationsPanel(userId: user.uid),
              SizedBox(height: 24),
              // My Requests Section
              Text(
                "My Requests",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _RecipientRequestsSection(userId: user.uid),
              SizedBox(height: 24),
              // Community & Impact (optional)
              Card(
                color: Color(0xFFE8F5E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_food_beverage,
                        color: Color(0xFF009933),
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "You’ve received meals through MealBridge. Thank you for being part of our community!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF006622),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RecipientNotificationsPanel extends StatelessWidget {
  final String userId;
  const _RecipientNotificationsPanel({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('notifications')
              .orderBy('createdAt', descending: true)
              .limit(10)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            margin: EdgeInsets.only(top: 18),
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        final notifications = snapshot.data?.docs ?? [];
        return Card(
          margin: EdgeInsets.only(top: 18),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF009933),
                  ),
                ),
                SizedBox(height: 10),
                if (notifications.isEmpty) Text("No notifications yet."),
                ...notifications.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.notifications, color: Color(0xFF009933)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['message'] ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                data['timestamp'] ?? "",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              if (data['action'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(data['action']),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color(0xFF1A75BB),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecipientRequestsSection extends StatelessWidget {
  final String userId;
  const _RecipientRequestsSection({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('requests')
              .where('recipientUid', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final requests = snapshot.data?.docs ?? [];
        if (requests.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text("You have no requests yet."),
          );
        }
        return Column(
          children:
              requests.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Food: ${data['foodType'] ?? ''}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text("Portions: ${data['portions'] ?? ''}"),
                        Text(
                          "Status: ${data['status'] ?? ''}",
                          style: TextStyle(
                            color: _statusColor(data['status']),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (data['pickupAddress'] != null)
                          Text("Pickup: ${data['pickupAddress']}"),
                        if (data['pickupUntil'] != null)
                          Text("Available until: ${data['pickupUntil']}"),
                        if (data['status'] == 'Pending')
                          TextButton(
                            onPressed: () {
                              // TODO: Cancel request logic
                            },
                            child: Text("Cancel Request"),
                          ),
                        if (data['status'] == 'Ready for Pickup')
                          TextButton(
                            onPressed: () {
                              // TODO: Mark as picked up logic
                            },
                            child: Text("Mark as Picked Up"),
                          ),
                        if (data['status'] == 'Picked Up')
                          TextButton(
                            onPressed: () {
                              // TODO: Show feedback modal
                            },
                            child: Text("Give Feedback"),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Accepted':
        return Colors.blue;
      case 'Ready for Pickup':
        return Colors.green;
      case 'Picked Up':
        return Colors.grey;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.black87;
    }
  }
}
