import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:convert';

class FaceListModel {
  List<FaceModel> list;

  FaceListModel(this.list);

  factory FaceListModel.fromJson(List<Face> faces) {
    final Iterable refactorList = faces;

    final list = refactorList.map((item) {
      return FaceModel.fromJson(item);
    }).toList();

    return FaceListModel(list);
  }

  Map<String, dynamic> toJson() {
    return {
      "list": list.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return json.encode(list.map((e) => e.toJson()).toList());
  }
}

class FaceModel {
  FaceModel({
    this.face,
  });

  Face face;

  factory FaceModel.fromJson(Face myFace) => FaceModel(
        face: myFace,
      );

  Map<String, dynamic> toJson() => {
        "face": {
          'headEulerAngleY': face?.headEulerAngleY,
          'headEulerAngleZ': face?.headEulerAngleZ,
          'leftEyeOpenProbability': face?.leftEyeOpenProbability,
          'rightEyeOpenProbability': face?.rightEyeOpenProbability,
          'smilingProbability': face?.smilingProbability,
          'trackingId': face?.trackingId,
        },
        "rect": {
          'left': face?.boundingBox?.left,
          'bottom': face?.boundingBox?.bottom,
          'top': face?.boundingBox?.top,
          'right': face?.boundingBox?.right,
        },
      };

  @override
  String toString() {
    return json.encode(toJson());
  }
}
