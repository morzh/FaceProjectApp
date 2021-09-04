import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'dart:core';

import 'package:path/path.dart';
import 'package:get/state_manager.dart';
import 'package:face_project_app/core/models/face_data.dart';
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
  late FaceAttributes faceAttributes;
  late Map faceAttributesMap;
  Rx<List<File>> augmentedFaces = Rx<List<File>>([]);

  readAugmentedImages(String filepath, double imagesNumber) {
    for(int idx = 0; idx < imagesNumber; ++idx) {
      augmentedFaces.value.add(File(filepath + idx.toString() + '.jpg'));
    }
  }

  updateFaceAttributes(FaceAttributes faceAttributes) {
    this.faceAttributes = faceAttributes;
  }
  updateGender(double gender) {
    faceAttributes.gender = gender;
    update();
  }
  updateAge(double age) {
    faceAttributes.age = age;
    update();
  }
  updateGlasses(double glasses) {
    faceAttributes.glasses = glasses;
    update();
  }
  updatePitch(double pitch) {
    faceAttributes.pitch = pitch;
    update();
  }
  updateYaw(double yaw) {
    faceAttributes.yaw = yaw;
    update();
  }
  updateBeard(double beard) {
    faceAttributes.beard = beard;
    update();
  }
  updateSmile(double smile) {
    faceAttributes.smile = smile;
    update();
  }
  updateBald(double bald) {
    faceAttributes.bald = bald;
    update();
  }

}