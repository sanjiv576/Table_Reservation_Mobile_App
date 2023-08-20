import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void showSnackbarMsg(
    {required BuildContext context,
    required String targetTitle,
    required String targetMessage,
    required ContentType type}) {
  final snackBar = SnackBar(
    content: AwesomeSnackbarContent(
        title: targetTitle, message: targetMessage, contentType: type),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
