import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:absen_online/configs/config.dart';

class AppFacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];

  AppFacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      // ..maskFilter = MaskFilter.blur(BlurStyle.outer, 10.0)
      ..color = Colors.white.withOpacity(0.5);

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      print('SMILING' + faces[i].leftEyeOpenProbability.toString());
      if (Application.remoteConfig.application.presensi.showFaceInformation) {
        String teks = '';
        String smliling = faces[i] != null
            ? faces[i].smilingProbability.toString().substring(0, 5)
            : 'Clasification Error';
        String eyeRight = faces[i].rightEyeOpenProbability != null
            ? faces[i].rightEyeOpenProbability.toString().substring(0, 5)
            : 'Clasification Error';
        String eyeLeft = faces[i].leftEyeOpenProbability != null
            ? faces[i].leftEyeOpenProbability.toString().substring(0, 5)
            : 'Clasification Error';

        teks += 'Smiling : ' + smliling + ' %\n';
        teks += 'Left Eye Open : ' + eyeLeft + ' %\n';
        teks += 'Right Eye Open : ' + eyeRight + ' %\n';

        textPainters(
            teks: teks,
            offset: Offset(rects[i].left, rects[i].bottom + 10),
            canvas: canvas,
            size: size);
        textPainters(
            teks: 'Face Detected',
            offset: Offset(rects[i].left, rects[i].top - 30),
            canvas: canvas,
            size: size);
      }
      canvas.drawRect(rects[i], paint);
    }
  }

  textPainters({String teks, Offset offset, Canvas canvas, ui.Size size}) {
    final textStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontSize: 20,
    );
    final textSpan = TextSpan(
      text: teks,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(AppFacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}
