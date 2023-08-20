import 'package:flutter/material.dart';

class DashboardCardWidget extends StatelessWidget {
  DashboardCardWidget(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.onCustomTap});

  String? title;
  String? imagePath;
  VoidCallback onCustomTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCustomTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Builder(builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath.toString(),
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title.toString(),
                selectionColor: Colors.pink,
                style: const TextStyle(color: Colors.black),
              )
            ],
          );
        }),
      ),
    );
  }
}
