import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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