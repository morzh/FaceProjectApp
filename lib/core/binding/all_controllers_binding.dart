import 'package:get/get.dart';

import 'package:face_project_app/core/controllers/face_data_controller.dart';
import 'package:face_project_app/core/controllers/face_detection_controller.dart';
import 'package:face_project_app/core/controllers/http_controller.dart';

class AllContollersBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceDataController>(() => FaceDataController());
    Get.lazyPut<FaceDetectionController>(() => FaceDetectionController());
    Get.lazyPut<HttpController>(() => HttpController());
  }

}