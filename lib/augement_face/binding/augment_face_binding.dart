import 'package:get/get.dart';
import 'package:face_project_app/core/controllers/face_data_controller.dart';

class AugmentFaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FaceDataController());
  }
}