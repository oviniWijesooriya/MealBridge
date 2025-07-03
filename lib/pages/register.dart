import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/mobile_nav_drawer.dart';

// Import MobileNavDrawer if it's in another file, or place it here if needed.

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? RegisterWeb() : RegisterMobile();
  }
}

// =====================
// WEB VERSION
// =====================
class RegisterWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          MealBridgeHeader(isWeb: true), // Use your existing WebHeader widget
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
              child: RegisterFormWeb(),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterFormWeb extends StatefulWidget {
  @override
  State<RegisterFormWeb> createState() => _RegisterFormWebState();
}

class _RegisterFormWebState extends State<RegisterFormWeb> {
  final _formKey = GlobalKey<FormState>();
  String? name, email, password, role;
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Register for MealBridge',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          TextFormField(
            decoration: InputDecoration(labelText: 'Full Name'),
            onSaved: (v) => name = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16),
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
                // TODO: Implement registration logic
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Registered as $role')));
              }
            },
            child: Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text('Already have an account? Login'),
          ),
        ],
      ),
    );
  }
}

// =====================
// MOBILE VERSION
// =====================
class RegisterMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF009933),
        title: Row(
          children: [
            MealBridgeHeader(isWeb: false),
            Text(
              'Meal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Bridge',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9E1B),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Sri Lanka',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
          ),
        ],
      ),
      endDrawer: MobileNavDrawer(),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [RegisterFormMobile()],
      ),
    );
  }
}

class RegisterFormMobile extends StatefulWidget {
  @override
  State<RegisterFormMobile> createState() => _RegisterFormMobileState();
}

class _RegisterFormMobileState extends State<RegisterFormMobile> {
  final _formKey = GlobalKey<FormState>();
  String? name, email, password, role;
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Register for MealBridge',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(labelText: 'Full Name'),
            onSaved: (v) => name = v,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 12),
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
                // TODO: Implement registration logic
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Registered as $role')));
              }
            },
            child: Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text('Already have an account? Login'),
          ),
        ],
      ),
    );
  }
}
