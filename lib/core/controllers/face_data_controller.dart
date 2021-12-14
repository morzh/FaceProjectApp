import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FaceAttributesRanges {
  static const Map<String, num> min = {
    'Gender': 0,
    'Glasses': 0,
    'Yaw': -20.0,
    'Pitch': -20.0,
    'Baldness': 0.0,
    'Beard': 0.0,
    'Age': 0,
    'Expression': 0.0
  };

  static const Map<String, num> max = {
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
  final latentEncoded = Rx<List<dynamic>>([]);
  final latentAugmented = Rx<List<dynamic>>([]);
  final faceLighting = Rx<List<dynamic>>([]);
  late Map faceAttributesMap;
  List<Rx<AssetImage>> augmentedFaces = <Rx<AssetImage>>[];
  List<Rx<Image>> augmentedFaceImages = <Rx<Image>>[];
  Rx<String> currentAugmentChoice = ''.obs;
  var currentSliderValue = 0.0.obs;
  var currentFaceIdx = 0.obs;

  readAugmentedImages(String filepath, double imagesNumber) {
    for(int idx = 0; idx < imagesNumber; ++idx) {
      augmentedFaces.add(AssetImage(filepath + idx.toString() + '.jpg').obs);
    }
  }

  printEncodedData() {
    print(latentEncoded.value);
    print(faceAttributesMap);
    print(faceLighting.value);
  }
}