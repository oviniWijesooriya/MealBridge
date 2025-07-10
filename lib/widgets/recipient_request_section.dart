import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyRequestsSection extends StatelessWidget {
  final String userId;
  const MyRequestsSection({required this.userId});

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
