import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDetectCardWidget extends ConsumerWidget {
  const CustomDetectCardWidget(
      {super.key,
      required String text,
      required VoidCallback onTap,
      Color? color,
      required IconData iconData})
      : _customOnTap = onTap,
        _chosenColor = color ?? Colors.white,
        _iconData = iconData,
        _text = text;

  final VoidCallback _customOnTap;
  final IconData _iconData;
  final String _text;
  final Color? _chosenColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: _customOnTap,
      child: SizedBox(
        height: 100,
        width: 100,
        child: Card(
          color: _chosenColor,
          shadowColor: const Color.fromARGB(255, 39, 221, 109),
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Icon(
                    _iconData,
                    color: Colors.deepPurple,
                    size: 45,
                  ),
                ),
                Expanded(
                    child: Text(
                  _text.toString(),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold, color:Colors.black),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
