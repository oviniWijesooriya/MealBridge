import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/mobile_nav_drawer.dart';

class RecipientDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: DashboardHeader(
          role: "Recipient",
          onProfile: () {},
          onLogout: () {},
        ),
        body: Center(child: Text("Please log in to view your dashboard.")),
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FA),
        appBar: DashboardHeader(
          role: "Recipient",
          onProfile: () {
            // TODO: Profile settings
          },
          onLogout: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
        endDrawer: MobileNavDrawer(),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
              child: StreamBuilder<DocumentSnapshot>(
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
                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final name =
                      userData['fullName'] ?? user.email ?? "Recipient";
                  final address = userData['address'] ?? "";
                  final profilePhotoUrl = userData['profilePhotoUrl'] ?? "";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile & Welcome
                      Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 18),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 24,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundImage:
                                    profilePhotoUrl.isNotEmpty
                                        ? NetworkImage(profilePhotoUrl)
                                        : null,
                                child:
                                    profilePhotoUrl.isEmpty
                                        ? Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Color(0xFF009933),
                                        )
                                        : null,
                                backgroundColor: const Color(0xFFE8F5E9),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Welcome, $name!",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF006622),
                                      ),
                                    ),
                                    Text(
                                      address,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        // TODO: Profile settings
                                      },
                                      icon: const Icon(
                                        Icons.settings,
                                        size: 18,
                                      ),
                                      label: const Text("Profile Settings"),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Color(0xFF009933),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.logout,
                                  color: Color(0xFF009933),
                                ),
                                tooltip: "Logout",
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('/login');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Motivational Message
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Card(
                          color: const Color(0xFFE8F5E9),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.volunteer_activism,
                                  color: Color(0xFF009933),
                                  size: 28,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Here’s how you can access meals today. Thank you for being part of our community!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Main Actions & Notifications + Requests
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 900;
                          return isWide
                              ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        _MainActionButtons(),
                                        const SizedBox(height: 22),
                                        _RecipientRequestsSection(
                                          userId: user.uid,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  Expanded(
                                    flex: 1,
                                    child: _RecipientNotificationsPanel(
                                      userId: user.uid,
                                    ),
                                  ),
                                ],
                              )
                              : Column(
                                children: [
                                  _MainActionButtons(),
                                  const SizedBox(height: 22),
                                  _RecipientNotificationsPanel(
                                    userId: user.uid,
                                  ),
                                  const SizedBox(height: 22),
                                  _RecipientRequestsSection(userId: user.uid),
                                ],
                              );
                        },
                      ),
                      const SizedBox(height: 30),
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
            ),
          ),
        ),
      ),
    );
  }
}

class _MainActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF009933),
              minimumSize: Size(double.infinity, 54),
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(Icons.fastfood, size: 26),
            label: Text("Browse Available Food"),
            onPressed:
                () => Navigator.pushNamed(context, '/recipient-find-food'),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF9E1B),
              minimumSize: Size(double.infinity, 54),
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(Icons.assignment, size: 26),
            label: Text("My Requests"),
            onPressed:
                () => Navigator.pushNamed(context, '/recipient-requests'),
          ),
        ),
      ],
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
