import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../main.dart'; // For MealBridgeHeader
import '../widgets/mobile_nav_drawer.dart';

class DonorSignUpFormPage extends StatefulWidget {
  @override
  State<DonorSignUpFormPage> createState() => _DonorSignUpFormPageState();
}

class _DonorSignUpFormPageState extends State<DonorSignUpFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // All possible fields
  String? organizationName;
  String? businessRegNo;
  String? responsibleName;
  String? position;
  String? mobile;
  String? address;
  String? email;
  String? username;
  String? password;
  String? confirmPassword;
  String? eventName;
  String? eventAddress;

  double passwordStrength = 0;
  String? errorMessage;
  bool isSubmitting = false;

  late String donorType;
  late IconData donorIcon;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      donorType = args['type'] as String? ?? 'Donor';
      donorIcon = args['icon'] as IconData? ?? Icons.volunteer_activism;
    } else {
      donorType = 'Donor';
      donorIcon = Icons.volunteer_activism;
    }
  }

  bool get isBusiness =>
      donorType == 'Restaurant/Hotel' ||
      donorType == 'Bakery' ||
      donorType == 'Groceries & Supermarkets';

  bool get isHousehold => donorType == 'Home Kitchen';

  bool get isSpecialOccasion => donorType == 'Special Occasions/Other';

  void _checkPasswordStrength(String value) {
    double strength = 0;
    if (value.length >= 8) strength += 0.3;
    if (RegExp(r'[A-Z]').hasMatch(value)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(value)) strength += 0.2;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) strength += 0.3;
    setState(() {
      passwordStrength = strength.clamp(0, 1);
    });
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });
    _formKey.currentState!.save();

    String donorName = '';
    if (isBusiness) {
      donorName =
          organizationName?.trim().isNotEmpty == true
              ? organizationName!
              : (responsibleName?.trim().isNotEmpty == true
                  ? responsibleName!
                  : 'Donor');
    } else if (isHousehold) {
      donorName =
          responsibleName?.trim().isNotEmpty == true
              ? responsibleName!
              : 'Donor';
    } else if (isSpecialOccasion) {
      donorName =
          eventName?.trim().isNotEmpty == true
              ? eventName!
              : (responsibleName?.trim().isNotEmpty == true
                  ? responsibleName!
                  : 'Donor');
    } else {
      donorName =
          responsibleName?.trim().isNotEmpty == true
              ? responsibleName!
              : 'Donor';
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'uid': userCredential.user!.uid,
            'role': 'donor',
            'donorType': donorType,
            'organizationName': organizationName,
            'businessRegNo': businessRegNo,
            'responsibleName': responsibleName,
            'position': position,
            'mobile': mobile,
            'address': address,
            'email': email,
            'username': username,
            'eventName': eventName,
            'eventAddress': eventAddress,
            'createdAt': FieldValue.serverTimestamp(),
          });

      Navigator.of(
        context,
      ).pushReplacementNamed('/agreement', arguments: {'donorName': donorName});
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Registration failed. Please try again.";
      });
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    final content = _DonorSignUpFormContent(
      formKey: _formKey,
      donorType: donorType,
      donorIcon: donorIcon,
      isBusiness: isBusiness,
      isHousehold: isHousehold,
      isSpecialOccasion: isSpecialOccasion,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      onPasswordChanged: _checkPasswordStrength,
      passwordStrength: passwordStrength,
      onOrgNameSaved: (v) => organizationName = v,
      onBusinessRegNoSaved: (v) => businessRegNo = v,
      onRespNameSaved: (v) => responsibleName = v,
      onPositionSaved: (v) => position = v,
      onMobileSaved: (v) => mobile = v,
      onAddressSaved: (v) => address = v,
      onEmailSaved: (v) => email = v,
      onUsernameSaved: (v) => username = v,
      onPasswordSaved: (v) => password = v,
      onConfirmPasswordSaved: (v) => confirmPassword = v,
      onEventNameSaved: (v) => eventName = v,
      onEventAddressSaved: (v) => eventAddress = v,
      onSubmit: _onSubmit,
      isSubmitting: isSubmitting,
      errorMessage: errorMessage,
    );

    return isWeb
        ? Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: MealBridgeHeader(isWeb: true),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: content,
              ),
            ),
          ),
        )
        : Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: MealBridgeHeader(isWeb: false),
          ),
          endDrawer: MobileNavDrawer(),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 18),
            child: content,
          ),
        );
  }
}

class _DonorSignUpFormContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String donorType;
  final IconData donorIcon;
  final bool isBusiness;
  final bool isHousehold;
  final bool isSpecialOccasion;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final void Function(String) onPasswordChanged;
  final double passwordStrength;
  final void Function(String?)? onOrgNameSaved;
  final void Function(String?)? onBusinessRegNoSaved;
  final void Function(String?)? onRespNameSaved;
  final void Function(String?)? onPositionSaved;
  final void Function(String?)? onMobileSaved;
  final void Function(String?)? onAddressSaved;
  final void Function(String?)? onEmailSaved;
  final void Function(String?)? onUsernameSaved;
  final void Function(String?)? onPasswordSaved;
  final void Function(String?)? onConfirmPasswordSaved;
  final void Function(String?)? onEventNameSaved;
  final void Function(String?)? onEventAddressSaved;
  final VoidCallback onSubmit;
  final bool isSubmitting;
  final String? errorMessage;

  const _DonorSignUpFormContent({
    required this.formKey,
    required this.donorType,
    required this.donorIcon,
    required this.isBusiness,
    required this.isHousehold,
    required this.isSpecialOccasion,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onPasswordChanged,
    required this.passwordStrength,
    this.onOrgNameSaved,
    this.onBusinessRegNoSaved,
    this.onRespNameSaved,
    this.onPositionSaved,
    this.onMobileSaved,
    this.onAddressSaved,
    this.onEmailSaved,
    this.onUsernameSaved,
    this.onPasswordSaved,
    this.onConfirmPasswordSaved,
    this.onEventNameSaved,
    this.onEventAddressSaved,
    required this.onSubmit,
    required this.isSubmitting,
    required this.errorMessage,
  });

  @override
  State<_DonorSignUpFormContent> createState() =>
      _DonorSignUpFormContentState();
}

class _DonorSignUpFormContentState extends State<_DonorSignUpFormContent> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.donorIcon, size: 34, color: Color(0xFF009933)),
              SizedBox(width: 12),
              Text(
                "Sign up as: ${widget.donorType}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006622),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (widget.isBusiness) ...[
            _buildTextField(
              label: "Name of Organization *",
              hint: "e.g., Sunshine Bakery",
              validator: _requiredValidator,
              onSaved: widget.onOrgNameSaved,
            ),
            SizedBox(height: 14),
            _buildTextField(
              label: "Business Registration Number",
              hint: "Optional",
              validator: null,
              onSaved: widget.onBusinessRegNoSaved,
            ),
            SizedBox(height: 14),
            _buildTextField(
              label: "Responsible Person’s Name *",
              hint: "e.g., Mr. Perera",
              validator: _requiredValidator,
              onSaved: widget.onRespNameSaved,
            ),
            SizedBox(height: 14),
            _buildTextField(
              label: "Position/Role *",
              hint: "e.g., Owner, Manager",
              validator: _requiredValidator,
              onSaved: widget.onPositionSaved,
            ),
            SizedBox(height: 14),
            _buildTextField(
              label: "Mobile Number *",
              hint: "e.g., 07XXXXXXXX",
              keyboardType: TextInputType.phone,
              validator: _requiredValidator,
              onSaved: widget.onMobileSaved,
            ),
            SizedBox(height: 14),
            _buildTextField(
              label: "Business Address *",
              hint: "e.g., 123 Main Street, Kandy",
              validator: _requiredValidator,
              onSaved: widget.onAddressSaved,
            ),
          ] else if (widget.isHousehold) ...[
            _buildTextField(
              label: "Responsible Person’s Name *",
              hint: "e.g., Mrs. Silva",
              validator: _requiredValidator,
              onSaved: widget.onRespNameSaved,
            ),
            SizedBox(height: 14),
            _buildTextField(
              label: "Mobile Number *",
              hint: "e.g., 07XXXXXXXX",
              keyboardType: TextInputType.phone,
              validator: _requiredValidator,
              onSaved: widget.onMobileSaved,
            ),
            SizedBox(height: 14),
            _buildTextField(
              label: "Home Address *",
              hint: "e.g., 456 Lake Road, Colombo",
              validator: _requiredValidator,
              onSaved: widget.onAddressSaved,
            ),
          ] else if (widget.isSpecialOccasion) ...[
            _buildTextField(
              label: "Event/Occasion Name *",
              hint: "e.g., Wedding, Almsgiving",
              validator: _requiredValidator,
              onSaved: widget.onEventNameSaved,
            ),
            SizedBox(height: 14),
            _buildTextField(
              label: "Organizer’s Name *",
              hint: "e.g., Mr. Fernando",
              validator: _requiredValidator,
              onSaved: widget.onRespNameSaved,
            ),
            SizedBox(height: 14),
            _buildTextField(
              label: "Mobile Number *",
              hint: "e.g., 07XXXXXXXX",
              keyboardType: TextInputType.phone,
              validator: _requiredValidator,
              onSaved: widget.onMobileSaved,
            ),
            SizedBox(height: 14),
            _buildTextField(
              label: "Event Address/Location *",
              hint: "e.g., Temple Road, Galle",
              validator: _requiredValidator,
              onSaved: widget.onEventAddressSaved,
            ),
          ],
          if (!widget.isBusiness) SizedBox(height: 14),
          _buildTextField(
            label: "Email Address *",
            hint: "e.g., donor@email.com",
            keyboardType: TextInputType.emailAddress,
            validator: _requiredValidator,
            onSaved: widget.onEmailSaved,
          ),
          SizedBox(height: 14),
          _buildTextField(
            label: "Username *",
            hint: "Choose a username",
            validator: _requiredValidator,
            onSaved: widget.onUsernameSaved,
          ),
          SizedBox(height: 14),
          TextFormField(
            controller: widget.passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: "Password *",
              hintText: "At least 8 characters",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed:
                    () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator:
                (v) =>
                    v == null || v.isEmpty
                        ? "Required"
                        : (v.length < 8
                            ? "Password must be at least 8 characters"
                            : null),
            onChanged: widget.onPasswordChanged,
            onSaved: widget.onPasswordSaved,
          ),
          SizedBox(height: 6),
          LinearProgressIndicator(
            value: widget.passwordStrength,
            backgroundColor: Colors.grey[300],
            color:
                widget.passwordStrength > 0.7
                    ? Colors.green
                    : (widget.passwordStrength > 0.4
                        ? Colors.orange
                        : Colors.red),
            minHeight: 5,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: widget.confirmPasswordController,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              labelText: "Confirm Password *",
              hintText: "Re-enter your password",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed:
                    () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return "Required";
              if (v != widget.passwordController.text)
                return "Passwords do not match";
              return null;
            },
            onSaved: widget.onConfirmPasswordSaved,
          ),
          SizedBox(height: 24),
          if (widget.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                widget.errorMessage!,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF009933),
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: widget.isSubmitting ? null : widget.onSubmit,
              child:
                  widget.isSubmitting
                      ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                      : Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  String? _requiredValidator(String? value) =>
      value == null || value.isEmpty ? "Required" : null;
}
