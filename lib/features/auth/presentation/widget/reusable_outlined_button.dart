import 'package:flutter/material.dart';

class ReusableExpanded extends StatelessWidget {
  // const ReusableExpanded({Key? key,}) : super(key: key);

  final String? iconUrl;
  final VoidCallback onPressedCustom;

  const ReusableExpanded(
      {super.key, required this.iconUrl, required this.onPressedCustom});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressedCustom,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE9ECF5),
          padding: const EdgeInsets.all(17.0),
          textStyle: const TextStyle(fontSize: 44.0),
          side: const BorderSide(color: Colors.white, width: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Image(
          image: NetworkImage(iconUrl.toString()),
        ));
  }
}
