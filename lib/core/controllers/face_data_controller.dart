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
  final latentEncoded = Rx<List<double>>([]);
  final latentAugmented = Rx<List<double>>([]);
  final faceLighting = Rx<List<double>>([]);
  late Map faceAttributesMap;
  
  final augmentedFaces = <Rx<AssetImage>>[];
  final augmentedFaceImages = <Rx<Image>>[];
  final augmentedFaceLatents = <Rx<List<double>>>[];
  
  var currentAugmentChoice = ''.obs;
  var currentSliderValue = 0.0.obs;
  var currentFaceIdx = 0.obs;

  readAugmentedImages(String filepath, double imagesNumber) {
    for(int idx = 0; idx < imagesNumber; ++idx) {
      augmentedFaces.add(AssetImage(filepath + idx.toString() + '.jpg').obs);
    }
  }

  updateCurrentState(int numberEntities, int choiceIndex, String augmentationName) {
    if (augmentedFaceImages.isEmpty || augmentedFaceLatents.isEmpty || faceLighting.value.isEmpty) { return; }
    final normalizedAttribute = choiceIndex / numberEntities;
    final attributeRange = FaceAttributesRanges.max[augmentationName]! - FaceAttributesRanges.min[augmentationName]!;
    faceAttributesMap[augmentationName] =  FaceAttributesRanges.min[augmentationName]! + normalizedAttribute * attributeRange;
    encodedImage.obs.value = augmentedFacesImages.obs[choiceIndex];
  }

  printEncodedData() {
    print(latentEncoded.value);
    print(faceAttributesMap);
    print(faceLighting.value);
  }
}