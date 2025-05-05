import 'package:get/get.dart';

class GuideController extends GetxController {
  // An observable string
  var selectedWilaya = 'Medea'.obs;

  void selectWilaya(String wilaya) {
    selectedWilaya.value = wilaya;
  }
}
