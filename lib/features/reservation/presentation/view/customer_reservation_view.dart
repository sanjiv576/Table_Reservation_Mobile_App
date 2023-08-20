import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_reservation_mobile_app/features/food_menu/presentation/state/food_menu_state.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../config/router/app_route.dart';
import '../../../../config/themes/app_color_constant.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/provider/is_dark_theme.dart';
import '../../../../core/common/widget/custom_appbar_widget.dart';
import '../../../../core/common/widget/custom_detect_card_widget.dart';
import '../../../../core/common/widget/device_size.dart';
import '../../../../core/common/widget/show_dialog_box.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../../../restaurant/domain/entity/restaurant_entity.dart';
import '../../data/model/pick_date_time.dart';
import '../../domain/entity/reservation_entity.dart';
import '../viewmodel/reservation_viewmodel.dart';
import '../widget/custom_date_time_picker.dart';
import '../widget/custom_iconbutton_widget.dart';

class CustomerReservationView extends ConsumerStatefulWidget {
  const CustomerReservationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerReservationViewState();
}

class _CustomerReservationViewState
    extends ConsumerState<CustomerReservationView> {
  bool edit = false;
  int dinerNum = 1;
  String selectedDate = '';
  String selectedTime = '';
  bool outdoorSelected = false;
  bool indoorSelected = false;
  late bool isDark;
  late Color activeTextColor;

  RestaurantEntity? _restaurantEntity;
  ReservationEntity? _reservationEntity;
  Map<dynamic, dynamic>? arguments;

  @override
  void initState() {
    isDark = ref.read(isDarkThemeProvider);
    activeTextColor = isDark
        ? AppColorConstant.nightTextColor
        : AppColorConstant.dayTextColor;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    arguments =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;

    _reservationEntity = arguments!['reservation'];
    _restaurantEntity = arguments!['restaurant'];

    if (_restaurantEntity == null) {
      setState(() {
        edit = true;
        _insertValues();
      });
    } else {
      // add food menu in the state
      FoodMenuState.restaurantFoodMenu = _restaurantEntity!.foodMenu;
    }

    super.didChangeDependencies();
  }

  _insertValues() {
    dinerNum = _reservationEntity!.numberOfDinners;
    selectedDate = _reservationEntity!.date;
    selectedTime = _reservationEntity!.time;
    outdoorSelected =
        _reservationEntity!.dinnerPlace.toLowerCase() == 'outdoor';
    indoorSelected = _reservationEntity!.dinnerPlace.toLowerCase() == 'indoor';
    selectedPlace = _reservationEntity!.dinnerPlace;
  }

  String? selectedPlace;

  void _submitReservation() {
    ReservationEntity newReservation = ReservationEntity(
      date: selectedDate,
      time: selectedTime,
      numberOfDinners: dinerNum,
      dinnerPlace: selectedPlace.toString(),
      isCancelled: false,
      isModifiedData: false,
      isFoodOrder: false,
      restaurantName:
          _restaurantEntity != null ? _restaurantEntity!.name : 'NA',
      userId: '1',
    );

    ref.watch(reservationViewModelProvider.notifier).createReservation(
        newReservation, _restaurantEntity!.restaurantId!, context);
    showSnackbarMsg(
      context: context,
      targetTitle: 'Success',
      targetMessage: 'Reservation successfully',
      type: ContentType.success,
    );

    Map<String, String> reservationDetailsMap = {
      'dinerNum': dinerNum.toString(),
      'time': selectedTime.toString(),
      'date': selectedDate.toString(),
      'place': selectedPlace.toString().toLowerCase(),
    };
    _resetProviders();
    Navigator.popAndPushNamed(context, AppRoute.customerConfirmationViewRoute,
        arguments: reservationDetailsMap);
  }

  void _submitEditReservation() {
    ReservationEntity editedReservation = ReservationEntity(
      date: selectedDate,
      time: selectedTime,
      numberOfDinners: dinerNum,
      dinnerPlace: selectedPlace.toString(),
      isCancelled: false,
      isModifiedData: false,
      isFoodOrder: false,
      restaurantName: '',
      userId: '1',
      reservationId: '1',
    );

// call update reservation from viewmodel
    ref.watch(reservationViewModelProvider.notifier).updateReservation(
        editedReservation, _reservationEntity!.reservationId!, context);

    _resetProviders();
  }

  void _getDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(
          2024), // allow to add today or tomorrow days but not past date
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        selectedDate = PickDateTime.convertDate(date: pickedDate);
      });
    });
  }

//  function that allows to pick time from UI
  void _getTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) return;

      setState(() {
        selectedTime = PickDateTime.convertTime(time: pickedTime);
      });
    });
  }

  void _reservationSubmit() {
    if ((indoorSelected || outdoorSelected)) {
      selectedPlace = indoorSelected ? 'Indoor' : 'Outdoor';

      String textMessage = 'Do you sure want to reserve table ?';

      showMyDialogBox(textMessage, () {
        _submitReservation();
      }, context);
    } else {
      showSnackbarMsg(
        context: context,
        targetTitle: 'Missing',
        targetMessage: 'Something is missing date, time or dinner place.',
        type: ContentType.failure,
      );
    }
  }

  void _editSubmit() {
    if ((indoorSelected || outdoorSelected)) {
      selectedPlace = indoorSelected ? 'Indoor' : 'Outdoor';

      // print('Diner number: $_dinerNum\nDate: ${_selectedDate!}\nTime: ${_selectedTime!}\nPlaceType: $selectedPlace');
      String textMessage = 'Do you sure want to reserve table ?';

      showMyDialogBox(textMessage, () {
        _submitEditReservation();
      }, context);
    } else {
      showSnackbarMsg(
        context: context,
        targetTitle: 'Missing',
        targetMessage: 'Something is missing date, time or dinner place.',
        type: ContentType.failure,
      );
    }
  }

  String url =
      'https://hips.hearstapps.com/housebeautiful.cdnds.net/17/42/2048x1024/landscape-1508239345-family-eating-lunch-close-up-of-food-on-wooden-table.jpg?resize=1200:*';

  void _resetProviders() {
    setState(() {
      dinerNum = 1;
      outdoorSelected = false;
      indoorSelected = false;
      selectedDate = '';
      selectedTime = '';
      edit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservationState = ref.watch(reservationViewModelProvider);
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Reservation'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    // '',
                    _restaurantEntity != null
                        ? ApiEndpoints.imageUrl + _restaurantEntity!.picture!
                        : url,
                  ),
                  backgroundColor: Colors.white,
                ),
                title: Text(
                  _restaurantEntity != null
                      ? _restaurantEntity!.name
                      : _reservationEntity!.restaurantName,
                  style: kBoldPoppinsTextStyle.copyWith(
                      fontSize: 20, color: activeTextColor),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.clear,
                    color: activeTextColor,
                  ),
                ),
              ),
              // gap,
              const SizedBox(height: 15),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/png/$dinerNum.png',
                  fit: BoxFit.fill,
                ),
              ),
              // gap,
              const SizedBox(height: 15),
              Text(
                'How many diners ?',
                style: TextStyle(
                    color: activeTextColor,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 90,
                    width: DeviceSize.width / 3,
                    child: Row(
                      children: [
                        Text(
                          dinerNum.toString(),
                          style: TextStyle(
                            color: activeTextColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'people',
                          style: kBoldPoppinsTextStyle.copyWith(
                            color: activeTextColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    width: DeviceSize.width / 3,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        RoundIconButton(
                          icon: FontAwesomeIcons.minus,
                          onPressedCustom: dinerNum > 1
                              ? () {
                                  setState(() {
                                    dinerNum--;
                                  });
                                }
                              : null,
                        ),
                        const SizedBox(width: 15),
                        RoundIconButton(
                          icon: FontAwesomeIcons.plus,
                          onPressedCustom: dinerNum < 6
                              ? () {
                                  setState(() {
                                    dinerNum++;
                                  });
                                }
                              : null,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // gap,
              const SizedBox(height: 15),

              Row(
                children: [
                  CustomDateTimePickerWidget(
                    // gap: gap,
                    gap: const SizedBox(height: 15),
                    onTap: _getDatePicker,
                    textTitle: 'Pick Date',
                    dateTimeValue: selectedDate,
                  ),
                  const Spacer(),
                  CustomDateTimePickerWidget(
                    // gap: gap,
                    gap: const SizedBox(height: 15),
                    onTap: _getTimePicker,
                    textTitle: 'Pick Time',
                    dateTimeValue: selectedTime,
                  ),
                ],
              ),
              Text(
                'Where do you want to eat ?',
                style: kBoldPoppinsTextStyle.copyWith(
                  color: activeTextColor,
                  fontSize: 20,
                ),
              ),
              // gap,
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomDetectCardWidget(
                    text: 'Outdoor',
                    iconData: Icons.outdoor_grill,
                    // color: ref.watch(outdoorSelectedProvider)
                    color: outdoorSelected
                        ? Colors.white
                        : const Color.fromARGB(255, 73, 21, 100),
                    onTap: () {
                      setState(() {
                        outdoorSelected = true;
                        indoorSelected = false;
                      });
                    },
                  ),
                  CustomDetectCardWidget(
                    text: 'Indoor',
                    iconData: FontAwesomeIcons.houseChimneyUser,
                    color: indoorSelected
                        ? Colors.white
                        : const Color.fromARGB(255, 73, 21, 100),
                    onTap: () {
                      setState(() {
                        outdoorSelected = false;
                        indoorSelected = true;
                      });
                    },
                  ),
                ],
              ),
              // gap,
              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (edit) {
                      _editSubmit();
                    } else {
                      _reservationSubmit();
                    }
                  },
                  child: Text(
                    edit ? 'Edit Reservation' : 'Table Reservation',
                    style: kBoldPoppinsTextStyle,
                  ),
                ),
              ),
              // gap,
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
