import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../main.dart'; // For MealBridgeHeader
import '../widgets/mobile_nav_drawer.dart';

class CommunityAgreementPage extends StatefulWidget {
  @override
  State<CommunityAgreementPage> createState() => _CommunityAgreementPageState();
}

class _CommunityAgreementPageState extends State<CommunityAgreementPage> {
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    final content = _CommunityAgreementContent(
      agreed: agreed,
      onChanged: (v) => setState(() => agreed = v ?? false), // <-- FIXED
      onProceed:
          agreed
              ? () {
                // TODO: Create account in backend/Firebase
                Navigator.of(context).pushReplacementNamed('/donor-welcome');
              }
              : null,
    );

    return kIsWeb
        ? Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: MealBridgeHeader(isWeb: true),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 540),
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
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
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 14),
            child: content,
          ),
        );
  }
}

class _CommunityAgreementContent extends StatelessWidget {
  final bool agreed;
  final ValueChanged<bool?> onChanged; // <-- FIXED TYPE
  final VoidCallback? onProceed;

  const _CommunityAgreementContent({
    required this.agreed,
    required this.onChanged,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.handshake, size: 48, color: Color(0xFF009933)),
        SizedBox(height: 18),
        Text(
          "Our Shared Promise to the Community 🤝",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006622),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 18),
        _AgreementList(),
        SizedBox(height: 20),
        CheckboxListTile(
          value: agreed,
          onChanged: onChanged,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            "I have read, understood, and agree to uphold the MealBridge Community Agreement.",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: agreed ? Color(0xFF009933) : Colors.grey,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          onPressed: onProceed,
          child: Text(
            "Create My Account",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _AgreementList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "By joining MealBridge, I commit to:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        _AgreementItem("🍽️ Share food prepared and stored with care and love"),
        _AgreementItem("📝 Provide accurate information about my donations"),
        _AgreementItem(
          "🤝 Treat all community members with respect and dignity",
        ),
        _AgreementItem(
          "🌟 Be part of Sri Lanka’s movement against food waste and hunger",
        ),
        SizedBox(height: 16),
        Text(
          "I understand that:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        _AgreementItem(
          "• MealBridge connects donors with recipients but doesn't handle food directly",
        ),
        _AgreementItem(
          "• I’m responsible for food quality and safety until pickup",
        ),
        _AgreementItem(
          "• This platform operates on trust and community spirit",
        ),
        _AgreementItem(
          "• I can pause or stop donations anytime through my dashboard",
        ),
      ],
    );
  }
}

class _AgreementItem extends StatelessWidget {
  final String text;
  const _AgreementItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
