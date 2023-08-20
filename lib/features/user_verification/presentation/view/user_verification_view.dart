import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/router/app_route.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../../data/model/user_verification.dart';
import '../widget/reusable_pin.dart';

class UserVerificationView extends ConsumerStatefulWidget {
  const UserVerificationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserVerificationViewState();
}

class _UserVerificationViewState extends ConsumerState<UserVerificationView> {
  String _fullPin = '';

  int? _correctOTP;
  String? _userRole;

  final _pin1Controller = TextEditingController();
  final _pin2Controller = TextEditingController();
  final _pin3Controller = TextEditingController();
  final _pin4Controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitPins({required otpPin}) {
    if (UserVerification.checkOtp(yourOTP: int.parse(otpPin))) {
      // print('Move to Dashboard successfully');
      showSnackbarMsg(
          context: context,
          targetTitle: 'Success',
          targetMessage: 'Congratulations ! Your account has been created.',
          type: ContentType.success);

      if (_userRole == 'Restaurant Owner') {
        Navigator.popAndPushNamed(context, AppRoute.fillRestaurantDetailsRoute);
      } else {
        // TODO: // if the it is the Customer then, open dashboard of the customer
      }
    } else {
      String errorMsg =
          '$otpPin OTP code does not match. Try Again. Correct OTP code is $_correctOTP';
      showSnackbarMsg(
          context: context,
          targetTitle: 'Error',
          targetMessage: errorMsg,
          type: ContentType.failure);
    }

    _resetFullPin();
    _resetControllers();
  }

  void _resetFullPin() => _fullPin = '';

  void _resetControllers() {
    _pin1Controller.clear();
    _pin2Controller.clear();
    _pin3Controller.clear();
    _pin4Controller.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    _correctOTP = int.parse(arguments['correctOTP']!);
    _userRole = arguments['userRole'];
  }

  @override
  void dispose() {
    super.dispose();

    _resetControllers();
    _resetFullPin();

    _pin1Controller.dispose();
    _pin2Controller.dispose();
    _pin3Controller.dispose();
    _pin4Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 90.0, horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/userVerification.png'),
                    radius: 100,
                    backgroundColor: Color(0xffd798f7),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text('Verification',
                      style: kBoldPoppinsTextStyle.copyWith(
                        fontSize: 32.0,
                        color: Colors.white,
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Enter the OTP send to your phone number',
                    style: kTextStyle.copyWith(
                        fontWeight: FontWeight.normal, letterSpacing: 1.15),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusablePinput(
                        controllerName: _pin1Controller,
                        onChangedFunc: (pinValue) {
                          if (pinValue.length == 1) {
                            FocusScope.of(context).nextFocus();
                            _fullPin += pinValue.toString();
                          }
                        },
                      ),
                      ReusablePinput(
                        controllerName: _pin2Controller,
                        onChangedFunc: (pinValue) {
                          if (pinValue.length == 1) {
                            FocusScope.of(context).nextFocus();
                            _fullPin += pinValue.toString();
                          }
                        },
                      ),
                      ReusablePinput(
                        controllerName: _pin3Controller,
                        onChangedFunc: (pinValue) {
                          if (pinValue.length == 1) {
                            FocusScope.of(context).nextFocus();
                            _fullPin += pinValue.toString();
                          }
                        },
                      ),
                      ReusablePinput(
                        controllerName: _pin4Controller,
                        onChangedFunc: (pinValue) {
                          if (pinValue.length == 1) {
                            FocusScope.of(context).nextFocus();
                            _fullPin += pinValue.toString();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _submitPins(otpPin: _fullPin);
                      },
                      child: Text(
                        ' VERIFY ME',
                        textAlign: TextAlign.center,
                        style: kBoldPoppinsTextStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Didn\'t receive any code ?',
                    style: kTextStyle.copyWith(
                        fontWeight: FontWeight.normal, letterSpacing: 1.15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        // TODO: // This code is only for testing. Later, it should not use here.
                        _correctOTP = UserVerification.getOtp;

                        showSnackbarMsg(
                            context: context,
                            targetTitle: 'New OTP code',
                            targetMessage: 'New OTP code is $_correctOTP',
                            type: ContentType.help);
                      },
                      child: Text(
                        'Resend new code',
                        style: kTextStyle.copyWith(letterSpacing: 1.05),
                      ))
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
