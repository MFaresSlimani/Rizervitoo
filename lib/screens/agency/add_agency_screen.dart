import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Rizervitoo/controllers/agency_controller.dart';
import 'package:Rizervitoo/controllers/user_controller.dart';
import 'package:Rizervitoo/core/services/agency_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/loading_indicator.dart';

class AddAgencyScreen extends StatefulWidget {
  const AddAgencyScreen({super.key});

  @override
  State<AddAgencyScreen> createState() => _AddAgencyScreenState();
}

class _AddAgencyScreenState extends State<AddAgencyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _pickedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    final fileName = 'agency_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storage = Supabase.instance.client.storage;
    final res = await storage.from('agencies').upload(
          fileName,
          image,
          fileOptions: const FileOptions(upsert: true),
        );
    if (res.isEmpty) return null;
    return storage.from('agencies').getPublicUrl(fileName);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _pickedImage == null) {
      Get.snackbar(
          'Missing Info', 'Please fill all fields and select an image.',
          backgroundColor: Colors.red.shade100, colorText: Colors.black);
      return;
    }
    setState(() => _isLoading = true);

    String? imageUrl;
    try {
      imageUrl = await _uploadImage(_pickedImage!);
      if (imageUrl == null) throw Exception('Image upload failed');
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Failed to upload image.',
          backgroundColor: Colors.red.shade100, colorText: Colors.black);
      return;
    }

    final userId = Get.find<UserController>().user.value?.id;
    if (userId == null) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'User not found.',
          backgroundColor: Colors.red.shade100, colorText: Colors.black);
      return;
    }

    try {
      await AgencyService().addAgency(
        ownerId: userId,
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        description: _descController.text.trim(),
        imageUrl: imageUrl,
        phoneNumber: _phoneController.text.trim(),
      );
      await Get.find<AgencyController>().loadAgencies();
      Get.back();
      Get.snackbar('Success', 'Agency added successfully!',
          backgroundColor: Colors.green.shade100, colorText: Colors.black);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add agency.',
          backgroundColor: Colors.red.shade100, colorText: Colors.black);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Agency')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: _pickedImage == null
                        ? Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add_a_photo,
                                size: 48, color: Colors.grey),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_pickedImage!,
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover),
                          ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Agency Name'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_business),
                      label: const Text('Add Agency'),
                      onPressed: _isLoading ? null : _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) const LoadingIndicator(),
        ],
      ),
    );
  }
}
