import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/mobile_nav_drawer.dart';
import '../main.dart';

class RecipientRegisterPage extends StatefulWidget {
  @override
  State<RecipientRegisterPage> createState() => _RecipientRegisterPageState();
}

class _RecipientRegisterPageState extends State<RecipientRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String? fullName, mobile, address, username, password, confirmPassword;
  bool _obscurePassword = true,
      _obscureConfirm = true,
      _isLoading = false,
      _agreed = false;
  String? _errorMessage;
  double _passwordStrength = 0;

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
        email: "$username@gmail.com", // Use username as email for demo
        password: password!,
      );
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'fullName': fullName,
        'mobile': mobile,
        'address': address,
        'username': username,
        'role': 'recipient',
        'createdAt': FieldValue.serverTimestamp(),
      });
      Navigator.of(context).pushReplacementNamed('/recipient-dashboard');
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MealBridgeHeader(isWeb: true),
      ),
      endDrawer: MobileNavDrawer(),
      backgroundColor: Color(0xFFF6F8FA),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 440),
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
                          Icons.restaurant,
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
                      "Sign Up for MealBridge Assistance",
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
                    Text(
                      "Community Guidelines for Recipients",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF006622),
                      ),
                    ),
                    SizedBox(height: 8),
                    ...[
                      "All food shared through MealBridge is a donation from generous individuals, families, and businesses.",
                      "As a recipient, please be ethical when requesting, consuming, and giving feedback on donated food.",
                      "Take personal responsibility for checking the quality and suitability of the food you receive.",
                      "Only request what you genuinely need, so everyone in the community can benefit.",
                      "Provide honest and respectful feedback to help donors and the platform improve.",
                      "Understand that MealBridge and donors cannot guarantee the suitability of every item; always use your own judgment before consuming.",
                    ].map(
                      (g) => Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text("• $g", style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4, top: 4),
                      child: Text(
                        "Strictly Prohibited: Selling or reselling any food received through MealBridge is not allowed. Any attempt to sell donated food is a violation of our community trust and will result in consequences, including possible removal from the platform.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      value: _agreed,
                      onChanged: (v) => setState(() => _agreed = v ?? false),
                      title: Text(
                        "I have read, understood, and agree to the MealBridge Community Guidelines for recipients.",
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
                                : Text("Create My Account"),
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
