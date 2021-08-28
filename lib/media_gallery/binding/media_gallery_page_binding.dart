import 'package:get/get.dart';
import 'package:face_project_app/core/controllers/face_detection_controller.dart';
import 'package:face_project_app/core/controllers/face_data_controller.dart';

class MediaGalleryPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FaceDetectionController());
    Get.put(FaceDataController());
  }

}