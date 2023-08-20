import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class TakeScreenShot {
  static Timer? _timer;

  final ScreenshotController _screenshotController;

  // final ScreenshotController screenshotController;
  // TakeScreenShot(ScreenshotController screenshotController) {
  //   screenshotController = _screenshotController;
  // }

  TakeScreenShot(this._screenshotController);

   void startTimerAndTakeScreenshot() {
    _timer = Timer(const Duration(seconds: 3), () {
      // screen shot
      takeScreenshot();
    });
  }

  static void cancelTimer() => _timer!.cancel();

   void takeScreenshot() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      try {
        // save in the gallery
        await _saveImage(image);
        Fluttertoast.showToast(
          msg: 'Screenshot successfully.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // also share with friends
        await _saveAndShare(image);
      } catch (err) {
        Fluttertoast.showToast(
          msg: 'Failed to screenshot.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

// function to save image on the gallery
  static Future<String> _saveImage(Uint8List bytes) async {
    // ask permission to save
    await [Permission.storage].request();

    // add current time at the end of filename
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final fileName = 'screenshot_$time';
    // save the image
    final result = await ImageGallerySaver.saveImage(bytes, name: fileName);
    return result['filePath'];
  }

  // function to share screenshot image with others
  static Future _saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    String textMessage = 'Shared from Table Reservation App';
    await Share.shareFiles([image.path], text: textMessage);
  }
}
