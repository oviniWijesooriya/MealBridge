import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget implements PreferredSizeWidget {
  final String role; // "Donor", "Recipient", "Volunteer"
  final VoidCallback? onProfile;
  final VoidCallback? onLogout;

  const DashboardHeader({
    required this.role,
    this.onProfile,
    this.onLogout,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF009933), // Your homepage green
      elevation: 2,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Image.asset(
          'assets/mealbridge_logo.png', // Replace with your logo asset path
          height: 34,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        "$role Dashboard",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(Icons.settings, color: Colors.white),
          tooltip: "Profile Settings",
          onPressed: onProfile,
        ),
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          tooltip: "Logout",
          onPressed: onLogout,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
