import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/config/themes/app_color_constant.dart';

import '../../../../core/common/provider/is_dark_theme.dart';

class CustomListTileWidget extends StatelessWidget {
  const CustomListTileWidget(
      {super.key, required String text, required IconData iconData})
      : _iconData = iconData,
        _text = text;

  final IconData _iconData;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      bool isDark = ref.read(isDarkThemeProvider);

      return ListTile(
        leading: Icon(_iconData,
            color: isDark
                ? AppColorConstant.nightTextColor
                : AppColorConstant.dayTextColor),
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          _text,
          style: TextStyle(
              fontSize: 16,
              color: isDark
                  ? AppColorConstant.nightTextColor
                  : AppColorConstant.dayTextColor),
        ),
      );
    });
  }
}
