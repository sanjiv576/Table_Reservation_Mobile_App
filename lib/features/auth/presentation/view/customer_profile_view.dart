import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/widget/custom_textformfield_widget.dart';
import '../../../../core/common/widget/device_size.dart';
import '../../../../core/common/widget/profile_text_widget.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../../../../core/common/widget/user_profile_detail_widget.dart';
import '../../domain/entity/update_customer_profile_entity.dart';
import '../state/auth_state.dart';
import '../viewmodel/auth_view_model.dart';

final indicatorPoinProvider = StateProvider<double>((ref) => 0.0);

class CustomerProfileView extends ConsumerStatefulWidget {
  const CustomerProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerProfileViewState();
}

class _CustomerProfileViewState extends ConsumerState<CustomerProfileView>
    with SingleTickerProviderStateMixin {
  // final ImageProvider<Object> _userPicProfile = const NetworkImage(
  //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9inRqaFfeNmYbm_Z_AwaICGOVqcRE-Of5Lw&usqp=CAU');

  SizedBox gap = const SizedBox(height: 15);

  final _fullNameController =
      TextEditingController(text: AuthState.userEntity!.fullName);
  final _contactController =
      TextEditingController(text: AuthState.userEntity!.contact);
  final _emailController =
      TextEditingController(text: AuthState.userEntity!.email);
  final _usernameController =
      TextEditingController(text: AuthState.userEntity!.username);
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

//    : // later fetch data of reservation  from db
  final int _earnedPoint = 1600; // reservation * 10 i.e 160 * 10 = 1600
  final int _nextPoint = 2000;

  late AnimationController _animationController;
  late Animation _animation;
  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
    _fullNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void _startAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();

    // generate number from 0 to 1
    _animationController.addListener(() {
      double stoppingPoint = _earnedPoint / _nextPoint;

      ref.watch(indicatorPoinProvider.notifier).state =
          _animation.value * stoppingPoint;
    });
  }

  void _clearControllers() {
    _confirmPasswordController.clear();
    _passwordController.clear();
  }

  void _updateDetials() {
    if (_confirmPasswordController.text.trim() ==
        _passwordController.text.trim()) {
      UpdateCustomerProfileEntity updatedUserProfile =
          UpdateCustomerProfileEntity(
        fullName: _fullNameController.text.trim(),
        contact: _contactController.text.trim(),
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // update
      ref.watch(authViewModelProvider.notifier).updateUserProfile(
          customerProfileEntity: updatedUserProfile, context: context);

      setState(() {
        AuthState.userEntity;
      });

      _clearControllers();

      return;
    } else {
      _clearControllers();
      Navigator.pop(context);

      showSnackbarMsg(
          context: context,
          targetTitle: 'Error',
          targetMessage: 'Password and Confirm password do not match',
          type: ContentType.failure);
    }
  }

  checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  File? _img;
  Future _browseImage(WidgetRef ref, ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _img = File(image.path);
          ref.read(authViewModelProvider.notifier).uploadImage(_img!);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _modalForCamera() {
    showModalBottomSheet(
      backgroundColor: Colors.grey[300],
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                checkCameraPermission();
                _browseImage(ref, ImageSource.camera);
                Navigator.pop(context);
                // Upload image it is not null
              },
              icon: const Icon(Icons.camera),
              label: const Text('Camera'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _browseImage(ref, ImageSource.gallery);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.image),
              label: const Text('Gallery'),
            ),
          ],
        ),
      ),
    );
  }

  void _openBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                thickness: 4,
                indent: DeviceSize.width * .4,
                endIndent: DeviceSize.width * .4,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        CustomTextFieldFormWidget(
                          controllerName: _fullNameController,
                          fieldName: 'full name',
                          fillColor: const Color.fromARGB(255, 170, 140, 140),
                          example: '',
                          iconData: Icons.person,
                        ),
                        gap,
                        CustomTextFieldFormWidget(
                          controllerName: _contactController,
                          fieldName: 'contact',
                          fillColor: const Color.fromARGB(255, 170, 140, 140),
                          keyboardTextType: TextInputType.number,
                          example: '',
                          iconData: Icons.phone,
                        ),
                        gap,
                        CustomTextFieldFormWidget(
                          controllerName: _emailController,
                          fieldName: 'email',
                          fillColor: const Color.fromARGB(255, 170, 140, 140),
                          keyboardTextType: TextInputType.emailAddress,
                          example: '',
                          iconData: Icons.email,
                        ),
                        gap,
                        CustomTextFieldFormWidget(
                          controllerName: _usernameController,
                          fieldName: 'username',
                          example: '',
                          iconData: Icons.person,
                          fillColor: const Color.fromARGB(255, 170, 140, 140),
                        ),
                        gap,
                        CustomTextFieldFormWidget(
                          enableHide: true,
                          controllerName: _passwordController,
                          fieldName: 'password',
                          example: '',
                          iconData: Icons.password,
                          fillColor: const Color.fromARGB(255, 170, 140, 140),
                        ),
                        gap,
                        CustomTextFieldFormWidget(
                          enableHide: true,
                          controllerName: _confirmPasswordController,
                          fieldName: 'confirm password',
                          fillColor: const Color.fromARGB(255, 170, 140, 140),
                          example: '',
                          iconData: Icons.password,
                        ),
                        gap,
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _updateDetials();
                                }
                              },
                              child: Text(
                                'UPDATE',
                                style: kBoldPoppinsTextStyle,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: DeviceSize.height * .1,
            horizontal: DeviceSize.width * .1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileDetailWidget(
                userPicProfile: _img != null
                    ? FileImage(_img!)
                    : AuthState.userEntity!.picture != null
                        ? NetworkImage(
                            '${ApiEndpoints.imageUrl}${AuthState.userEntity!.picture}')
                        : const AssetImage(
                                'assets/images/profile/default_user_image.jpg')
                            as ImageProvider,
                restaurantName: '',
                userFullName: AuthState.userEntity!.fullName,
                contact: AuthState.userEntity!.contact,
                email: AuthState.userEntity!.email,
                location: '',
                gap: gap,
                reservationNum: 160,
                reviewsNum: 102,
                customOnPressed: () {
                  _modalForCamera();
                },
              ),
              gap,
              const ProfileTextWidget(
                text: 'Your Points',
                fontSize: 23,
              ),
              gap,
              LinearProgressIndicator(
                value: ref.watch(indicatorPoinProvider),
                color: Colors.red,
                backgroundColor: Colors.white,
                minHeight: 20,
              ),
              gap,
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileTextWidget(
                          text: '${_animation.value * _earnedPoint}',
                          fontSize: 20,
                        ),
                        const ProfileTextWidget(
                          text: 'Earned',
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ProfileTextWidget(
                          text: _nextPoint.toString(),
                          fontSize: 20,
                        ),
                        const ProfileTextWidget(
                          text: 'Next',
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              gap,
              TextButton(
                onPressed: () {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "Delete",
                    desc: "Are you sure to delete account ?",
                    buttons: <DialogButton>[
                      DialogButton(
                        onPressed: () => Navigator.pop(context),
                        color: const Color.fromRGBO(218, 99, 109, 1),
                        child: const Text(
                          "No",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      DialogButton(
                        onPressed: () {
                          // delete the account
                          ref
                              .watch(authViewModelProvider.notifier)
                              .deleteAccount(context: context);
                          // back
                          Navigator.pop(context);
                        },
                        gradient: const LinearGradient(colors: [
                          Color.fromRGBO(109, 173, 167, 1),
                          Color.fromRGBO(52, 138, 199, 1.0)
                        ]),
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ],
                  ).show();
                },
                child: const ProfileTextWidget(
                  text: 'Delete Account',
                  fontSize: 16,
                ),
              ),
              gap,
              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: () {
                    _openBottomSheet();
                  },
                  child: Text(
                    'UPDATE CREDENTIALS',
                    style: kBoldPoppinsTextStyle,
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
