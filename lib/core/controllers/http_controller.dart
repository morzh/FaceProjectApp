import 'dart:io';
import 'package:get/get.dart';
import 'package:face_project_app/core/services/http_service_ngrok.dart';

class HttpController extends GetxController {
  final ngrokUrl = "http://e9c4-35-197-52-236.ngrok.io";
  final httpService = HttpServiceNgrok();
  // get httpService => Get.put(HttpServiceNgrok());

  encodeFaceImage(File image) async {
    return await httpService.encodeFaceImage(ngrokUrl, image);
  }

  augmentFace(String augmentType, List latent, Map attributes, List lighting) async {
    return await httpService.faceAugmentRequest(ngrokUrl, augmentType, latent, attributes, lighting);
  }
}