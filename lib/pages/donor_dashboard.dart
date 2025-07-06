import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../widgets/dashboard_header.dart';

// Demo data
final String donorName = "Sandun Madhushan";
final String donorType = "Bakery";
final String profilePhotoUrl = "";
final int totalMeals = 178;
final List<Map<String, dynamic>> activeDonations = [
  {
    'item': 'Breakfast Bakery Items',
    'quantity': '8 packs',
    'expiry': '2025-07-10',
    'status': 'Awaiting Pickup',
    'id': 1,
  },
  {
    'item': 'Vegetable Selection',
    'quantity': '5 kg',
    'expiry': '2025-07-08',
    'status': 'Matched with Recipient',
    'id': 2,
  },
];
final List<Map<String, dynamic>> donationHistory = [
  {
    'item': 'Rice Curry Family Pack',
    'date': '2025-07-01',
    'quantity': '4 packs',
    'status': 'Picked Up',
  },
  {
    'item': 'Fruit Basket',
    'date': '2025-06-25',
    'quantity': '10 kg',
    'status': 'Picked Up',
  },
];
final List<Map<String, dynamic>> notifications = [
  {
    'message': 'New request for "Breakfast Bakery Items".',
    'timestamp': '2 min ago',
    'action': 'View Request',
  },
  {
    'message': 'Pickup in progress for "Vegetable Selection".',
    'timestamp': '10 min ago',
    'action': 'Track Pickup',
  },
  {
    'message': 'Food safety reminder: Check expiry dates.',
    'timestamp': 'Today',
    'action': null,
  },
];

class DonorDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA), // Subtle gray for contrast
      appBar: DashboardHeader(role: "Donor", onProfile: () {}, onLogout: () {}),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
            child: _DonorDashboardContent(
              donorName: donorName,
              donorType: donorType,
              profilePhotoUrl: profilePhotoUrl,
              totalMeals: totalMeals,
              activeDonations: activeDonations,
              donationHistory: donationHistory,
              notifications: notifications,
            ),
          ),
        ),
      ),
    );
  }
}

class _DonorDashboardContent extends StatelessWidget {
  final String donorName;
  final String donorType;
  final String profilePhotoUrl;
  final int totalMeals;
  final List<Map<String, dynamic>> activeDonations;
  final List<Map<String, dynamic>> donationHistory;
  final List<Map<String, dynamic>> notifications;

  const _DonorDashboardContent({
    required this.donorName,
    required this.donorType,
    required this.profilePhotoUrl,
    required this.totalMeals,
    required this.activeDonations,
    required this.donationHistory,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile & Stats
        Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 18),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
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
                        donorName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF006622),
                        ),
                      ),
                      Text(
                        donorType,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF009933),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.settings, size: 18),
                        label: const Text("Profile Settings"),
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF009933),
                        ),
                      ),
                    ],
                  ),
                ),
                // Total Meals Donated
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF009933),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Total Meals Donated",
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$totalMeals",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
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
                      "Thank you for sharing your kindness! Every meal you donate helps bridge food surplus to those in need across Sri Lanka.",
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
        // Main Actions & Notifications
        isWide
            ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Actions & Active Donations
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _MainActionButton(),
                      const SizedBox(height: 22),
                      _ActiveDonationsPanel(activeDonations: activeDonations),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                // Notifications
                Expanded(
                  flex: 1,
                  child: _NotificationsPanel(notifications: notifications),
                ),
              ],
            )
            : Column(
              children: [
                _MainActionButton(),
                const SizedBox(height: 22),
                _NotificationsPanel(notifications: notifications),
                const SizedBox(height: 22),
                _ActiveDonationsPanel(activeDonations: activeDonations),
              ],
            ),
        const SizedBox(height: 30),
        // Donation History
        Text(
          "Donation History",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: DataTable(
            columnSpacing: 18,
            columns: const [
              DataColumn(label: Text("Item")),
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Quantity")),
              DataColumn(label: Text("Status")),
            ],
            rows:
                donationHistory
                    .map(
                      (d) => DataRow(
                        cells: [
                          DataCell(Text(d['item'])),
                          DataCell(Text(d['date'])),
                          DataCell(Text(d['quantity'])),
                          DataCell(Text(d['status'])),
                        ],
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}

class _MainActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF009933),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
          textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
        ),
        icon: const Icon(Icons.add_circle, size: 28),
        label: const Text("Make a Donation"),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/donate-food');
        },
      ),
    );
  }
}

class _NotificationsPanel extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;
  const _NotificationsPanel({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF4FFF6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notifications",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF009933),
              ),
            ),
            const SizedBox(height: 10),
            ...notifications.map(
              (n) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.notifications, color: Color(0xFF009933)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n['message'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            n['timestamp'],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          if (n['action'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(n['action']),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveDonationsPanel extends StatelessWidget {
  final List<Map<String, dynamic>> activeDonations;
  const _ActiveDonationsPanel({required this.activeDonations});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF4FFF6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Active Donations",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF009933),
              ),
            ),
            const SizedBox(height: 10),
            ...activeDonations.map(
              (donation) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    donation['item'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantity: ${donation['quantity']}"),
                      Text("Expiry: ${donation['expiry']}"),
                      Text("Status: ${donation['status']}"),
                    ],
                  ),
                  trailing: OutlinedButton(
                    onPressed: () {
                      // TODO: Edit donation
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF009933)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Edit"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
