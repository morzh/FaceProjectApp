import 'dart:io';
import 'dart:typed_data';

import 'dart:ui';

class FaceAttributes {
  late double gender;
  late double glasses;
  late double yaw;
  late double pitch;
  late double beard;
  late double bald;
  late double age;
  late double smile;

  FaceAttributes({
    required this.gender,
    required this.glasses,
    required this.yaw,
    required this.pitch,
    required this.beard,
    required this.bald,
    required this.age,
    required this.smile
  });

  FaceAttributes.debug(){
    this.gender = 0;
    this.glasses = 0;
    this.yaw = 10;
    this.pitch = 10;
    this.beard = 0.5;
    this.bald = 0.5;
    this.age = 35;
    this.smile = 0.5;
  }

  factory FaceAttributes.fromJson(Map parsedJson){
    return FaceAttributes(
        gender: parsedJson['gender'],
        glasses: parsedJson['glasses'],
        yaw: parsedJson['yaw'],
        pitch: parsedJson ['pitch'],
        beard: parsedJson ['beard'],
        bald: parsedJson ['bald'],
        age: parsedJson ['age'],
        smile: parsedJson ['smile']
    );
  }

  printAttributes() {
    print("gender: " + this.gender.toString());
    print("glasses: " + this.glasses.toString());
    print("yaw: " + this.yaw.toString());
    print("pitch: " + this.pitch.toString());
    print("beard: " + this.beard.toString());
    print("bald: " + this.bald.toString());
    print("age: " + this.age.toString());
    print("smile: " + this.smile.toString());
  }
}

class FaceData {
  late final File sourceImage;
  late final Rect faceBoundingBox;
  late final File alignedFace;
  late final File encodedFace;
  late final List latent;
  late final List latentAugmented;
  late FaceAttributes faceAttributes;
  late final Map<String, dynamic> faceAttributesMap;
  late final List<File> augmentedImages;

  FaceData({
    required this.alignedFace,
    required this.encodedFace,
    required this.faceAttributes,
    required this.latent,
    required this.latentAugmented
  });

  readAugmentedImages(String filepath, double imagesNumber) {
    for(var idx = 0; idx < imagesNumber; ++idx) {
      augmentedImages.add(File(filepath + '/' +  idx.toString() + '.jpg'));
    }
  }



  printLatents() {
    print(this.latent);
    print(this.latentAugmented);
  }
}