import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({
    super.key,
    bool enableHide = false,
    required String fieldName,
    required String example,
    required IconData iconData,
    required Function(String?) customOnChanged,
    Color iconColor = Colors.black,
    TextInputType keyboardTextType = TextInputType.text,
  })  : _enableHide = enableHide,
        _keyboardTextType = keyboardTextType,
        _fieldName = fieldName,
        _example = example,
        _iconColor = iconColor,
        _customOnChanged = customOnChanged,
        _iconData = iconData;

  final bool _enableHide;
  final TextInputType _keyboardTextType;
  final String _fieldName;
  final String _example;
  final IconData _iconData;
  final Function(String?) _customOnChanged;
  final Color _iconColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _enableHide,
      keyboardType: _keyboardTextType,
      onChanged: _customOnChanged,
      decoration: InputDecoration(
        labelText: 'Enter $_fieldName',
        hintText: _example.toString(),
        prefixIcon: Icon(
          _iconData,
          color: _iconColor,
        ),
      ),
    );
  }
}
