import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
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

  // Simulated backend role lookup (replace with real backend logic)
  Future<String?> _getUserRole(String usernameOrEmail) async {
    // Example logic: you should replace this with your backend/Firebase
    if (usernameOrEmail.toLowerCase().contains('donor')) return 'donor';
    if (usernameOrEmail.toLowerCase().contains('recipient')) return 'recipient';
    if (usernameOrEmail.toLowerCase().contains('volunteer')) return 'volunteer';
    // Default/fallback
    return null;
  }

  void _login() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() {
      _isLoading = true;
      _loginError = null;
    });

    // Simulate authentication delay
    await Future.delayed(Duration(seconds: 1));

    // Simulate role lookup
    final role = await _getUserRole(usernameOrEmail ?? "");
    setState(() => _isLoading = false);

    if (role == 'donor') {
      Navigator.of(context).pushReplacementNamed('/donor-dashboard');
    } else if (role == 'recipient') {
      Navigator.of(context).pushReplacementNamed('/recipient-dashboard');
    } else if (role == 'volunteer') {
      Navigator.of(context).pushReplacementNamed('/volunteer-dashboard');
    } else {
      setState(() => _loginError = "Invalid username or role not found.");
    }
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
                  labelText: "Username or Email Address",
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
