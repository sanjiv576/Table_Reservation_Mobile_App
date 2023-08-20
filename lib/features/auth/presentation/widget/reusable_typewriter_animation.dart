import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ReusableTypewriterAnimation extends StatelessWidget {
  const ReusableTypewriterAnimation(
      {super.key, required this.message, required this.textFontSize});
  final double textFontSize;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          message.toString(),
          textStyle: TextStyle(
              fontSize: textFontSize,
              fontFamily: 'Alegreya Sans SC',
              color: Colors.white,
              fontStyle: FontStyle.italic),
        )
      ],
      repeatForever: true,
      onTap: () {
      },
    );
  }
}
