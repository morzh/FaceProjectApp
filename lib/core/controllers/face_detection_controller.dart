import 'dart:io';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetectionController extends GetxController {
  final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(mode: FaceDetectorMode.fast));

  Future detectFacesBoxes(File imageFile) async {
    print('face detector started');
    final InputImage mlKitImage = InputImage.fromFile(imageFile);
    final List<Face> detectedFaces = await faceDetector.processImage(mlKitImage);
    print('face detector ended');
    final List<Face> filteredFaces = [];
    for (var face in detectedFaces) {
      if (face.boundingBox.longestSide / face.boundingBox.shortestSide > 2) {
        continue;
      }
      filteredFaces.add(face);
    }
    return filteredFaces;
  }

  Future<bool> isContainFace(imageFile) async {
    final InputImage mlKitImage = InputImage.fromFile(imageFile);
    final List<Face> detectedFaces = await faceDetector.processImage(mlKitImage);
    if(detectedFaces.isNotEmpty){
      return true;
    }  else {
      return false;
    }
  }
}