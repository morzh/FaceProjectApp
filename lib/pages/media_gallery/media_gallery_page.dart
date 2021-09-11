import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:face_project_app/pages/media_gallery/media_grid.dart';
import 'package:face_project_app/pages/face_detection/face_detection_page.dart';
import 'package:face_project_app/core/controllers/face_data_controller.dart';

class MediaGalleryPage extends StatefulWidget {
  @override
  _MediaGalleryPageState createState() => _MediaGalleryPageState();
}

class _MediaGalleryPageState extends State<MediaGalleryPage> {
  final _faceDataController = Get.find<FaceDataController>();
  var _scrollController = ScrollController();

  var isOpen = false;
  final _imagePicker = ImagePicker();
  late File _image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        body: NestedScrollView(
            controller: _scrollController,
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  toolbarHeight: 25,
                  stretch: true,
                  pinned: false,
                  title: Text("Face Project App"),
                  // floating: true
                ),
              ];
            },
            body: MediaGrid()
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          activeBackgroundColor: theme.backgroundColor,
          backgroundColor: theme.accentColor,
          spaceBetweenChildren: 15,
          children: [
            SpeedDialChild(
                child: const Icon(Icons.insert_photo),
                backgroundColor: theme.accentColor,
                label: "choose image from gallery",
                onTap: () => _getImage(ImageSource.gallery)
            ),
            SpeedDialChild(
                child: const Icon(Icons.camera_alt),
                backgroundColor: theme.accentColor,
                label: "take photo from camera",
                onTap: () => _getImage(ImageSource.camera)
            )
          ],
        )
    );
  }

  Future _getImage(pickerSource) async{
    final pickedFile = await _imagePicker.getImage(source: pickerSource);
    if (pickedFile == null) return;
    _faceDataController.sourceImage.value = File(pickedFile.path);
    final imageFile = File(pickedFile.path);
    setState(() {
      _image = imageFile;
    });
    Get.to(FaceDetectionPage());
  }
}
