import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../main.dart'; // For MealBridgeHeader
import '../widgets/mobile_nav_drawer.dart';

class DonorTypeSelectionPage extends StatefulWidget {
  @override
  State<DonorTypeSelectionPage> createState() => _DonorTypeSelectionPageState();
}

class _DonorTypeSelectionPageState extends State<DonorTypeSelectionPage> {
  int? selectedIndex;

  final List<_DonorTypeCardData> donorTypes = [
    _DonorTypeCardData(
      icon: Icons.restaurant,
      title: 'Restaurant/Hotel',
      description: "Share your kitchen's daily surplus with the community",
      example: "Perfect for buffet leftovers, excess preparations",
    ),
    _DonorTypeCardData(
      icon: Icons.bakery_dining,
      title: 'Bakery',
      description: "Give old baked goods a second chance to bring joy",
      example: "Ideal for bread, pastries, cakes nearing expiry",
    ),
    _DonorTypeCardData(
      icon: Icons.shopping_cart,
      title: 'Groceries & Supermarkets',
      description: "Help communities access fresh produce and pantry staples",
      example: "Great for near-expiry fruits, vegetables, packaged items",
    ),
    _DonorTypeCardData(
      icon: Icons.home,
      title: 'Home Kitchen',
      description: "Turn your family's extra portions into community blessings",
      example: "Great for party leftovers, bulk cooking surplus",
    ),
    _DonorTypeCardData(
      icon: Icons.celebration,
      title: 'Special Occasions/Other',
      description: "Transform celebration abundance into lasting impact",
      example: "Weddings, almsgivings, corporate events",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? _DonorTypeSelectionWeb(
          donorTypes: donorTypes,
          selectedIndex: selectedIndex,
          onSelect: (i) => setState(() => selectedIndex = i),
          onNext:
              selectedIndex != null
                  ? () {
                    Navigator.of(context).pushReplacementNamed(
                      '/register',
                      arguments: {
                        'type': donorTypes[selectedIndex!].title,
                        'icon': donorTypes[selectedIndex!].icon,
                      },
                    );
                  }
                  : null,
        )
        : _DonorTypeSelectionMobile(
          donorTypes: donorTypes,
          selectedIndex: selectedIndex,
          onSelect: (i) => setState(() => selectedIndex = i),
          onNext:
              selectedIndex != null
                  ? () {
                    Navigator.of(context).pushReplacementNamed(
                      '/register',
                      arguments: {
                        'type': donorTypes[selectedIndex!].title,
                        'icon': donorTypes[selectedIndex!].icon,
                      },
                    );
                  }
                  : null,
        );
  }
}

class _DonorTypeCardData {
  final IconData icon;
  final String title;
  final String description;
  final String example;

  _DonorTypeCardData({
    required this.icon,
    required this.title,
    required this.description,
    required this.example,
  });
}

// WEB VERSION
class _DonorTypeSelectionWeb extends StatelessWidget {
  final List<_DonorTypeCardData> donorTypes;
  final int? selectedIndex;
  final void Function(int) onSelect;
  final VoidCallback? onNext;

  const _DonorTypeSelectionWeb({
    required this.donorTypes,
    required this.selectedIndex,
    required this.onSelect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MealBridgeHeader(isWeb: true),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1100),
            padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "How would you like to make a difference?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006622),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Select the option that best describes you or your organization.",
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 3;
                    if (constraints.maxWidth < 900) crossAxisCount = 2;
                    if (constraints.maxWidth < 600) crossAxisCount = 1;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: donorTypes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 32,
                        crossAxisSpacing: 32,
                        childAspectRatio: 1.4, // Wider, less tall cards
                      ),
                      itemBuilder:
                          (context, i) => _DonorTypeCard(
                            data: donorTypes[i],
                            isSelected: selectedIndex == i,
                            onTap: () => onSelect(i),
                            width: double.infinity,
                          ),
                    );
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedIndex != null ? Color(0xFF009933) : Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: onNext,
                  child: Text("Next", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// MOBILE VERSION
class _DonorTypeSelectionMobile extends StatelessWidget {
  final List<_DonorTypeCardData> donorTypes;
  final int? selectedIndex;
  final void Function(int) onSelect;
  final VoidCallback? onNext;

  const _DonorTypeSelectionMobile({
    required this.donorTypes,
    required this.selectedIndex,
    required this.onSelect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MealBridgeHeader(isWeb: false),
      ),
      endDrawer: MobileNavDrawer(),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: [
          SizedBox(height: 10),
          Text(
            "How would you like to make a difference?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            "Select the option that best describes you or your organization.",
            style: TextStyle(fontSize: 15, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ...List.generate(
            donorTypes.length,
            (i) => Padding(
              padding: EdgeInsets.only(bottom: 18),
              child: _DonorTypeCard(
                data: donorTypes[i],
                isSelected: selectedIndex == i,
                onTap: () => onSelect(i),
                width: double.infinity,
              ),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedIndex != null ? Color(0xFF009933) : Colors.grey,
              padding: EdgeInsets.symmetric(vertical: 16),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: onNext,
            child: Text("Next", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Card widget for both web and mobile
class _DonorTypeCard extends StatelessWidget {
  final _DonorTypeCardData data;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;

  const _DonorTypeCard({
    required this.data,
    required this.isSelected,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: width,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color(0xFF009933) : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              data.icon,
              size: 32,
              color: isSelected ? Color(0xFF009933) : Colors.black54,
            ),
            SizedBox(height: 10),
            Text(
              data.title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF009933),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              data.description,
              style: TextStyle(fontSize: 13.5, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            Text(
              data.example,
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
