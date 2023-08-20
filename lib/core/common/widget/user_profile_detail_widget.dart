import 'package:flutter/material.dart';

import 'profile_text_widget.dart';
import 'profile_widget.dart';

class UserProfileDetailWidget extends StatelessWidget {
  const UserProfileDetailWidget({
    super.key,
    required ImageProvider<Object> userPicProfile,
    required String restaurantName,
    required String userFullName,
    required String contact,
    required String email,
    required String location,
    required this.gap,
    required VoidCallback customOnPressed,
    required int reservationNum,
    required int reviewsNum,
  })  : _userPicProfile = userPicProfile,
        _restaurantName = restaurantName,
        _userFullName = userFullName,
        _contact = contact,
        _email = email,
        _location = location,
        _reservationNum = reservationNum,
        _reviewsNum = reviewsNum,
        _customOnPressed = customOnPressed;

  final ImageProvider<Object> _userPicProfile;
  final String _restaurantName;
  final String _userFullName;
  final String _contact;
  final String _email;
  final String _location;
  final SizedBox gap;
  final int _reservationNum;
  final int _reviewsNum;
  final VoidCallback _customOnPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            ProfileWidget(
              radius: 60,
              onPressed: _customOnPressed,
              userBackgroundImage: _userPicProfile,
            ),
            ProfileTextWidget(
              fontSize: 30,
              text: _restaurantName,
            ),
            ProfileTextWidget(text: _userFullName),
            ProfileTextWidget(text: _contact),
            ProfileTextWidget(text: _email),
            ProfileTextWidget(text: _location),
            gap,
            const Divider(
              thickness: 4,
            ),
          ],
        ),
        gap,
        const ProfileTextWidget(
          text: 'Your Stats',
          fontSize: 23,
        ),
        gap,
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  ProfileTextWidget(
                    text: _reservationNum.toString(),
                    fontSize: 23,
                  ),
                  const ProfileTextWidget(
                    text: 'Reservations',
                    fontSize: 16,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ProfileTextWidget(
                    text: _reviewsNum.toString(),
                    fontSize: 23,
                  ),
                  const ProfileTextWidget(
                    text: 'Reviews',
                    fontSize: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        gap,
      ],
    );
  }
}
