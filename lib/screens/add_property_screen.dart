import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/property_controller.dart';

class AddPropertyScreen extends StatelessWidget {
  final propertyController = Get.find<PropertyController>();

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final imageUrlController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final distanceController = TextEditingController();
  
  final String selectedWilaya; // Default selected wilaya

  final List<String> wilayas = [
    'Medea', 'Algiers', 'Oran', 'Bejaia', 'Tlemcen', 'Tipaza'
  ];

  AddPropertyScreen({super.key, this.selectedWilaya = 'Algiers'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Property')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) => value!.isEmpty ? 'Enter an image URL' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) => value!.isEmpty ? 'Enter a price' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedWilaya,
                items: wilayas.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                onChanged: (value) {
                  if (value != null) {
                    // Handle the change locally or pass it to a callback
                  }
                },
                decoration: const InputDecoration(labelText: 'Wilaya'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: distanceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Distance to Landmark (km)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await propertyController.createProperty(
                      title: titleController.text,
                      imageUrl: imageUrlController.text,
                      price: double.parse(priceController.text),
                      wilaya: selectedWilaya,
                      description: descriptionController.text,
                      distanceToLandmark: distanceController.text.isNotEmpty
                          ? double.parse(distanceController.text)
                          : null,
                    );
                    //don't go back until the property is added
                    Get.back();
                    Get.snackbar('Success', 'Property added successfully');
                  } else {
                    Get.snackbar('Error', 'Please fill all fields correctly');
                    }
                },
                child: const Text('Add Property'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
