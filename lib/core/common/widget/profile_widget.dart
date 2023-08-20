import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    required VoidCallback onPressed,
    required ImageProvider<Object> userBackgroundImage,
    required double radius,
    super.key,
  })  : _userBackgroundImage = userBackgroundImage,
        _radius = radius,
        _onPressed = onPressed;

  final VoidCallback _onPressed;
  final ImageProvider<Object> _userBackgroundImage;
  final double _radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: _radius,
          backgroundColor: Colors.white,
          backgroundImage: _userBackgroundImage,
        ),
        Positioned(
          bottom: 0,
          right: 6,
          child: IconButton(
              onPressed: _onPressed,
              icon: const Icon(
                Icons.photo_camera,
                size: 40,
                color: Colors.green,
              )),
        ),
      ],
    );
  }
}
