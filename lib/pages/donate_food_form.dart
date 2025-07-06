import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/mobile_nav_drawer.dart';

class DonateFoodFormPage extends StatefulWidget {
  @override
  State<DonateFoodFormPage> createState() => _DonateFoodFormPageState();
}

class _DonateFoodFormPageState extends State<DonateFoodFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? foodType;
  String? customFoodType;
  String? description;
  int? servings;
  double? quantity;
  String? quantityUnit = 'kg';
  DateTime? expiryDate;
  String? pickupAddress = '123 Main Street, Kandy'; // Example: auto-filled
  TimeOfDay? pickupUntil;
  // For image upload, you can use a File/ImagePicker in a real app.
  // For now, just simulate with a placeholder.
  bool checklist1 = false;
  bool checklist2 = false;
  bool checklist3 = false;
  bool get allChecklist => checklist1 && checklist2 && checklist3;

  bool get isMeal => foodType == 'Cooked Meal' || foodType == 'Bakery';

  bool get isProduce => foodType == 'Fruits' || foodType == 'Vegetables';

  List<String> foodTypes = [
    'Cooked Meal',
    'Bakery',
    'Fruits',
    'Vegetables',
    'Other',
  ];

  List<String> quantityUnits = [
    'kg',
    'grams',
    'pieces',
    'bunches',
    'packs',
    'litres',
  ];

  @override
  Widget build(BuildContext context) {
    final content = _DonateFoodFormContent(
      formKey: _formKey,
      foodType: foodType,
      customFoodType: customFoodType,
      foodTypes: foodTypes,
      onFoodTypeChanged:
          (val) => setState(() {
            foodType = val;
            if (val != 'Other') customFoodType = null;
          }),
      onCustomFoodTypeChanged: (val) => setState(() => customFoodType = val),
      description: description,
      onDescriptionChanged: (val) => setState(() => description = val),
      servings: servings,
      onServingsChanged: (val) => setState(() => servings = val),
      quantity: quantity,
      onQuantityChanged: (val) => setState(() => quantity = val),
      quantityUnit: quantityUnit,
      quantityUnits: quantityUnits,
      onQuantityUnitChanged: (val) => setState(() => quantityUnit = val),
      expiryDate: expiryDate,
      onExpiryDateChanged: (val) => setState(() => expiryDate = val),
      pickupAddress: pickupAddress,
      onPickupAddressChanged: (val) => setState(() => pickupAddress = val),
      pickupUntil: pickupUntil,
      onPickupUntilChanged: (val) => setState(() => pickupUntil = val),
      checklist1: checklist1,
      checklist2: checklist2,
      checklist3: checklist3,
      onChecklist1Changed: (v) => setState(() => checklist1 = v ?? false),
      onChecklist2Changed: (v) => setState(() => checklist2 = v ?? false),
      onChecklist3Changed: (v) => setState(() => checklist3 = v ?? false),
      allChecklist: allChecklist,
      onPreview: () {
        // Show a preview dialog or page (not implemented here)
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Preview Donation'),
                content: Text('This is a preview of your donation listing.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                ],
              ),
        );
      },
      onPublish:
          allChecklist && _formKey.currentState?.validate() == true
              ? () {
                // TODO: Submit donation to backend
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Donation published!')));
                Navigator.of(context).pop(); // Go back to dashboard or home
              }
              : null,
      isMeal: isMeal,
      isProduce: isProduce,
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
                constraints: BoxConstraints(maxWidth: 520),
                padding: EdgeInsets.symmetric(vertical: 36, horizontal: 22),
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
            padding: EdgeInsets.symmetric(vertical: 22, horizontal: 12),
            child: content,
          ),
        );
  }
}

class _DonateFoodFormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String? foodType;
  final String? customFoodType;
  final List<String> foodTypes;
  final ValueChanged<String?> onFoodTypeChanged;
  final ValueChanged<String?> onCustomFoodTypeChanged;
  final String? description;
  final ValueChanged<String?> onDescriptionChanged;
  final int? servings;
  final ValueChanged<int?> onServingsChanged;
  final double? quantity;
  final ValueChanged<double?> onQuantityChanged;
  final String? quantityUnit;
  final List<String> quantityUnits;
  final ValueChanged<String?> onQuantityUnitChanged;
  final DateTime? expiryDate;
  final ValueChanged<DateTime?> onExpiryDateChanged;
  final String? pickupAddress;
  final ValueChanged<String?> onPickupAddressChanged;
  final TimeOfDay? pickupUntil;
  final ValueChanged<TimeOfDay?> onPickupUntilChanged;
  final bool checklist1;
  final bool checklist2;
  final bool checklist3;
  final ValueChanged<bool?> onChecklist1Changed;
  final ValueChanged<bool?> onChecklist2Changed;
  final ValueChanged<bool?> onChecklist3Changed;
  final bool allChecklist;
  final VoidCallback onPreview;
  final VoidCallback? onPublish;
  final bool isMeal;
  final bool isProduce;

  const _DonateFoodFormContent({
    required this.formKey,
    required this.foodType,
    required this.customFoodType,
    required this.foodTypes,
    required this.onFoodTypeChanged,
    required this.onCustomFoodTypeChanged,
    required this.description,
    required this.onDescriptionChanged,
    required this.servings,
    required this.onServingsChanged,
    required this.quantity,
    required this.onQuantityChanged,
    required this.quantityUnit,
    required this.quantityUnits,
    required this.onQuantityUnitChanged,
    required this.expiryDate,
    required this.onExpiryDateChanged,
    required this.pickupAddress,
    required this.onPickupAddressChanged,
    required this.pickupUntil,
    required this.onPickupUntilChanged,
    required this.checklist1,
    required this.checklist2,
    required this.checklist3,
    required this.onChecklist1Changed,
    required this.onChecklist2Changed,
    required this.onChecklist3Changed,
    required this.allChecklist,
    required this.onPreview,
    required this.onPublish,
    required this.isMeal,
    required this.isProduce,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Donate Surplus Food',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006622),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Food Type *'),
            value: foodType,
            items:
                foodTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
            onChanged: onFoodTypeChanged,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          if (foodType == 'Other')
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Custom Food Type *'),
                onChanged: onCustomFoodTypeChanged,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
            ),
          SizedBox(height: 14),
          TextFormField(
            decoration: InputDecoration(labelText: 'Food Description *'),
            maxLines: 2,
            onChanged: onDescriptionChanged,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 14),
          if (isMeal)
            TextFormField(
              decoration: InputDecoration(
                labelText: 'How many people can this serve? *',
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) => onServingsChanged(int.tryParse(v)),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
          if (isProduce)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Total Quantity *'),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (v) => onQuantityChanged(double.tryParse(v)),
                    validator:
                        (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Unit'),
                    value: quantityUnit,
                    items:
                        quantityUnits
                            .map(
                              (u) => DropdownMenuItem(value: u, child: Text(u)),
                            )
                            .toList(),
                    onChanged: onQuantityUnitChanged,
                  ),
                ),
              ],
            ),
          SizedBox(height: 14),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Best Before / Expiry Date *',
            ),
            readOnly: true,
            controller: TextEditingController(
              text:
                  expiryDate == null
                      ? ''
                      : "${expiryDate!.year}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}",
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: expiryDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 30)),
              );
              if (picked != null) onExpiryDateChanged(picked);
            },
            validator: (v) => (expiryDate == null) ? 'Required' : null,
          ),
          SizedBox(height: 14),
          TextFormField(
            decoration: InputDecoration(labelText: 'Pickup Location *'),
            initialValue: pickupAddress,
            onChanged: onPickupAddressChanged,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 14),
          TextFormField(
            decoration: InputDecoration(labelText: 'Pickup available until *'),
            readOnly: true,
            controller: TextEditingController(
              text: pickupUntil == null ? '' : pickupUntil!.format(context),
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) onPickupUntilChanged(picked);
            },
            validator: (v) => (pickupUntil == null) ? 'Required' : null,
          ),
          SizedBox(height: 14),
          // Food Image Upload (placeholder)
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement image picker
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Image picker not implemented')),
              );
            },
            icon: Icon(Icons.photo_camera),
            label: Text('Upload Food Image (optional)'),
          ),
          SizedBox(height: 18),
          Text(
            'Food Safety & Hygiene Checklist',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          CheckboxListTile(
            value: checklist1,
            onChanged: onChecklist1Changed,
            title: Text('Is within its best before/expiry date.'),
          ),
          CheckboxListTile(
            value: checklist2,
            onChanged: onChecklist2Changed,
            title: Text('Has been handled and stored hygienically.'),
          ),
          CheckboxListTile(
            value: checklist3,
            onChanged: onChecklist3Changed,
            title: Text('I have provided accurate information about the food.'),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onPreview,
                  child: Text('Preview'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (onPublish != null) ? Color(0xFF009933) : Colors.grey,
                  ),
                  onPressed: onPublish,
                  child: Text('Publish Donation'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
