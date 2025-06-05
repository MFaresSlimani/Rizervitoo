import 'package:get/get.dart';
import '../core/services/user_service.dart';
import '../models/property_model.dart';

class PropertyController extends GetxController {
  RxList<PropertyModel> properties = RxList<PropertyModel>([]);
  RxList<PropertyModel> filteredProperties = RxList<PropertyModel>([]);
  // saved properties list
  RxList<PropertyModel> savedProperties = RxList<PropertyModel>([]);
  // Changed to a list for current user's properties
  RxList<PropertyModel> currentUserProperties = RxList<PropertyModel>([]);

  void setProperties(List<PropertyModel> newProperties) {
    properties.value = newProperties;
  }
  void setFilteredProperties(List<PropertyModel> newFilteredProperties) {
    filteredProperties.value = newFilteredProperties;
  }
  void clearProperties() {
    properties.value = [];
  }
  void clearFilteredProperties() {
    filteredProperties.value = [];
  }

  // Set all properties owned by the current user
  void setCurrentUserProperties(List<PropertyModel> properties) {
    currentUserProperties.value = properties;
  }
  void clearCurrentUserProperties() {
    currentUserProperties.value = [];
  }
  // Add a property to the current user's properties
  void addCurrentUserProperty(PropertyModel property) {
    currentUserProperties.add(property);
  }

  void setSavedProperties(List<PropertyModel> newSavedProperties) {
    savedProperties.value = newSavedProperties;
  }
  void clearSavedProperties() {
    savedProperties.value = [];
  }
  void addSavedProperty(PropertyModel property){
    UserService().updateSavedProperties(property.id, false);
    savedProperties.add(property);
    print('savedProperties: $savedProperties');
  }
  void removeSavedProperty(PropertyModel property){
    UserService().updateSavedProperties(property.id, true);
    savedProperties.remove(property);
  }
}
