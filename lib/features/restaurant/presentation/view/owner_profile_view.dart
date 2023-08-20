import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:table_reservation_mobile_app/features/restaurant/domain/entity/update_restaurant_entity.dart';
import 'package:table_reservation_mobile_app/features/restaurant/presentation/state/restaurant_state.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../config/router/app_route.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/widget/custom_textformfield_widget.dart';
import '../../../../core/common/widget/device_size.dart';
import '../../../../core/common/widget/profile_text_widget.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../../../../core/common/widget/user_profile_detail_widget.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../../auth/presentation/viewmodel/auth_view_model.dart';
import '../viewmodel/restaurant_viewmodel.dart';

class OwnerProfileView extends ConsumerStatefulWidget {
  const OwnerProfileView({super.key});

  @override
  ConsumerState<OwnerProfileView> createState() => _OwnerProfileViewState();
}

class _OwnerProfileViewState extends ConsumerState<OwnerProfileView> {

  SizedBox gap = const SizedBox(height: 15);

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
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

  @override
  void dispose() {
    super.dispose();

    _fullNameController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void _clearControllers() {
    _confirmPasswordController.clear();
    _passwordController.clear();
  }

  void _updateDetials() {
    if (_confirmPasswordController.text.trim() ==
        _passwordController.text.trim()) {
      UpdateRestaurantEntity updatedRestaurantEntity = UpdateRestaurantEntity(
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        fullName: _fullNameController.text.trim(),
        contact: _contactController.text.trim(),
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _clearControllers();

      ref.watch(restaurantViewModelProvider.notifier).updateUserAndRestaurant(
          restaurantEntity: updatedRestaurantEntity, context: context);
    } else {
      _clearControllers();
      Navigator.pop(context);

      showSnackbarMsg(
          context: context,
          targetTitle: 'Error',
          targetMessage: 'Password and Confrim password do not match',
          type: ContentType.failure);
    }
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
                          controllerName: _nameController,
                          fillColor: const Color.fromARGB(255, 170, 140, 140),
                          fieldName: 'restaurant name',
                          example: 'E.g ABC Restaurant',
                          iconData: FontAwesomeIcons.shop,
                        ),
                        gap,
                        CustomTextFieldFormWidget(
                          controllerName: _locationController,
                          fieldName: 'location',
                          example: 'E.g Street - 4, Place',
                          fillColor: const Color.fromARGB(255, 170, 140, 140),
                          iconData: Icons.location_on,
                        ),
                        gap,
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

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantViewModelProvider);
    _nameController.text = restaurantState.singleRestaurant!.name;
    _locationController.text = restaurantState.singleRestaurant!.location;
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
                // restaurantName: restaurantState.singleRestaurant!.name,
                restaurantName: RestaurantState.restaurantEntity!.name,
                userFullName:
                    'Owned by ${restaurantState.singleRestaurant!.ownerName}',
                contact: AuthState.userEntity!.contact,
                // contact: RestaurantState.restaurantEntity!.contact,
                email: AuthState.userEntity!.email,
                // location: restaurantState.singleRestaurant!.location,
                location: RestaurantState.restaurantEntity!.location,
                gap: gap,
                reservationNum:
                    RestaurantState.restaurantEntity!.reservations!.length,
                reviewsNum: RestaurantState.restaurantEntity!.reviews!.length,
                customOnPressed: () {
                  _modalForCamera();
                },
              ),
              gap,
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoute.ownerAddMenuViewRoute);
                },
                child: const ProfileTextWidget(
                  text: 'Menu Card',
                  fontSize: 16,
                ),
              ),
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
                          // delete the acount
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
