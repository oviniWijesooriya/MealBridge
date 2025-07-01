import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? LoginWeb() : LoginMobile();
  }
}

// =====================
// WEB VERSION
// =====================
class LoginWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          WebHeader(),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 400),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              margin: EdgeInsets.only(top: 60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
              ),
              child: LoginFormWeb(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginFormWeb extends StatefulWidget {
  @override
  State<LoginFormWeb> createState() => _LoginFormWebState();
}

class _LoginFormWebState extends State<LoginFormWeb> {
  final _formKey = GlobalKey<FormState>();
  String? email, password, role;
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Login to MealBridge',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Role'),
            value: role,
            items: [
              DropdownMenuItem(child: Text('Donor'), value: 'Donor'),
              DropdownMenuItem(child: Text('Recipient'), value: 'Recipient'),
              DropdownMenuItem(child: Text('Volunteer'), value: 'Volunteer'),
            ],
            onChanged: (v) => setState(() => role = v),
            validator: (v) => v == null ? 'Please select a role' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            onSaved: (v) => email = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            obscureText: _obscure,
            onSaved: (v) => password = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF009933),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // TODO: Implement authentication logic
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Logged in as $role')));
              }
            },
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {
              // TODO: Implement registration navigation
            },
            child: Text('Don\'t have an account? Register'),
          ),
        ],
      ),
    );
  }
}

// =====================
// MOBILE VERSION
// =====================
class LoginMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF009933),
        title: Row(
          children: [
            Text('Meal', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Bridge',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9E1B),
              ),
            ),
            SizedBox(width: 8),
            Text('Sri Lanka', style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [IconButton(icon: Icon(Icons.menu), onPressed: () {})],
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [LoginFormMobile()],
      ),
    );
  }
}

class LoginFormMobile extends StatefulWidget {
  @override
  State<LoginFormMobile> createState() => _LoginFormMobileState();
}

class _LoginFormMobileState extends State<LoginFormMobile> {
  final _formKey = GlobalKey<FormState>();
  String? email, password, role;
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Login to MealBridge',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Role'),
            value: role,
            items: [
              DropdownMenuItem(child: Text('Donor'), value: 'Donor'),
              DropdownMenuItem(child: Text('Recipient'), value: 'Recipient'),
              DropdownMenuItem(child: Text('Volunteer'), value: 'Volunteer'),
            ],
            onChanged: (v) => setState(() => role = v),
            validator: (v) => v == null ? 'Please select a role' : null,
          ),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            onSaved: (v) => email = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            obscureText: _obscure,
            onSaved: (v) => password = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF009933),
              padding: EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // TODO: Implement authentication logic
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Logged in as $role')));
              }
            },
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {
              // TODO: Implement registration navigation
            },
            child: Text('Don\'t have an account? Register'),
          ),
        ],
      ),
    );
  }
}
