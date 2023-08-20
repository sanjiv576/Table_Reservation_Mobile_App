import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTextWidget extends ConsumerWidget {
  const ProfileTextWidget(
      {super.key, double fontSize = 20, required String text})
      : _fontSize = fontSize,
        _text = text;

  final double _fontSize;
  final String _text;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      _text.toString(),
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: _fontSize,
        color: Colors.white,
      ),
    );
  }
}
