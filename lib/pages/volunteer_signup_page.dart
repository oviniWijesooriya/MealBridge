import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerSignUpPage extends StatefulWidget {
  @override
  State<VolunteerSignUpPage> createState() => _VolunteerSignUpPageState();
}

class _VolunteerSignUpPageState extends State<VolunteerSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? fullName,
      mobile,
      nic,
      email,
      address,
      username,
      password,
      confirmPassword;
  String? modeOfTransport = "Bicycle";
  List<String> preferredAreas = [];
  List<String> preferredTimes = [];
  bool _obscurePassword = true,
      _obscureConfirm = true,
      _isLoading = false,
      _agreed = false;
  String? _errorMessage;
  double _passwordStrength = 0;
  String? profilePhotoUrl;

  final List<String> areaOptions = [
    "Colombo",
    "Kandy",
    "Galle",
    "Jaffna",
    "Kurunegala",
    "Matara",
    "Gampaha",
    "Other",
  ];
  final List<String> timeOptions = [
    "Morning",
    "Afternoon",
    "Evening",
    "Weekends",
  ];
  final List<String> transportOptions = [
    "Bicycle",
    "Motorbike",
    "Car",
    "On Foot",
    "Other",
  ];

  void _checkPasswordStrength(String value) {
    double strength = 0;
    if (value.length >= 8) strength += 0.3;
    if (RegExp(r'[A-Z]').hasMatch(value)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(value)) strength += 0.2;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) strength += 0.3;
    setState(() => _passwordStrength = strength.clamp(0, 1));
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (password != confirmPassword) {
        setState(() {
          _errorMessage = "Passwords do not match.";
          _isLoading = false;
        });
        return;
      }
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'fullName': fullName,
        'mobile': mobile,
        'nic': nic,
        'email': email,
        'address': address,
        'username': username,
        'role': 'volunteer',
        'preferredAreas': preferredAreas,
        'preferredTimes': preferredTimes,
        'modeOfTransport': modeOfTransport,
        'profilePhotoUrl': profilePhotoUrl ?? "",
        'createdAt': FieldValue.serverTimestamp(),
      });
      Navigator.of(context).pushReplacementNamed('/volunteer-welcome');
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = "Registration failed. Please try again.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text("Volunteer Sign Up"),
        backgroundColor: Color(0xFF009933),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.volunteer_activism,
                          size: 36,
                          color: Color(0xFF009933),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Meal",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF009933),
                          ),
                        ),
                        Text(
                          "Bridge",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9E1B),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18),
                    Text(
                      "Become a MealBridge Volunteer",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF006622),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 18),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (v) => fullName = v,
                      validator:
                          (v) => v == null || v.isEmpty ? "Required" : null,
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (v) => mobile = v,
                      validator:
                          (v) => v == null || v.isEmpty ? "Required" : null,
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "NIC",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge),
                      ),
                      onChanged: (v) => nic = v,
                      validator:
                          (v) => v == null || v.isEmpty ? "Required" : null,
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (v) => email = v,
                      validator:
                          (v) => v == null || v.isEmpty ? "Required" : null,
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Address",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.home),
                        hintText: "e.g., 123 Main Street, Colombo",
                      ),
                      onChanged: (v) => address = v,
                      validator:
                          (v) => v == null || v.isEmpty ? "Required" : null,
                    ),
                    SizedBox(height: 14),
                    // Preferred Areas
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Preferred Volunteering Areas",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      child: Wrap(
                        spacing: 8,
                        children:
                            areaOptions.map((area) {
                              final selected = preferredAreas.contains(area);
                              return FilterChip(
                                label: Text(area),
                                selected: selected,
                                onSelected: (val) {
                                  setState(() {
                                    if (val) {
                                      preferredAreas.add(area);
                                    } else {
                                      preferredAreas.remove(area);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: 14),
                    // Preferred Times
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Preferred Volunteering Times",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      child: Wrap(
                        spacing: 8,
                        children:
                            timeOptions.map((time) {
                              final selected = preferredTimes.contains(time);
                              return FilterChip(
                                label: Text(time),
                                selected: selected,
                                onSelected: (val) {
                                  setState(() {
                                    if (val) {
                                      preferredTimes.add(time);
                                    } else {
                                      preferredTimes.remove(time);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                      onChanged: (v) => username = v,
                      validator:
                          (v) => v == null || v.isEmpty ? "Required" : null,
                    ),
                    SizedBox(height: 14),
                    // Mode of Transport
                    DropdownButtonFormField<String>(
                      value: modeOfTransport,
                      decoration: InputDecoration(
                        labelText: "Mode of Transport",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.directions_bike),
                      ),
                      items:
                          transportOptions
                              .map(
                                (t) =>
                                    DropdownMenuItem(value: t, child: Text(t)),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => modeOfTransport = v),
                    ),
                    SizedBox(height: 14),
                    // Password
                    TextFormField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed:
                              () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                        ),
                      ),
                      onChanged: (v) {
                        password = v;
                        _checkPasswordStrength(v);
                      },
                      validator:
                          (v) =>
                              v == null || v.length < 8
                                  ? "At least 8 characters"
                                  : null,
                    ),
                    SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: _passwordStrength,
                      backgroundColor: Colors.grey[300],
                      color:
                          _passwordStrength > 0.7
                              ? Colors.green
                              : (_passwordStrength > 0.4
                                  ? Colors.orange
                                  : Colors.red),
                      minHeight: 5,
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed:
                              () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                        ),
                      ),
                      onChanged: (v) => confirmPassword = v,
                      validator:
                          (v) => v == null || v.isEmpty ? "Required" : null,
                    ),
                    SizedBox(height: 22),
                    // Volunteer Guidelines & Agreement
                    Text(
                      "Volunteer Guidelines & Agreement",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF006622),
                      ),
                    ),
                    SizedBox(height: 8),
                    ...[
                      "Volunteers are the heart of MealBridge, helping ensure safe and timely delivery of food donations.",
                      "Commit to handling all food with care, respect, and hygiene.",
                      "Communicate promptly with donors, recipients, and the MealBridge team.",
                      "Only accept delivery tasks you can complete in the given time window.",
                      "Respect the privacy and dignity of all community members.",
                      "Strictly prohibited: Using your role for personal gain or soliciting payment for deliveries.",
                    ].map(
                      (g) => Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text("• $g", style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    CheckboxListTile(
                      value: _agreed,
                      onChanged: (v) => setState(() => _agreed = v ?? false),
                      title: Text(
                        "I have read, understood, and agree to the MealBridge Volunteer Guidelines.",
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    SizedBox(height: 12),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF009933),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                            _isLoading || !_agreed
                                ? null
                                : () {
                                  if (_formKey.currentState?.validate() ==
                                      true) {
                                    _register();
                                  }
                                },
                        child:
                            _isLoading
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text("Create My Volunteer Account"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
