import 'dart:io';
import 'package:get/get.dart';
import 'package:face_project_app/core/services/http_service_ngrok.dart';

class HttpController extends GetxController {
  final BASE_URL = "http://6abe-34-78-52-237.ngrok.io";
  final httpService = HttpServiceNgrok();
  // get httpService => Get.put(HttpServiceNgrok());

  encodeRequest(File image) async {
    httpService.encodeFaceImage(BASE_URL, image);
  }
}