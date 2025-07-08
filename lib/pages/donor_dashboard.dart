import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/dashboard_header.dart';

class DonorDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: DashboardHeader(
          role: "Donor",
          onProfile: () {},
          onLogout: () {},
        ),
        body: Center(child: Text("Please log in to view your dashboard.")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: DashboardHeader(role: "Donor", onProfile: () {}, onLogout: () {}),
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
                  return Center(child: Text("User profile not found."));
                }
                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                final donorName =
                    userData['donorName'] ??
                    userData['username'] ??
                    user.email ??
                    "Donor";
                final donorType = userData['donorType'] ?? "Donor";
                final profilePhotoUrl = userData['profilePhotoUrl'] ?? "";
                final int totalMeals = userData['totalMeals'] ?? 0;

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
                    // Main Actions & Notifications + Donations
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('donations')
                              .where('donorUid', isEqualTo: user.uid)
                              .snapshots(),
                      builder: (context, donationSnapshot) {
                        if (donationSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final allDonations = donationSnapshot.data?.docs ?? [];
                        final activeDonations =
                            allDonations
                                .where(
                                  (doc) => (doc['status'] ?? '') != 'Picked Up',
                                )
                                .map(
                                  (doc) => {
                                    'item': doc['foodType'] ?? '',
                                    'quantity':
                                        doc['quantity'] != null &&
                                                doc['quantityUnit'] != null
                                            ? '${doc['quantity']} ${doc['quantityUnit']}'
                                            : (doc['servings'] != null
                                                ? '${doc['servings']} servings'
                                                : ''),
                                    'expiry':
                                        doc['expiryDate'] != null
                                            ? (doc['expiryDate'] as Timestamp)
                                                .toDate()
                                                .toString()
                                                .split(' ')[0]
                                            : '',
                                    'status': doc['status'] ?? '',
                                    'id': doc.id,
                                    'description': doc['description'] ?? '',
                                    'quantityUnit': doc['quantityUnit'],
                                  },
                                )
                                .toList();

                        final donationHistory =
                            allDonations
                                .where(
                                  (doc) => (doc['status'] ?? '') == 'Picked Up',
                                )
                                .map(
                                  (doc) => {
                                    'item': doc['foodType'] ?? '',
                                    'date':
                                        doc['expiryDate'] != null
                                            ? (doc['expiryDate'] as Timestamp)
                                                .toDate()
                                                .toString()
                                                .split(' ')[0]
                                            : '',
                                    'quantity':
                                        doc['quantity'] != null &&
                                                doc['quantityUnit'] != null
                                            ? '${doc['quantity']} ${doc['quantityUnit']}'
                                            : (doc['servings'] != null
                                                ? '${doc['servings']} servings'
                                                : ''),
                                    'status': doc['status'] ?? '',
                                  },
                                )
                                .toList();

                        final notifications =
                            <Map<String, dynamic>>[]; // Placeholder

                        final isWide = MediaQuery.of(context).size.width > 900;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isWide
                                ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          _MainActionButton(),
                                          const SizedBox(height: 22),
                                          _ActiveDonationsPanel(
                                            activeDonations: activeDonations,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 32),
                                    Expanded(
                                      flex: 1,
                                      child: _NotificationsPanel(
                                        notifications: notifications,
                                      ),
                                    ),
                                  ],
                                )
                                : Column(
                                  children: [
                                    _MainActionButton(),
                                    const SizedBox(height: 22),
                                    _NotificationsPanel(
                                      notifications: notifications,
                                    ),
                                    const SizedBox(height: 22),
                                    _ActiveDonationsPanel(
                                      activeDonations: activeDonations,
                                    ),
                                  ],
                                ),
                            const SizedBox(height: 30),
                            Text(
                              "Donation History",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
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
                                              DataCell(Text(d['item'] ?? '')),
                                              DataCell(Text(d['date'] ?? '')),
                                              DataCell(
                                                Text(d['quantity'] ?? ''),
                                              ),
                                              DataCell(Text(d['status'] ?? '')),
                                            ],
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
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
            notifications.isEmpty
                ? Text("No notifications yet.")
                : Column(
                  children:
                      notifications
                          .map(
                            (n) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.notifications,
                                    color: Color(0xFF009933),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            padding: const EdgeInsets.only(
                                              top: 2.0,
                                            ),
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Text(n['action']),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Color(
                                                  0xFF1A75BB,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                ),
          ],
        ),
      ),
    );
  }
}

class EditDonationDialog extends StatefulWidget {
  final String donationId;
  final Map<String, dynamic> initialData;

  const EditDonationDialog({
    required this.donationId,
    required this.initialData,
    Key? key,
  }) : super(key: key);

  @override
  State<EditDonationDialog> createState() => _EditDonationDialogState();
}

class _EditDonationDialogState extends State<EditDonationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController descriptionController;
  late TextEditingController quantityController;
  late TextEditingController expiryController;
  String? status;
  String? quantityUnit;

  static const allowedStatuses = [
    'Awaiting Pickup',
    'Matched with Recipient',
    'Picked Up',
  ];
  static const allowedUnits = [
    'kg',
    'grams',
    'pieces',
    'bunches',
    'packs',
    'litres',
  ];

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(
      text: widget.initialData['description'] ?? '',
    );
    quantityController = TextEditingController(
      text: widget.initialData['quantity']?.toString() ?? '',
    );
    expiryController = TextEditingController(
      text: widget.initialData['expiry'] ?? '',
    );
    // Ensure status and unit are valid for dropdowns
    status =
        allowedStatuses.contains(widget.initialData['status'])
            ? widget.initialData['status']
            : allowedStatuses.first;
    quantityUnit =
        allowedUnits.contains(widget.initialData['quantityUnit'])
            ? widget.initialData['quantityUnit']
            : allowedUnits.first;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    quantityController.dispose();
    expiryController.dispose();
    super.dispose();
  }

  Future<void> _updateDonation() async {
    if (_formKey.currentState?.validate() != true) return;
    try {
      await FirebaseFirestore.instance
          .collection('donations')
          .doc(widget.donationId)
          .update({
            'description': descriptionController.text,
            'quantity': double.tryParse(quantityController.text),
            'quantityUnit': quantityUnit,
            // For expiry, you may want to convert to Timestamp if you use DatePicker
            'status': status,
          });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Donation updated!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Donation'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: quantityUnit,
                items:
                    allowedUnits
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                onChanged: (val) => setState(() => quantityUnit = val),
                decoration: InputDecoration(labelText: 'Unit'),
              ),
              TextFormField(
                controller: expiryController,
                decoration: InputDecoration(labelText: 'Expiry Date'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: status,
                items:
                    allowedStatuses
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                onChanged: (val) => setState(() => status = val),
                decoration: InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(onPressed: _updateDonation, child: Text('Update')),
      ],
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
            activeDonations.isEmpty
                ? Text("No active donations.")
                : Column(
                  children:
                      activeDonations
                          .map(
                            (donation) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  donation['item'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Quantity: ${donation['quantity'] ?? ''}",
                                    ),
                                    Text("Expiry: ${donation['expiry'] ?? ''}"),
                                    Text("Status: ${donation['status'] ?? ''}"),
                                  ],
                                ),
                                trailing: OutlinedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => EditDonationDialog(
                                            donationId: donation['id'],
                                            initialData: donation,
                                          ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFF009933),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Edit"),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
          ],
        ),
      ),
    );
  }
}
