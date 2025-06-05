import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/agency_offer.dart';

class AddAgencyOfferForm extends StatefulWidget {
  final String agencyId;
  final void Function(AgencyOffer) onOfferAdded;
  const AddAgencyOfferForm({super.key, required this.agencyId, required this.onOfferAdded});

  @override
  State<AddAgencyOfferForm> createState() => _AddAgencyOfferFormState();
}

class _AddAgencyOfferFormState extends State<AddAgencyOfferForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _wilayaController = TextEditingController();
  final _descController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _wilayaController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final offer = AgencyOffer(
      id: '',
      agencyId: widget.agencyId,
      title: _titleController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0,
      wilaya: _wilayaController.text.trim(),
      description: _descController.text.trim(),
    );
    widget.onOfferAdded(offer);
    setState(() => _isLoading = false);
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('add_offer'.tr, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'offer_title'.tr),
                validator: (v) => v == null || v.isEmpty ? 'required'.tr : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'offer_price'.tr),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'required'.tr : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _wilayaController,
                decoration: InputDecoration(labelText: 'wilaya'.tr),
                validator: (v) => v == null || v.isEmpty ? 'required'.tr : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'description'.tr),
                minLines: 2,
                maxLines: 4,
                validator: (v) => v == null || v.isEmpty ? 'required'.tr : null,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text('add'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}