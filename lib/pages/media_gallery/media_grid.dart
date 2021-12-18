import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:face_project_app/pages/face_detection/face_detection_page.dart';
import 'package:face_project_app/core/controllers/face_data_controller.dart';
import 'package:face_project_app/core/controllers/face_detection_controller.dart';

class MediaGrid extends StatefulWidget {
  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  final _faceDataController = Get.find<FaceDataController>();
  final _faceDetectionController = Get.find<FaceDetectionController>();

  List<Widget> _mediaList = [];
  int currentPage = 0;
  int lastPage = 0;
  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  Future<void> _showInfo(AssetEntity entity) async {
    if (entity.type == AssetType.video) {
      var file = await entity.file;
      if (file == null) {
        return;
      }
      var length = file.lengthSync();
      var size = entity.size;
      print(
        "${entity.id} length = $length, "
            "size = $size, "
            "dateTime = ${entity.createDateTime}",
      );
    } else {
      final Size size = entity.size;
      print("${entity.id} size = $size, dateTime = ${entity.createDateTime}");
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var permissionGranted = await PhotoManager.requestPermission();
    if (permissionGranted) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);
      print(albums);
      List<AssetEntity> media =  await albums[0].getAssetListPaged(currentPage, 60);
      // print(media);
      List<Widget> temp = [];
      for (var asset in media) {
        final assetFile = (await asset.file)!;
        if (await _faceDetectionController.isContainFace(assetFile)) {
        temp.add(
            FutureBuilder(
                future: asset.thumbData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GestureDetector(
                        onTap: () async {
                          _faceDataController.sourceImage.value = assetFile;
                          Get.toNamed("/pages.face_detection");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: MemoryImage(snapshot.data),
                                  fit: BoxFit.cover
                              )
                          ),
                        )
                    );
                  } else {
                    return Icon(Icons.image_rounded);
                  }  // return Container();
                }
            )
        );
        }
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          _handleScrollEvent(scroll);
          return true;
        },
        child: Container(
          child: GridView.builder(
              itemCount: _mediaList.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index){
                return _mediaList[index];
              }),
        )
    );
  }
}