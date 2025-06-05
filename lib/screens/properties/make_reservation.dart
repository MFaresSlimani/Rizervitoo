import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/services/reservation_service.dart';

class MakeReservationScreen extends StatefulWidget {
  final String propertyId;

  const MakeReservationScreen({Key? key, required this.propertyId}) : super(key: key);

  @override
  State<MakeReservationScreen> createState() => _MakeReservationScreenState();
}

class _MakeReservationScreenState extends State<MakeReservationScreen> {
  final ReservationService _reservationService = ReservationService();

  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _infoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _startDate == null || _endDate == null) {
      Get.snackbar('missing_info'.tr, 'fill_all_fields_and_select_dates'.tr,
          backgroundColor: Colors.red.shade100, colorText: Colors.black);
      return;
    }
    setState(() => _isLoading = true);

    // Check property availability
    final available = await _reservationService.isPropertyAvailable(
      widget.propertyId,
      DateFormat('yyyy-MM-dd').format(_startDate!),
      DateFormat('yyyy-MM-dd').format(_endDate!),
    );
    if (!available) {
      setState(() => _isLoading = false);
      Get.snackbar('unavailable'.tr, 'property_not_available'.tr,
          backgroundColor: Colors.orange.shade100, colorText: Colors.black);
      return;
    }

    final reservation = await _reservationService.createReservation(
      propertyId: widget.propertyId,
      startDate: DateFormat('yyyy-MM-dd').format(_startDate!),
      endDate: DateFormat('yyyy-MM-dd').format(_endDate!),
      additionalInfo: _infoController.text.trim().isEmpty ? null : _infoController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (reservation != null) {
      Get.snackbar('success'.tr, 'reservation_request_sent'.tr,
          backgroundColor: Colors.green.shade100, colorText: Colors.black);
      Navigator.of(context).pop(true);
    } else {
      Get.snackbar('error'.tr, 'failed_to_make_reservation'.tr,
          backgroundColor: Colors.red.shade100, colorText: Colors.black);
    }
  }

  @override
  void dispose() {
    _infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('make_reservation'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'choose_stay_dates'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _pickDateRange,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: theme.primaryColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _startDate == null || _endDate == null
                                      ? 'select_date_range'.tr
                                      : '${DateFormat('dd MMM yyyy').format(_startDate!)} - ${DateFormat('dd MMM yyyy').format(_endDate!)}',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: _startDate == null ? Colors.grey : theme.primaryColor,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _infoController,
                        minLines: 2,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'additional_info_optional'.tr,
                          prefixIcon: const Icon(Icons.info_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: theme.primaryColor.withOpacity(0.04),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withOpacity(0.85),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.send_rounded, size: 24),
                  label: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          'send_reservation_request'.tr,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                  onPressed: _isLoading ? null : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}