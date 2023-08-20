import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../config/router/app_route.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/widget/device_size.dart';
import '../../../../core/utils/sensors/take_screenshote.dart';

class CustomerConfirmationView extends ConsumerStatefulWidget {
  const CustomerConfirmationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerConfirmationViewState();
}

class _CustomerConfirmationViewState
    extends ConsumerState<CustomerConfirmationView> {
  SizedBox gap = const SizedBox(height: 20);

  Map<String, String>? reservationsDetails;

  @override
  void didChangeDependencies() {
    reservationsDetails =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    super.didChangeDependencies();
  }

  final ScreenshotController _screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Screenshot(
          controller: _screenshotController,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: DeviceSize.height * .2),
              width: DeviceSize.width * .8,
              height: DeviceSize.height * .8,
              child: Column(
                children: [
                  Image.asset('assets/images/beer.png'),
                  gap,
                  const Text(
                    'Thank you for your reservation.',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  gap,
                  Text(
                    'Your reservation has been confirmed for ${reservationsDetails!['date']} at ${reservationsDetails!['time']}.You have reserved table for ${reservationsDetails!['dinerNum']} people at ${reservationsDetails!['place']}.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  gap,
                  gap,
                  SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoute.foodOrderRoute);
                      },
                      child: Text(
                        'Food Order',
                        style: kBoldPoppinsTextStyle.copyWith(
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  gap,
                  SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(
                            context, AppRoute.navigationRoute);
                      },
                      child: Text(
                        'Skip',
                        style: kBoldPoppinsTextStyle.copyWith(
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  gap,
                  SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: () {
                        TakeScreenShot takeScreenShot =
                            TakeScreenShot(_screenshotController);
                        takeScreenShot.takeScreenshot();
                      },
                      child: Text(
                        'Take Screenshot',
                        style: kBoldPoppinsTextStyle.copyWith(
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
