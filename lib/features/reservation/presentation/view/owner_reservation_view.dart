import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../config/router/app_route.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/widget/custom_appbar_widget.dart';
import '../viewmodel/reservation_viewmodel.dart';

class OwnerReservationView extends ConsumerWidget {
  OwnerReservationView({super.key});

  // since the background color is white , so text and icon color is black
  Color activeColor = Colors.black;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationState = ref.watch(reservationViewModelProvider);
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'New Reservation',
      ),
      body: Column(
        children: [
          if (reservationState.isLoading) ...{
            const Center(
              child: CircularProgressIndicator(),
            ),
          } else if (reservationState.error != null) ...{
            Expanded(
                child: Center(
              child: Text(
                'Error: ${reservationState.error!}',
                style: const TextStyle(color: Colors.red),
              ),
            ))
          } else if (reservationState.allReservations!.isEmpty) ...{
            Expanded(
              flex: 3,
              child: Center(
                child: Text('No Reservations Avaialble',
                    style:
                        kTextStyle.copyWith(fontSize: 20, color: Colors.white)),
              ),
            )
          } else if (reservationState.allReservations != []) ...{
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(
                                // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTYnuvAw7_Vgyirya4Od0qjbZjASZKijOh_g&usqp=CAU',
                                '${ApiEndpoints.imageUrl}${reservationState.allReservations![index].userPicture}'),
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            reservationState.allReservations![index].userName!,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: activeColor),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                // ref
                                //     .watch(
                                //         reservationViewModelProvider.notifier)
                                //     .getAReservation(reservationState.allReservations![index], context);

                                // print(reservationState
                                //     .allReservations![index].reservationId);

                                Navigator.pushNamed(context,
                                    AppRoute.ownerReservationRequestRoute,
                                    arguments: reservationState
                                        .allReservations![index]);
                              },
                              icon: const Icon(
                                Icons.remove_red_eye,
                                color: Colors.black,
                                size: 35,
                              )),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(FontAwesomeIcons.locationDot,
                                        color: activeColor),
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(
                                      'NA',
                                      style: TextStyle(
                                          fontSize: 14, color: activeColor),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      FontAwesomeIcons.calendarCheck,
                                      color: activeColor,
                                    ),
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(
                                      reservationState
                                          .allReservations![index].date,
                                      style: TextStyle(
                                          fontSize: 14, color: activeColor),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(FontAwesomeIcons.peopleGroup,
                                        color: activeColor),
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(
                                      '${reservationState.allReservations![index].numberOfDinners} people',
                                      style: TextStyle(
                                          fontSize: 14, color: activeColor),
                                    ),
                                  ),
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.restaurant_menu,
                                        color: activeColor),
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(
                                      'Order: ${reservationState.allReservations![index].isFoodOrder ? 'Yes' : 'No'}',
                                      style: TextStyle(
                                          fontSize: 14, color: activeColor),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(FontAwesomeIcons.clock,
                                        color: activeColor),
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(
                                      reservationState
                                          .allReservations![index].time,
                                      style: TextStyle(
                                          fontSize: 14, color: activeColor),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.outdoor_grill,
                                        color: activeColor),
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(
                                      'Type: ${reservationState.allReservations![index].dinnerPlace}',
                                      style: TextStyle(
                                          fontSize: 14, color: activeColor),
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: reservationState.allReservations!.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: Colors.transparent,
                  );
                },
              ),
            ),
          },
        ],
      ),
    );
  }
}
