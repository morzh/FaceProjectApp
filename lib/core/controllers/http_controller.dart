import 'dart:io';
import 'package:get/get.dart';
import 'package:face_project_app/core/services/http_service_ngrok.dart';

class HttpController extends GetxController {
  final ngrokUrl = "http://f7bf-35-221-3-132.ngrok.io";
  final httpService = HttpServiceNgrok();
  // get httpService => Get.put(HttpServiceNgrok());

  encodeFaceImage(File image) async {
    return await httpService.encodeFaceImage(ngrokUrl, image);
  }

  augmentFace(String augmentType, List latent, Map attributes) async {
    return await httpService.faceAugmentRequest(ngrokUrl, augmentType, latent, attributes);
  }
}