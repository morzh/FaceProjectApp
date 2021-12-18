import 'dart:io';
import 'dart:typed_data';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FaceAttributesRanges {
  static const Map<String, double> min = {
    'Gender': 0,
    'Glasses': 0,
    'Yaw': -20.0,
    'Pitch': -20.0,
    'Baldness': 0.0,
    'Beard': 0.0,
    'Age': 0,
    'Expression': 0.0
  };

  static const Map<String, double> max = {
    'Gender': 1,
    'Glasses': 1,
    'Yaw': 20.0,
    'Pitch': 20.0,
    'Baldness': 1.0,
    'Beard': 1.0,
    'Age': 65,
    'Expression': 1.0
  };
}


class FaceDataController extends GetxController {
  late final File croppedImage;
  final alignedImage = File('').obs;
  final encodedImage = Image.memory(Uint8List(0)).obs;
  final sourceImage = File('').obs;
  late double augmentedEntitiesNumber = 11;

  late List latent;
  late List<dynamic> lighting;
  late Map<int, List> weightsDeltas;
  late Map attributes;
  
  final augmentedFaceImages = <Rx<Image>>[];
  // final augmentedFaceLatents = <Rx<List>>[];
  late List<dynamic> augmentedFaceLatents = [];
  String currentAugmentationType = 'Yaw';
  
  var currentAugmentChoice = ''.obs;
  var currentSliderValue = 0.0.obs;
  var sliderInitValue = 0.0;
  var currentFaceIdx = 0.obs;

  initSlider() {
    String type = currentAugmentationType;
    final attributeRange = FaceAttributesRanges.max[type]! - FaceAttributesRanges.min[type]!;
    final attributeValueLength = attributes[type] - FaceAttributesRanges.min[type]!;
    sliderInitValue =  attributeValueLength / attributeRange;
    sliderInitValue.clamp(0.0, 1.0);
    currentSliderValue.value = sliderInitValue;
  }

  resetSlider() {
    currentSliderValue.value = sliderInitValue;
  }

  updateCurrentState() async {
    print('updateCurrentState');
    print('currentAugmentationType: $currentAugmentationType');
    if (augmentedFaceImages.isEmpty || augmentedFaceLatents.isEmpty || lighting.isEmpty) { return; }

    double choiceIndex = currentSliderValue.value * (augmentedEntitiesNumber - 1.0);
    print('choiceIndex: ${choiceIndex.round()}');
    final attributeRange = FaceAttributesRanges.max[currentAugmentationType]! - FaceAttributesRanges.min[currentAugmentationType]!;
    print('attributeRange: $attributeRange');
    attributes[currentAugmentationType] =  FaceAttributesRanges.min[currentAugmentationType]! + currentSliderValue.value * attributeRange;
    print('attributes[currentAugmentationType]e: ${attributes[currentAugmentationType]}');
    // final File newCurrentImage = File(encodedImage.value.path);
    encodedImage.value = augmentedFaceImages[choiceIndex.round()].value;
    latent = augmentedFaceLatents[choiceIndex.round()];
    // encodedImage.value = newCurrentImage;
    // print(encodedImage.canUpdate);
  }

  printEncodedData() {
    print(latent);
    print(attributes);
    print(lighting);
  }
}