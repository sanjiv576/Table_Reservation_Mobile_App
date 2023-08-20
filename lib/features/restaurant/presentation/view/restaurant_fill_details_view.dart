import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_reservation_mobile_app/features/auth/presentation/state/auth_state.dart';
import 'package:table_reservation_mobile_app/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:table_reservation_mobile_app/features/restaurant/presentation/viewmodel/restaurant_viewmodel.dart';

import '../../../../core/common/widget/custom_textformfield_widget.dart';
import '../../../../core/common/widget/device_size.dart';
import '../../../../core/common/widget/profile_widget.dart';
import '../../../auth/presentation/viewmodel/auth_view_model.dart';

class RestaurantFillDetailsView extends ConsumerStatefulWidget {
  const RestaurantFillDetailsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RestaurantFillDetailsViewState();
}

class _RestaurantFillDetailsViewState
    extends ConsumerState<RestaurantFillDetailsView> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  void _disposeControllers() {
    _nameController.dispose();
    _locationController.dispose();
  }

  _continueSubmit({required BuildContext context}) {
    if (_formKey.currentState!.validate()) {
      RestaurantEntity newRestaurant = RestaurantEntity(
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        contact: AuthState.userEntity!.contact,
        ownerName: '',
        ownerId: '',
      );

      // add restaurant in the server
      ref
          .watch(restaurantViewModelProvider.notifier)
          .createARestaurant(newRestaurant, context);
    }
  }

  SizedBox gap = const SizedBox(height: 40);
  final _formKey = GlobalKey<FormState>();

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
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.read(restaurantViewModelProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
                vertical: DeviceSize.height * .1,
                horizontal: DeviceSize.width * .1),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ProfileWidget(
                    radius: 80,
                    onPressed: () {
                      _modalForCamera();
                    },
                    // userBackgroundImage: const NetworkImage(
                    //     'https://ychef.files.bbci.co.uk/1600x900/p09xq72k.jpg'),
                    userBackgroundImage: _img != null
                        ? FileImage(_img!)
                        : const AssetImage(
                                'assets/images/profile/default_restaurant_image.jpg')
                            as ImageProvider,
                  ),
                  gap,
                  CustomTextFieldFormWidget(
                    controllerName: _nameController,
                    fieldName: 'restaurant name',
                    example: 'E.g ABC Restaurant',
                    iconData: FontAwesomeIcons.shop,
                  ),
                  gap,
                  CustomTextFieldFormWidget(
                    controllerName: _locationController,
                    fieldName: 'location',
                    example: 'E.g Street - 4, Place',
                    iconData: Icons.location_on,
                  ),
                  gap,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          _continueSubmit(context: context);
                        },
                        child: const Text('CONTINUE')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
