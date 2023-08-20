import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/config/constants/api_endpoints.dart';
import 'package:table_reservation_mobile_app/core/common/widget/device_size.dart';
import 'package:table_reservation_mobile_app/features/reservation/domain/entity/reservation_entity.dart';

import '../../../../config/router/app_route.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/widget/custom_appbar_widget.dart';

class OwnerReservationRequestView extends ConsumerStatefulWidget {
  const OwnerReservationRequestView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OwnerReservationRequestViewState();
}

class _OwnerReservationRequestViewState
    extends ConsumerState<OwnerReservationRequestView> {
  ReservationEntity? _reservationEntity;

  Color activeTextColor = Colors.black;

  @override
  void didChangeDependencies() {
    _reservationEntity =
        ModalRoute.of(context)!.settings.arguments as ReservationEntity?;

    super.didChangeDependencies();
  }

  _callNow() async {
    String contact = '9812345678';
    await FlutterPhoneDirectCaller.callNumber(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'New Reservation',
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: DeviceSize.width * .1,
              vertical: DeviceSize.height * .1),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.pink,
                  backgroundImage: NetworkImage(
                    // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScYe4_BdUB6SgdhwTBEAQ7ZEciwTlxXLQJOg&usqp=CAU',
                    ApiEndpoints.imageUrl + _reservationEntity!.userPicture!,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  _reservationEntity!.userName.toString(),
                  style: kBoldPoppinsTextStyle.copyWith(color: activeTextColor),
                ),
                const SizedBox(height: 30),
                Text(
                  'wants to reserve tables for ${_reservationEntity!.numberOfDinners} people at ${_reservationEntity!.dinnerPlace} on ${_reservationEntity!.date} at ${_reservationEntity!.time}.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      color: activeTextColor),
                ),
                const SizedBox(height: 30),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                // Expanded(
                //   flex: 2,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.red,
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(8))),
                //     onPressed: () {
                //       print('Declined got pressed');
                //     },
                //     child: const Text(
                //       'DECLINE',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),
                //     Expanded(child: Container()),
                //     Expanded(
                //       flex: 2,
                //       child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.green,
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(8))),
                //         onPressed: () {
                //           print('Accept got pressed');
                //         },
                //         child: const Text(
                //           'ACCEPT',
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF093F68),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppRoute.ownerFoodOrderRoute);
                    },
                    child: const Text(
                      'VIEW ORDER',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF093F68),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    onPressed: () {
                      _callNow();
                    },
                    child: const Text(
                      'CALL NOW',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
