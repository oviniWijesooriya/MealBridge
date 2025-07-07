import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../widgets/mobile_nav_drawer.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String? email, password, confirmPassword, username, donorName;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;

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

      // Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      // Optionally store extra user info in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'username': username,
            'donorName': donorName,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });

      // Navigate to next onboarding step
      Navigator.of(context).pushReplacementNamed(
        '/agreement',
        arguments: {'donorName': donorName ?? username ?? email},
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Registration failed. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 420),
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Icon(Icons.person_add, size: 48, color: Color(0xFF009933)),
              SizedBox(height: 16),
              Text(
                "Register",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006622),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(labelText: "Donor Name"),
                onChanged: (v) => donorName = v,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: "Username"),
                onChanged: (v) => username = v,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => email = v,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
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
                onChanged: (v) => password = v,
                validator:
                    (v) =>
                        v == null || v.length < 8
                            ? "At least 8 characters"
                            : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed:
                        () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                onChanged: (v) => confirmPassword = v,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 18),
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
                  ),
                  onPressed:
                      _isLoading
                          ? null
                          : () {
                            if (_formKey.currentState?.validate() == true) {
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
                          : Text("Register"),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(
                    color: Color(0xFF1A75BB),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return kIsWeb
        ? Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: MealBridgeHeader(isWeb: true),
          ),
          body: content,
        )
        : Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: MealBridgeHeader(isWeb: false),
          ),
          endDrawer: MobileNavDrawer(),
          body: content,
        );
  }
}
