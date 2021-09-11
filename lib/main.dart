import 'package:face_project_app/core/binding/all_controllers_binding.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'face_choice/face_edit_choice_page.dart';
import 'face_choice/binding/augment_face_binding.dart';
import 'augement_face/augment_face_page.dart';
import 'augement_face/binding/augment_face_binding.dart';
import 'face_detection/face_detection_page.dart';
import 'face_detection/binding/face_detection_page_binding.dart';
import 'media_gallery/binding/media_gallery_page_binding.dart';
import 'media_gallery/view/media_gallery_page.dart';

void main() {
  AllContollersBinding().dependencies();
  runApp(FaceProjectApp());
}

class FaceProjectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Flow App',
      theme: ThemeData.from(colorScheme: ColorScheme.light()),
      darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()),
      themeMode: ThemeMode.system,
      getPages: [
        GetPage(name: "/media_gallery", page: () => MediaGalleryPage(), binding: MediaGalleryPageBinding()),
        GetPage(name: "/face_detection", page: () => FaceDetectionPage(), binding: FaceDetectionBinding()),
        GetPage(name: "/face_edit_choice", page: () => AugmentChoicePage(), binding: AugmentChoiceFaceBinding()),
        GetPage(name: "/face_augmentation", page: () => AugmentFacePage(), binding: AugmentFaceBinding()),
      ],
      initialRoute: "/media_gallery",
    );
  }
}
