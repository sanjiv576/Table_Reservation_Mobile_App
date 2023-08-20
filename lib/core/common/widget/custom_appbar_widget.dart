import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/themes/constant.dart';

class CustomAppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBarWidget({
    Key? key,
    bool? showBackButton,
    required this.title,
  })  : showBackButton = showBackButton ?? false,
        super(key: key);

  final String title;
  final bool showBackButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: showBackButton,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        title,
        style: kBoldPoppinsTextStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
