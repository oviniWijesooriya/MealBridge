import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../widgets/mobile_nav_drawer.dart';

class CommonLoginPage extends StatefulWidget {
  @override
  State<CommonLoginPage> createState() => _CommonLoginPageState();
}

class _CommonLoginPageState extends State<CommonLoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? usernameOrEmail;
  String? password;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _loginError;

  Future<String?> _getUserRoleAndNavigate(String email, String password) async {
    try {
      // Sign in with Firebase Auth
      UserCredential cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Fetch user profile from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(cred.user!.uid)
              .get();

      if (!userDoc.exists) {
        setState(() {
          _loginError = "User profile not found in database.";
        });
        return null;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final role = userData['role'] as String?;
      final name =
          userData['donorName'] ?? userData['username'] ?? userData['email'];

      // Navigate to the correct dashboard based on role
      if (role == 'donor') {
        Navigator.of(
          context,
        ).pushReplacementNamed('/donor-dashboard', arguments: {'name': name});
      } else if (role == 'recipient') {
        Navigator.of(context).pushReplacementNamed(
          '/recipient-dashboard',
          arguments: {'name': name},
        );
      } else if (role == 'volunteer') {
        Navigator.of(context).pushReplacementNamed(
          '/volunteer-dashboard',
          arguments: {'name': name},
        );
      } else {
        setState(() {
          _loginError = "User role not found. Contact support.";
        });
        return null;
      }
      return role;
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loginError = e.message ?? "Login failed.";
      });
      return null;
    } catch (e) {
      setState(() {
        _loginError = "Login failed. Please try again.";
      });
      return null;
    }
  }

  void _login() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() {
      _isLoading = true;
      _loginError = null;
    });

    // Use email for login (if you want to support username, implement lookup)
    final email = usernameOrEmail?.trim();
    final pwd = password?.trim();

    if (email == null || pwd == null) {
      setState(() {
        _loginError = "Please enter your email and password.";
        _isLoading = false;
      });
      return;
    }

    await _getUserRoleAndNavigate(email, pwd);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_person, size: 48, color: Color(0xFF009933)),
              SizedBox(height: 16),
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006622),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email Address",
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => usernameOrEmail = v,
                validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
              ),
              SizedBox(height: 18),
              TextFormField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
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
                validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                  },
                  child: Text("Forgot Password?"),
                ),
              ),
              if (_loginError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _loginError!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 14),
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
                  onPressed: _isLoading ? null : _login,
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
                          : Text("Login"),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/register');
                },
                child: Text(
                  "Not registered yet? Sign Up",
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
