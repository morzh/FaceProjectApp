import 'dart:io';
import 'package:get/get.dart';
import 'package:face_project_app/core/services/http_service_ngrok.dart';

class HttpController extends GetxController {
  final ngrokUrl = "http://5330-34-125-100-12.ngrok.io";
  final httpService = HttpServiceNgrok();
  // get httpService => Get.put(HttpServiceNgrok());

  encodeFaceImage(File image) async {
    return await httpService.encodeFaceImage(ngrokUrl, image);
  }
}