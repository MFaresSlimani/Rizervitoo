import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/guide_place.dart';

class GuideController extends GetxController {
  var wilayas = <GuideWilaya>[].obs;
  var selectedWilaya = RxnString(); // Reactive variable for the selected Wilaya

  @override
  void onInit() {
    super.onInit();
    loadGuideData();
  }

  Future<void> loadGuideData() async {
    final jsonString = await rootBundle.loadString('assets/guide_data.json');
    final jsonList = json.decode(jsonString) as List;
    wilayas.value = jsonList.map((e) => GuideWilaya.fromJson(e)).toList();
  }

  void selectWilaya(String wilaya) {
    selectedWilaya.value = wilaya;
  }
}