import 'package:get/get.dart';
import 'package:flutter/material.dart';


import 'core/binding/all_controllers_binding.dart';
import 'pages/face_choice/face_edit_choice_page.dart';
import 'pages/augment_face/augment_face_page.dart';
import 'pages/face_detection/face_detection_page.dart';
import 'pages/media_gallery/media_gallery_page.dart';

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
        GetPage(name: "/pages.media_gallery", page: () => MediaGalleryPage()),
        GetPage(name: "/pages.face_detection", page: () => FaceDetectionPage()),
        GetPage(name: "/face_edit_choice", page: () => AugmentChoicePage()),
        GetPage(name: "/face_augmentation", page: () => AugmentFacePage()),
      ],
      initialRoute: "/pages.media_gallery",
    );
  }
}
