import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/common/widget/device_size.dart';
import '../viewmodel/splash_view_model.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  late DeviceSize deviceSize;

  // send size of data to the DeviceSize class
  _initializeDeviceSize({required double height, required double width}) {
    deviceSize = DeviceSize(height: height, width: width);
  }

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => IntroView(),
      //   )
      // );

      // this decides whether user is already logged in or not

      ref.read(splashViewModelProvider.notifier).init(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // get sizes of the device, then, send to device size class
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    _initializeDeviceSize(width: width, height: height);

    return Scaffold(
      body: Center(
        child: SvgPicture.asset('assets/images/app_logo1.svg'),
      ),
    );
  }
}
