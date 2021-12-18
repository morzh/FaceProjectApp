import 'dart:io';
import 'dart:typed_data';

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
  final encodedImage = File('').obs;
  final sourceImage = File('').obs;
  late double augmentedEntitiesNumber = 11;

  late List latent;
  late List<dynamic> lighting;
  late Map<int, List> weightsDeltas;
  late Map attributes;
  
  final augmentedFaceImages = <Rx<Image>>[];
  late List<dynamic> augmentedFaceLatents;
  String currentAugmentationType = 'Yaw';
  
  var currentAugmentChoice = ''.obs;
  var currentSliderValue = 0.0.obs;
  var currentFaceIdx = 0.obs;

  setSliderValue() {
    String type = currentAugmentationType;
    final attributeRange = FaceAttributesRanges.max[type]! - FaceAttributesRanges.min[type]!;
    final attributeValueLength = attributes[type] - FaceAttributesRanges.min[type]!;
    currentSliderValue.value =  attributeValueLength / attributeRange;
  }

  updateCurrentState(int numberEntities, int choiceIndex, String augmentationName) {
    if (augmentedFaceImages.isEmpty || augmentedFaceLatents.isEmpty || lighting.isEmpty) { return; }
    final normalizedAttribute = choiceIndex / numberEntities;
    final attributeRange = FaceAttributesRanges.max[augmentationName]! - FaceAttributesRanges.min[augmentationName]!;
    attributes[augmentationName] =  FaceAttributesRanges.min[augmentationName]! + normalizedAttribute * attributeRange;
    encodedImage.value.writeAsBytesSync(augmentedFaceImages[choiceIndex].value.image.toString().codeUnits);
  }

  printEncodedData() {
    print(latent);
    print(attributes);
    print(lighting);
  }
}