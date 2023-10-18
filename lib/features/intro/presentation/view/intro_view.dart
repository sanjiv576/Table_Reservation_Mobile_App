import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../../config/router/app_route.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/widget/device_size.dart';

class IntroView extends ConsumerWidget {
  IntroView({super.key});

  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.popAndPushNamed(context, AppRoute.signInRoute);
  }

  Widget _buildImage(String imagePath, [double width = 450]) {
    return Image.asset('assets/images/$imagePath', width: width);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.white),
      bodyTextStyle: TextStyle(
          fontSize: 14.0, color: Colors.white, fontStyle: FontStyle.italic),
      bodyPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
      pageColor: Color(0xFF282C3B),
      imagePadding: EdgeInsets.symmetric(
        vertical: 10,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: IntroductionScreen(
            key: introKey,
            // globalBackgroundColor: Colors.pink,
            allowImplicitScrolling: true,
            autoScrollDuration: 2000,
            globalHeader: Align(
              alignment: Alignment.center,
              child: Container(),
            ),
            globalFooter: SizedBox(
              // width: DeviceSize.width * .75,
              width: double.infinity,
              height: DeviceSize.height * .07,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF705CEF),
                ),
                child: Text(
                  'GET STARTED',
                  style: kBoldPoppinsTextStyle,
                ),
                onPressed: () => _onIntroEnd(context),
              ),
            ),

            pages: [
              PageViewModel(
                title: "Welcome to Table Reservation App !",
                body:
                    "Your privacy is important to us. We only store your information for finding restaurants, leaving reviews, and making table reservations on our app.",
                image: _buildImage('app_logo.png'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Book a table, Don't be late",
                body: "Make a plan, Bring your clan!",
                image: _buildImage('intro_pic1.png'),
                decoration: pageDecoration,
              ),
            ],
            onDone: () => _onIntroEnd(context),
            showSkipButton: false,
            skipOrBackFlex: 0,
            nextFlex: 0,
            showBackButton: true,
            //rtl: true, // Display as right-to-left
            back: const Icon(Icons.arrow_back),
            skip: const Text('Skip',
                style: TextStyle(fontWeight: FontWeight.w600)),
            next: const Icon(Icons.arrow_forward),
            done: const Text('Done',
                style: TextStyle(fontWeight: FontWeight.w600)),
            curve: Curves.fastLinearToSlowEaseIn,
            controlsMargin: const EdgeInsets.all(16),
            controlsPadding: kIsWeb
                ? const EdgeInsets.all(12.0)
                : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            dotsContainerDecorator: const ShapeDecoration(
              color: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
