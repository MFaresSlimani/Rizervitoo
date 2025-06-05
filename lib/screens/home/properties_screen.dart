import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Rizervitoo/core/services/property_service.dart';
import '../../controllers/property_controller.dart';
import '../../widgets/property_card.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  final PropertyController propertyController = Get.find<PropertyController>();
  final PropertyService propertyService = PropertyService();

  // Filters (Rx for reactivity in modal)
  final RxString selectedWilaya = ''.obs;
  final RxDouble maxPrice = 100000.0.obs;
  final RxBool showSavedOnly = false.obs;
  final RxString searchTitle = ''.obs;
  final RxString selectedType = ''.obs;

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
    'Studio',
  ];

  late final TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    fetchAll();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<void> fetchAll() async {
    await propertyService.fetchProperties();
    await propertyService.fetchSavedProperties();
  }

  void clearFilters() {
    selectedWilaya.value = '';
    maxPrice.value = 100000;
    showSavedOnly.value = false;
    searchTitle.value = '';
    selectedType.value = '';
    titleController.text = '';
  }

  List get filteredProperties {
    var props = propertyController.properties;
    if (showSavedOnly.value) {
      props = propertyController.savedProperties;
    }
    return props.where((p) {
      final matchesWilaya =
          selectedWilaya.value.isEmpty || p.wilaya == selectedWilaya.value;
      final matchesType =
          selectedType.value.isEmpty || p.type == selectedType.value;
      final matchesPrice = p.price <= maxPrice.value;
      final matchesTitle = searchTitle.value.isEmpty ||
          p.title.toLowerCase().contains(searchTitle.value.toLowerCase());

      return matchesWilaya && matchesPrice && matchesTitle && matchesType;
    }).toList();
  }

  void _showFilterSheet() {
    // Local copies for modal editing
    final RxString tempWilaya = RxString(selectedWilaya.value);
    final RxDouble tempMaxPrice = RxDouble(maxPrice.value);
    final RxBool tempShowSavedOnly = RxBool(showSavedOnly.value);
    final RxString tempSearchTitle = RxString(searchTitle.value);
    final RxString tempSelectedType = RxString(selectedType.value);
    final TextEditingController tempTitleController =
        TextEditingController(text: tempSearchTitle.value);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search by name
                TextField(
                  controller: tempTitleController,
                  decoration: InputDecoration(
                    hintText: 'search_by_name'.tr,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (val) => tempSearchTitle.value = val,
                ),
                const SizedBox(height: 16),
                // Wilaya Dropdown
                Obx(() => DropdownButtonFormField<String>(
                      value: tempWilaya.value.isEmpty ? null : tempWilaya.value,
                        hint: Text(
                        'wilaya'.tr,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        ),
                        ),
                      items: wilayas
                          .map((w) => DropdownMenuItem(
                                value: w,
                                child: Text(w.isEmpty ? 'all'.tr : w),
                              ))
                          .toList(),
                      onChanged: (val) => tempWilaya.value = val ?? '',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                    )),
                const SizedBox(height: 16),
                // Property type chips in a scrollable row
                
                
                
                
                const SizedBox(height: 16),
                // Price slider
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('max_price_per_day'.tr),
                        Slider(
                          value: tempMaxPrice.value,
                          min: 0,
                          max: 100000,
                          divisions: 100,
                          label: '${tempMaxPrice.value.toInt()} DA',
                          onChanged: (v) => tempMaxPrice.value = v,
                        ),
                      ],
                    )),
                const SizedBox(height: 16),
                // Saved Only Toggle
                Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text('show_saved_only'.tr),
                    Switch(
                      value: tempShowSavedOnly.value,
                      onChanged: (v) => tempShowSavedOnly.value = v,
                    ),
                    ],
                  )),
                const SizedBox(height: 16),
                Row(
                  children: [
                  Expanded(
                    child: OutlinedButton(
                    onPressed: () {
                      tempWilaya.value = '';
                      tempMaxPrice.value = 100000;
                      tempShowSavedOnly.value = false;
                      tempSearchTitle.value = '';
                      tempSelectedType.value = '';
                      tempTitleController.text = '';
                    },
                    child: Text('clear'.tr),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                    onPressed: () {
                      // Apply filters to main state
                      selectedWilaya.value = tempWilaya.value;
                      maxPrice.value = tempMaxPrice.value;
                      showSavedOnly.value = tempShowSavedOnly.value;
                      searchTitle.value = tempSearchTitle.value;
                      titleController.text = tempTitleController.text;
                      Navigator.pop(context);
                    },
                    child: Text('apply'.tr),
                    ),
                  ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchAll,
        child: 
        Column(
          children: [
            Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      
                      child: Row(
                        spacing: 8,
                        children: types.map((type) {
                          return ChoiceChip(
                            label: Text(type.tr),
                            selected: selectedType.value == type,
                            onSelected: (selected) {
                              selectedType.value =
                                  selected ? type : '';
                            },
                          );
                        }).toList(),
                      ),
                    )),
            Expanded(
              child: Obx(() {
                final props = filteredProperties;
                if (props.isEmpty) {
                  return Center(child: Text('no_properties_found'.tr));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: props.length,
                  itemBuilder: (context, index) {
                    final property = props[index];
                    return PropertyCard(property: property);
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showFilterSheet,
        icon: const Icon(Icons.filter_alt),
        label: Text('filter'.tr),
      ),
    );
  }
}
