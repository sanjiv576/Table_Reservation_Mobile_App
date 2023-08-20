import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/router/app_route.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/provider/is_dark_theme.dart';
import '../../../../core/common/widget/custom_textformfield_widget.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../../domain/entity/user_entity.dart';
import '../viewmodel/auth_view_model.dart';
import '../widget/reusable_typewriter_animation.dart';

final selectedRoleProvider = StateProvider<String>((ref) => '');
final isCheckedProvider = StateProvider<bool>((ref) => false);
final enableHideProvider = StateProvider<bool>((ref) => true);

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _resetControllers() {
    _usernameController.clear();
    _confirmPasswordController.clear();
    _emailController.clear();
    _passwordController.clear();
    _contactController.clear();
    _fullNameController.clear();
  }

  void _showMePassword() {
    if (ref.watch(isCheckedProvider)) {
      ref.watch(isCheckedProvider.notifier).state = false;
      ref.watch(enableHideProvider.notifier).state = true;
    } else {
      ref.watch(isCheckedProvider.notifier).state = true;
      ref.watch(enableHideProvider.notifier).state = false;
    }
  }

  void _registerSubmit() {
    if (!_emailController.text.trim().contains('@')) {
      showSnackbarMsg(
          context: context,
          targetTitle: 'Error',
          targetMessage: 'Email is not valid, missing @.',
          type: ContentType.failure);
    } else if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      showSnackbarMsg(
          context: context,
          targetTitle: 'Error',
          targetMessage: 'Password and Re-password do not match.',
          type: ContentType.failure);
    } else {
      UserEntity newUser = UserEntity(
        fullName: _fullNameController.text.trim(),
        contact: _contactController.text.trim(),
        role: ref.watch(selectedRoleProvider).toLowerCase(),
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      _resetControllers();

      ref
          .watch(authViewModelProvider.notifier)
          .registerUser(user: newUser, context: context);
    }
  }

  final List<String> roleList = ['Restaurant Owner', 'Customer'];

  late final List<DropdownMenuEntry<String>> roleEntries =
      <DropdownMenuEntry<String>>[];
  final formKey = GlobalKey<FormState>();

  SizedBox gap = const SizedBox(
    height: 10.0,
  );

  // late DeviceSize _deviceSize;
  @override
  void initState() {
    super.initState();

    for (String userRole in roleList) {
      roleEntries.add(DropdownMenuEntry(value: userRole, label: userRole));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.read(isDarkThemeProvider);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(40),
                  child: const ReusableTypewriterAnimation(
                    message: 'Join the club, by signing up in the hub!!',
                    textFontSize: 14.0,
                  ),
                ),
                CustomTextFieldFormWidget(
                  controllerName: _fullNameController,
                  fieldName: 'full name',
                  example: 'E.g Sanjiv Shrestha',
                  iconData: Icons.person,
                ),
                gap,
                TextFormField(
                  controller: _contactController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please, enter your contact';
                    } else if (value.length != 10) {
                      return 'Invalid number';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter contact',
                    hintText: 'E.g 9800000000',
                    prefixIcon: Icon(
                      Icons.call,
                      color: Colors.black,
                    ),
                  ),
                ),
                gap,
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your role';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Choose your role',
                    iconColor: Colors.black,
                    prefixIcon: const Icon(
                      Icons.people,
                      color: Colors.black,
                    ),
                    fillColor: isDark ? Colors.teal : Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  items: roleList
                      .map(
                        (role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    ref.watch(selectedRoleProvider.notifier).state = value!;
                  },
                ),
                gap,
                CustomTextFieldFormWidget(
                  controllerName: _usernameController,
                  fieldName: 'username',
                  example: 'E.g sanjiv34',
                  iconData: Icons.person,
                ),
                gap,
                CustomTextFieldFormWidget(
                  controllerName: _emailController,
                  fieldName: 'email',
                  example: 'E.g abc@gmail.com',
                  iconData: Icons.email,
                  keyboardTextType: TextInputType.emailAddress,
                ),
                gap,
                Column(
                  children: [
                    CustomTextFieldFormWidget(
                      enableHide: ref.watch(enableHideProvider),
                      controllerName: _passwordController,
                      example: 'E.g abc123',
                      iconData: Icons.lock,
                      fieldName: 'password',
                    ),
                    gap,
                    CustomTextFieldFormWidget(
                      enableHide: ref.watch(enableHideProvider),
                      controllerName: _confirmPasswordController,
                      fieldName: 'confirm password',
                      example: 'E.g abc123',
                      iconData: Icons.lock,
                    ),
                    gap,
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.black,
                          activeColor: Colors.pink,
                          hoverColor: Colors.blue,
                          fillColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.white),
                          value: ref.watch(isCheckedProvider),
                          onChanged: ((value) {
                            _showMePassword();
                          }),
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                        const Text(
                          'Show Passowrd',
                          style: kTextStyle,
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55.0,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _registerSubmit();
                        }
                      },
                      child: Text(
                        'SIGN UP',
                        style: kBoldPoppinsTextStyle,
                      )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                        text: 'Have an account ?   ', style: kTextStyle),
                    TextSpan(
                        text: 'Sign in now',
                        style: kTextStyle.copyWith(color: Colors.red),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, AppRoute.signInRoute);
                          }),
                  ]),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
