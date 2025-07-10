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
                        .doc(FirebaseAuth.instance.currentUser!.uid)
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
                                        _MainActionButtons(user: user),
                                        const SizedBox(height: 22),
                                        RecipientRequestsSection(
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
                                  _MainActionButtons(user: user),
                                  const SizedBox(height: 22),
                                  _RecipientNotificationsPanel(
                                    userId: user.uid,
                                  ),
                                  const SizedBox(height: 22),
                                  RecipientRequestsSection(userId: user.uid),
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
  final User user;
  const _MainActionButtons({required this.user});

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
              elevation: 2,
            ),
            icon: Icon(Icons.fastfood, size: 26),
            label: Text("Browse Available Food"),
            onPressed:
                () => Navigator.pushReplacementNamed(
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
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            icon: Icon(Icons.assignment, size: 26),
            label: Text("My Requests"),
            onPressed: () {
              // Optionally, scroll to MyRequestsSection or navigate to a separate page
            },
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
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('requests')
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

class RecipientRequestsSection extends StatelessWidget {
  final String userId;
  const RecipientRequestsSection({required this.userId});

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

        // Split into current and past requests
        final current =
            requests.where((doc) {
              final status = (doc['status'] ?? '').toString().toLowerCase();
              return status == 'pending' ||
                  status == 'accepted' ||
                  status == 'ready for pickup';
            }).toList();

        final past =
            requests.where((doc) {
              final status = (doc['status'] ?? '').toString().toLowerCase();
              return status == 'picked up' ||
                  status == 'completed' ||
                  status == 'cancelled';
            }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (current.isNotEmpty) ...[
              Text(
                "Current Requests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...current.map((doc) => _RequestCard(doc: doc)).toList(),
              SizedBox(height: 24),
            ],
            if (past.isNotEmpty) ...[
              Text(
                "Past Requests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...past
                  .map((doc) => _RequestCard(doc: doc, isPast: true))
                  .toList(),
            ],
          ],
        );
      },
    );
  }
}

class _RequestCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final bool isPast;
  const _RequestCard({required this.doc, this.isPast = false});

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final status = (data['status'] ?? '').toString();
    final foodName = data['foodType'] ?? '';
    final portions = data['portions'] ?? '';
    final pickupAddress = data['pickupAddress'] ?? '';
    final pickupUntil = data['pickupUntil'] ?? '';
    final createdAt =
        data['createdAt'] is Timestamp
            ? (data['createdAt'] as Timestamp).toDate()
            : null;
    final imageUrl = data['imageUrl'] ?? '';
    final canCancel = status.toLowerCase() == 'pending';
    final canMarkPickedUp = status.toLowerCase() == 'ready for pickup';
    final canFeedback =
        status.toLowerCase() == 'picked up' ||
        status.toLowerCase() == 'completed';

    return Card(
      margin: EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stack) => Container(
                        height: 90,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.fastfood,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                ),
              ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.fastfood, color: Color(0xFF009933)),
                SizedBox(width: 6),
                Text(
                  foodName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Spacer(),
                _StatusChip(status: status),
              ],
            ),
            SizedBox(height: 4),
            Text("Portions: $portions"),
            if (pickupAddress.isNotEmpty) Text("Pickup: $pickupAddress"),
            if (pickupUntil.isNotEmpty) Text("Available until: $pickupUntil"),
            if (createdAt != null)
              Text(
                "Requested: ${_formatDate(createdAt)}",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            SizedBox(height: 6),
            Row(
              children: [
                if (canCancel)
                  TextButton(
                    onPressed: () {
                      // TODO: Cancel request logic
                    },
                    child: Text("Cancel Request"),
                  ),
                if (canMarkPickedUp)
                  TextButton(
                    onPressed: () {
                      // TODO: Mark as picked up logic
                    },
                    child: Text("Mark as Picked Up"),
                  ),
                if (canFeedback)
                  TextButton(
                    onPressed: () {
                      // TODO: Show feedback modal
                    },
                    child: Text("Give Feedback"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'accepted':
        color = Colors.blue;
        break;
      case 'ready for pickup':
        color = Colors.green;
        break;
      case 'picked up':
      case 'completed':
        color = Colors.grey;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.black54;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
