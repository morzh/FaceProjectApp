import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class FaceDataController extends GetxController {
  Rx<File> sourceImage = File('').obs;
  late final File croppedImage;
  Rx<File> alignedImage = File('').obs;
  Rx<File> encodedImage = File('').obs;
  // late final List latentEncoded;
  // late final List latentAugmented;
  final latentEncoded = Rx<List<dynamic>>([]);
  final latentAugmented = Rx<List<dynamic>>([]);
  // late FaceAttributes faceAttributes;
  late Map faceAttributesMap;
  List<Rx<AssetImage>> augmentedFaces = <Rx<AssetImage>>[];
  Rx<String> currrentAugmentChoice = ''.obs;
  var currentSliderValue = 0.0.obs;
  var currentFaceIdx = 0.obs;

  readAugmentedImages(String filepath, double imagesNumber) {
    for(int idx = 0; idx < imagesNumber; ++idx) {
      augmentedFaces.add(AssetImage(filepath + idx.toString() + '.jpg').obs);
    }
  }
}