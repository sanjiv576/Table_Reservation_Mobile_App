import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_reservation_mobile_app/features/auth/presentation/viewmodel/auth_view_model.dart';

import '../../../../config/router/app_route.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/provider/is_dark_theme.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../widget/reusable_outlined_button.dart';
import '../widget/reusable_typewriter_animation.dart';

final enableHideProvider = StateProvider<bool>((ref) => true);
final hideIconProvider =
    StateProvider<IconData>((ref) => Icons.remove_red_eye_rounded);

class SignInView extends ConsumerStatefulWidget {
  const SignInView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  // const SignInView({super.key});

  late bool isDark;
  @override
  void initState() {
    isDark = ref.read(isDarkThemeProvider);

    super.initState();
  }

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

// reset textfields after Sign in is pressed
  void _resetUserFields() {
    _usernameController.clear();
    _passwordController.clear();
  }

  void _switchIcon() {
    if (ref.watch(enableHideProvider)) {
      ref.watch(enableHideProvider.notifier).state = false;
      ref.watch(hideIconProvider.notifier).state = FontAwesomeIcons.eyeSlash;
    } else {
      ref.watch(enableHideProvider.notifier).state = true;

      ref.watch(hideIconProvider.notifier).state = Icons.remove_red_eye_rounded;
    }
  }

  void _checkUserValidationAndSubmit({required BuildContext context}) async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      // call login method of viewmodel
      await ref
          .read(authViewModelProvider.notifier)
          .loginUser(username: username, password: password, context: context);
    }

    // reset forms
    _resetUserFields();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(50.0),
                    child: const ReusableTypewriterAnimation(
                      message: 'Time to sign in, let the fun begin !!',
                      textFontSize: 14.0,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        showSnackbarMsg(
                            context: context,
                            targetTitle: 'Oops!',
                            targetMessage: 'Please, enter your username',
                            type: ContentType.warning);
                        return 'Missing username';
                      }

                      return null;
                    },
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter username',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    obscureText: ref.watch(enableHideProvider),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        showSnackbarMsg(
                            context: context,
                            targetTitle: 'Oops!',
                            targetMessage: 'Please, enter your password',
                            type: ContentType.warning);
                        return 'Missing password';
                      }

                      return null;
                    },
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            ref.watch(hideIconProvider),
                            color: Colors.black,
                          ),
                          onPressed: () {
                            _switchIcon();
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(
                          //     context, AppRoute.passwordRecoveryRoute);
                        },
                        child: const Text(
                          'Forget Password',
                          textAlign: TextAlign.right,
                          style: kTextStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 55.0,
                    child: ElevatedButton(
                      onPressed: () {
                        _checkUserValidationAndSubmit(context: context);
                      },
                      child: Text(
                        'SIGN IN',
                        style: kBoldPoppinsTextStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Divider(
                          height: 34.0,
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(
                            'Or continue with',
                            textAlign: TextAlign.center,
                            style: kTextStyle,
                          )),
                      Expanded(
                        child: Divider(
                          height: 34.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ReusableExpanded(
                              iconUrl: googleIconUrl, onPressedCustom: () {}),
                        ),
                        const SizedBox(
                          width: 40.0,
                        ),
                        Expanded(
                          child: ReusableExpanded(
                              iconUrl: facebookIconUrl, onPressedCustom: () {}),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                          text: 'Not a member ?   ', style: kTextStyle),
                      TextSpan(
                          text: 'Register now',
                          style: kTextStyle.copyWith(color: Colors.red),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context, AppRoute.signUpRoute);
                            }),
                    ]),
                  ),
                  // const SizedBox(
                  //   height: 20.0,
                  // ),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, AppRoute.internetRoute);
                  //   },
                  //   child: const Text('Check internet'),
                  // ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  // Switch(
                  //     value: isDark,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         isDark = value;
                  //         ref
                  //             .read(isDarkThemeProvider.notifier)
                  //             .updateTheme(value);
                  //       });
                  //     }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
