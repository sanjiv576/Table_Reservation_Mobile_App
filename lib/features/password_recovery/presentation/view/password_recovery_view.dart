import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/themes/constant.dart';
import '../../../../core/common/widget/custom_appbar_widget.dart';
import '../../../../core/common/widget/custom_textformfield_widget.dart';
import '../../../../core/common/widget/device_size.dart';
import '../../../../core/common/widget/snackbar_messages.dart';

final userValidProvider = StateProvider<bool>((ref) => false);

class PasswordRecoveryView extends ConsumerStatefulWidget {
  const PasswordRecoveryView({super.key});

  @override
  ConsumerState<PasswordRecoveryView> createState() =>
      _PasswordRecoveryViewState();
}

class _PasswordRecoveryViewState extends ConsumerState<PasswordRecoveryView> {
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();

    ref.watch(userValidProvider.notifier).state = false;
  }

  void _clearControllers() {
    _passwordController.clear();
    _usernameController.clear();
    _confirmPasswordController.clear();
    _phoneController.clear();
  }

  void _checkCredential() {

    // if valid then, show remaining content for recovering password
    ref.watch(userValidProvider.notifier).state = true;
  }

  void _submit() {
    if (_confirmPasswordController.text.trim() ==
        _passwordController.text.trim()) {
      showSnackbarMsg(
          context: context,
          targetTitle: 'Success',
          targetMessage: 'New credential has been set successfully',
          type: ContentType.success);

      Navigator.pop(context);
    } else {
      showSnackbarMsg(
          context: context,
          targetTitle: 'Error',
          targetMessage: 'Password and Confrim password do not match.',
          type: ContentType.failure);
    }
  }

  SizedBox gap = const SizedBox(height: 15);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Password Recovery',
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
              horizontal: DeviceSize.width * .1, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFieldFormWidget(
                  controllerName: _phoneController,
                  fieldName: 'phone',
                  example: 'E.g 98XXXXXXXX',
                  iconData: Icons.phone,
                  keyboardTextType: TextInputType.number,
                ),
                gap,
                CustomTextFieldFormWidget(
                  controllerName: _usernameController,
                  fieldName: 'username',
                  example: 'E.g abc34',
                  iconData: Icons.person,
                ),
                gap,
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _checkCredential();
                      }
                    },
                    child: Text(
                      'CONTINUE',
                      style: kBoldPoppinsTextStyle,
                    ),
                  ),
                ),
                gap,
                gap,
                ref.watch(userValidProvider)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gap,
                          const Text(
                            'Create new credentials',
                            style: kTextStyle,
                          ),
                          gap,
                          CustomTextFieldFormWidget(
                            controllerName: _passwordController,
                            fieldName: ' password',
                            example: 'E.g abc123',
                            iconData: Icons.password,
                            enableHide: true,
                          ),
                          gap,
                          CustomTextFieldFormWidget(
                            controllerName: _confirmPasswordController,
                            fieldName: 'confirm password',
                            example: 'E.g abc34',
                            enableHide: true,
                            iconData: Icons.password,
                          ),
                          gap,
                          gap,
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _submit();
                                }
                              },
                              child: Text(
                                'SUBMIT',
                                style: kBoldPoppinsTextStyle,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
