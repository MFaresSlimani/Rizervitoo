import 'dart:io';
import 'package:Rizervitoo/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Rizervitoo/core/services/property_service.dart';

import '../../models/property_model.dart';

class AddPropertyScreen extends StatefulWidget {
  final String selectedWilaya;
  final PropertyModel? property; // <-- Add this

  const AddPropertyScreen(
      {super.key, this.selectedWilaya = 'Algiers', this.property});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.property != null) {
      final p = widget.property!;
      titleController.text = p.title;
      priceController.text = p.price.toString();
      descriptionController.text = p.description;
      distanceController.text = p.distanceToLandmark?.toString() ?? '';
      typeController.text = p.type;
      landmarkController.text = p.landmark;
      selectedWilaya = widget.property!.wilaya;
    } else {
      selectedWilaya = widget.selectedWilaya;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final distanceController = TextEditingController();
  final typeController = TextEditingController();
  final landmarkController = TextEditingController();
  final userController = Get.find<UserController>();
  final List<String> wilayas = [
    'Medea',
    'Algiers',
    'Oran',
    'Bejaia',
    'Tlemcen',
    'Tipaza',
    'Constantine',
    'Annaba',
    'Setif',
    'Batna',
    'Blida',
    'Biskra',
    'Tizi Ouzou',
    'Ouargla',
    'Skikda',
    'El Oued',
    'Tiaret',
    'Mostaganem',
    'Sidi Bel Abbes',
    'Guelma',
    'Relizane',
    'Khenchela',
    'Tissemsilt',
    'Laghouat',
    'Bordj Bou Arreridj',
    'El Tarf',
    'Souk Ahras',
    'Mila',
    'Djelfa',
    'Ain Defla',
    'Tebessa',
    'Tamanrasset',
    'Ghardaia',
    'Adrar',
    'Bechar',
    'El Bayadh',
    'Illizi',
    'Tindouf',
    'Naama',
    'Ouled Djellal',
    'Bouira',
    'Ain Temouchent',
    'Tissemsilt',
    'Bordj Baji Mokhtar',
    'Timimoun',
    'In Salah',
    'In Guezzam',
    'Djanet',
    'El Meghaier',
  ];
  final List<String> types = [
    'Apartment',
    'House',
    'Villa',
    'Hotel',
    'Motel',
    'Chalet',
    'Studio'
  ];

  final propertyService = PropertyService();
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  late String selectedWilaya;
  bool _isLoading = false;
  double _progress = 0.0;
  String _progressMessage = '';

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 70);
    setState(() {
      _images.addAll(picked.map((x) => File(x.path)));
    });
  }

  void _removeImage(int idx) {
    setState(() {
      _images.removeAt(idx);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        (_images.isEmpty && widget.property == null)) {
      Get.snackbar('Missing Info', 'Please fill all fields and select images.',
          backgroundColor: Colors.red.shade100, colorText: Colors.black);
      return;
    }
    setState(() {
      _isLoading = true;
      _progress = 0.0;
      _progressMessage = widget.property == null
          ? 'creating_property'.tr
          : 'updating_property'.tr;
    });

    String? propertyId = widget.property?.id;
    if (widget.property == null) {
      setState(() {
        _progress = 0.2;
        _progressMessage = 'Creating property...';
      });

      // 1. Create property with empty imageUrls to get the ID
      String? propertyId2 = await propertyService.createProperty(
        title: titleController.text,
        imageUrls: [],
        owner : userController.user.value!.id,
        price: double.parse(priceController.text),
        type: typeController.text,
        landmark: landmarkController.text,
        wilaya: selectedWilaya,
        description: descriptionController.text,
        distanceToLandmark: distanceController.text.isNotEmpty
            ? double.parse(distanceController.text)
            : null,
      );

      if (propertyId2 == null) {
        setState(() {
          _isLoading = false;
          _progressMessage = 'Failed to create property';
        });
        return;
      }

      setState(() {
        _progress = 0.5;
        _progressMessage = 'Uploading images...';
      });

      // 2. Upload images with the new propertyId
      final imageUrls =
          await propertyService.uploadPropertyImages(propertyId2, _images);

      setState(() {
        _progress = 0.8;
        _progressMessage = 'Updating property with images...';
      });

      // 3. Update property with image URLs
      await propertyService.updatePropertyImages(propertyId2, imageUrls);
    } else {
      // Edit
      await propertyService.updateProperty(
        propertyId: propertyId!,
        title: titleController.text,
        price: double.parse(priceController.text),
        type: typeController.text,
        landmark: landmarkController.text,
        wilaya: selectedWilaya,
        description: descriptionController.text,
        distanceToLandmark: double.parse(distanceController.text),
      );
    }

    setState(() {
      _progress = 1.0;
      _progressMessage = 'Finalizing...';
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => _isLoading = false);
    Get.back();
    Get.snackbar(
        'success'.tr,
        widget.property == null
            ? 'property_created_successfully'.tr
            : 'property_updated_successfully'.tr);
  }

  Widget _sectionTitle(String text, {IconData? icon}) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 6),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  size: 22),
            if (icon != null) const SizedBox(width: 8),
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.property != null;
    return Scaffold(
      appBar: AppBar(title: Text('add_property'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEdit) ...[
                _sectionTitle('property_images'.tr, icon: Icons.photo_library),
                Text(
                  'add_high_quality_images_to_attract_more_guests_you_can_select_multiple_images'
                      .tr,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ..._images.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final file = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  file,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(idx),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close,
                                        color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add_a_photo, size: 32),
                                SizedBox(height: 6),
                                Text('Add', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_images.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'at_least_one_image_required'.tr,
                      style: TextStyle(color: Colors.red[400], fontSize: 13),
                    ),
                  ),
                const Divider(height: 32, thickness: 1.2),
              ],
              _sectionTitle('basic_information'.tr, icon: Icons.info_outline),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'title'.tr,
                  hintText: 'e.g. Cozy Apartment in Downtown',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'enter_a_title'.tr : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: typeController.text.isEmpty ? null : typeController.text,
                items: types
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    typeController.text = value;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'property_type'.tr,
                  prefixIcon: Icon(Icons.home_work_outlined),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'select_a_type'.tr : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'price'.tr,
                  hintText: 'e.g. 5000',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'enter_a_price'.tr : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedWilaya,
                items: wilayas
                    .map((w) => DropdownMenuItem(value: w, child: Text(w)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedWilaya = value;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'wilaya'.tr,
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),
              const Divider(height: 32, thickness: 1.2),
              _sectionTitle('description'.tr, icon: Icons.description),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'description'.tr,
                  hintText: 'describe_your_property'.tr,
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const Divider(height: 32, thickness: 1.2),
              _sectionTitle('landmark_distance'.tr, icon: Icons.place),
              Text(
                'here_you_can_add_a_landmark_near_your_property_to_help_guests_find_it_more_easily'
                    .tr,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: landmarkController,
                decoration: InputDecoration(
                  labelText: 'landmark'.tr,
                  hintText: 'e.g. Grand Mosque',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a landmark' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: distanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'distance_to_landmark'.tr,
                  hintText: 'e.g. 1.5',
                  prefixIcon: Icon(Icons.directions_walk),
                ),
              ),
              const SizedBox(height: 28),
              if (_isLoading)
                Column(
                  children: [
                    LinearProgressIndicator(value: _progress),
                    const SizedBox(height: 12),
                    Text(_progressMessage,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 24),
                  ],
                ),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    icon: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.add_business, color: Colors.white),
                    label: Text(
                      'add_property'.tr,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _isLoading ? null : _submit,
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
