import 'dart:io';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String? pickupAddress = '123 Main Street, Kandy';
  TimeOfDay? pickupUntil;

  XFile? _pickedImage;
  Image? _webImage;
  Uint8List? _webImageBytes;
  final ImagePicker _picker = ImagePicker();

  final expiryDateController = TextEditingController();
  final pickupUntilController = TextEditingController();

  bool checklist1 = false;
  bool checklist2 = false;
  bool checklist3 = false;
  String? errorMessage;

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
  void dispose() {
    expiryDateController.dispose();
    pickupUntilController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      if (kIsWeb) {
        final image = await ImagePickerWeb.getImageAsWidget();
        final bytes = await ImagePickerWeb.getImageAsBytes();
        setState(() {
          _webImage = image;
          _webImageBytes = bytes;
        });
      } else {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile != null) {
          setState(() {
            _pickedImage = pickedFile;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = "Image selection failed: $e";
      });
    }
  }

  Future<String?> _uploadImage() async {
    try {
      final storage = FirebaseStorage.instance;
      String fileName =
          'donations/${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (kIsWeb && _webImageBytes != null) {
        final ref = storage.ref().child(fileName);
        await ref.putData(_webImageBytes!);
        return await ref.getDownloadURL();
      } else if (!kIsWeb && _pickedImage != null) {
        final ref = storage.ref().child(fileName);
        await ref.putFile(File(_pickedImage!.path));
        return await ref.getDownloadURL();
      }
    } catch (e) {
      setState(() {
        errorMessage = "Image upload failed: $e";
      });
    }
    return null;
  }

  Future<void> _onPublish() async {
    setState(() => errorMessage = null);
    if (_formKey.currentState?.validate() != true || !allChecklist) {
      setState(() {
        errorMessage = "Please complete all required fields and checklist.";
      });
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Publishing donation...')));

    String? imageUrl;
    if (_pickedImage != null || _webImageBytes != null) {
      imageUrl = await _uploadImage();
      if (imageUrl == null) {
        setState(() {
          errorMessage = "Failed to upload image.";
        });
        return;
      }
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        errorMessage = "You must be logged in to donate.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to donate.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('donations').add({
        'donorUid': user.uid,
        'foodType': foodType == 'Other' ? customFoodType : foodType,
        'description': description,
        'servings': isMeal ? servings : null,
        'quantity': isProduce ? quantity : null,
        'quantityUnit': isProduce ? quantityUnit : null,
        'expiryDate':
            expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
        'pickupAddress': pickupAddress,
        'pickupUntil':
            pickupUntil != null
                ? '${pickupUntil!.hour.toString().padLeft(2, '0')}:${pickupUntil!.minute.toString().padLeft(2, '0')}'
                : null,
        'imageUrl': imageUrl,
        'checklist1': checklist1,
        'checklist2': checklist2,
        'checklist3': checklist3,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Donation published!')));
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        errorMessage = "Failed to publish donation: $e";
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to publish donation.')));
    }
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Preview Donation'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (kIsWeb && _webImage != null)
                    Container(height: 120, child: _webImage)
                  else if (!kIsWeb && _pickedImage != null)
                    Image.file(File(_pickedImage!.path), height: 120),
                  SizedBox(height: 10),
                  _PreviewRow(
                    label: 'Food Type',
                    value: foodType == 'Other' ? customFoodType : foodType,
                  ),
                  _PreviewRow(label: 'Description', value: description),
                  if (isMeal)
                    _PreviewRow(label: 'Servings', value: servings?.toString()),
                  if (isProduce)
                    _PreviewRow(
                      label: 'Quantity',
                      value:
                          (quantity != null && quantityUnit != null)
                              ? '$quantity $quantityUnit'
                              : null,
                    ),
                  _PreviewRow(
                    label: 'Best Before / Expiry',
                    value:
                        expiryDate != null
                            ? "${expiryDate!.year}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}"
                            : null,
                  ),
                  _PreviewRow(label: 'Pickup Location', value: pickupAddress),
                  _PreviewRow(
                    label: 'Pickup Until',
                    value: pickupUntil?.format(context),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Food Safety & Hygiene:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _PreviewChecklist(
                    'Is within its best before/expiry date.',
                    checklist1,
                  ),
                  _PreviewChecklist(
                    'Has been handled and stored hygienically.',
                    checklist2,
                  ),
                  _PreviewChecklist(
                    'Accurate information provided.',
                    checklist3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  void _updateExpiryDate(DateTime? date) {
    setState(() {
      expiryDate = date;
      expiryDateController.text =
          date == null
              ? ''
              : "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    });
  }

  void _updatePickupUntil(TimeOfDay? time) {
    setState(() {
      pickupUntil = time;
      pickupUntilController.text = time == null ? '' : time.format(context);
    });
  }

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
      onExpiryDateChanged: _updateExpiryDate,
      expiryDateController: expiryDateController,
      pickupAddress: pickupAddress,
      onPickupAddressChanged: (val) => setState(() => pickupAddress = val),
      pickupUntil: pickupUntil,
      onPickupUntilChanged: _updatePickupUntil,
      pickupUntilController: pickupUntilController,
      checklist1: checklist1,
      checklist2: checklist2,
      checklist3: checklist3,
      onChecklist1Changed: (v) => setState(() => checklist1 = v ?? false),
      onChecklist2Changed: (v) => setState(() => checklist2 = v ?? false),
      onChecklist3Changed: (v) => setState(() => checklist3 = v ?? false),
      allChecklist: allChecklist,
      onPreview: _showPreviewDialog,
      onPickImage: _pickImage,
      pickedImage: _pickedImage,
      webImage: _webImage,
      onPublish:
          (allChecklist && _formKey.currentState?.validate() == true)
              ? _onPublish
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
                child: Column(
                  children: [
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    content,
                  ],
                ),
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
            child: Column(
              children: [
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                content,
              ],
            ),
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
  final TextEditingController expiryDateController;
  final String? pickupAddress;
  final ValueChanged<String?> onPickupAddressChanged;
  final TimeOfDay? pickupUntil;
  final ValueChanged<TimeOfDay?> onPickupUntilChanged;
  final TextEditingController pickupUntilController;
  final bool checklist1;
  final bool checklist2;
  final bool checklist3;
  final ValueChanged<bool?> onChecklist1Changed;
  final ValueChanged<bool?> onChecklist2Changed;
  final ValueChanged<bool?> onChecklist3Changed;
  final bool allChecklist;
  final VoidCallback onPreview;
  final VoidCallback? onPublish;
  final VoidCallback onPickImage;
  final XFile? pickedImage;
  final Image? webImage;
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
    required this.expiryDateController,
    required this.pickupAddress,
    required this.onPickupAddressChanged,
    required this.pickupUntil,
    required this.onPickupUntilChanged,
    required this.pickupUntilController,
    required this.checklist1,
    required this.checklist2,
    required this.checklist3,
    required this.onChecklist1Changed,
    required this.onChecklist2Changed,
    required this.onChecklist3Changed,
    required this.allChecklist,
    required this.onPreview,
    required this.onPublish,
    required this.onPickImage,
    required this.pickedImage,
    required this.webImage,
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
            controller: expiryDateController,
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
            controller: pickupUntilController,
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
          OutlinedButton.icon(
            onPressed: onPickImage,
            icon: Icon(Icons.photo_camera),
            label: Text('Upload Food Image (optional)'),
          ),
          SizedBox(height: 10),
          if (kIsWeb)
            (webImage != null)
                ? Container(height: 120, child: webImage)
                : Text('No image selected.'),
          if (!kIsWeb)
            (pickedImage != null)
                ? Image.file(File(pickedImage!.path), height: 120)
                : Text('No image selected.'),
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

class _PreviewRow extends StatelessWidget {
  final String label;
  final String? value;
  const _PreviewRow({required this.label, this.value});
  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value!)),
        ],
      ),
    );
  }
}

class _PreviewChecklist extends StatelessWidget {
  final String label;
  final bool checked;
  const _PreviewChecklist(this.label, this.checked);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          checked ? Icons.check_box : Icons.check_box_outline_blank,
          color: checked ? Colors.green : Colors.grey,
          size: 18,
        ),
        SizedBox(width: 6),
        Expanded(child: Text(label)),
      ],
    );
  }
}
