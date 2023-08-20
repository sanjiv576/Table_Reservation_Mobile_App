import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/themes/app_color_constant.dart';
import '../provider/is_dark_theme.dart';

class CustomTextFieldFormWidget extends ConsumerWidget {
  const CustomTextFieldFormWidget({
    super.key,
    bool enableHide = false,
    Color fillColor = Colors.white,
    required TextEditingController controllerName,
    required String fieldName,
    required String example,
    required IconData iconData,
    TextInputType keyboardTextType = TextInputType.text,
  })  : _enableHide = enableHide,
        _keyboardTextType = keyboardTextType,
        _fieldName = fieldName,
        _example = example,
        _fillColor = fillColor,
        _iconData = iconData,
        _controllerName = controllerName;

  final bool _enableHide;
  final TextEditingController _controllerName;
  final TextInputType _keyboardTextType;
  final String _fieldName;
  final String _example;
  final IconData _iconData;
  final Color? _fillColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(isDarkThemeProvider);
    return TextFormField(
      obscureText: _enableHide,
      keyboardType: _keyboardTextType,
      validator: (value) {
        return value == null || value.isEmpty
            ? 'Please, enter your $_fieldName'
            : null;
      },
      controller: _controllerName,
      decoration: InputDecoration(
        labelText: 'Enter $_fieldName',
        hintText: _example.toString(),
        fillColor: isDark
            ? AppColorConstant.nightInputBackgroundColor
            : AppColorConstant.dayInputBackgroundColor,
        prefixIcon: Icon(
          _iconData,
          color: Colors.black,
        ),
      ),
    );
  }
}
