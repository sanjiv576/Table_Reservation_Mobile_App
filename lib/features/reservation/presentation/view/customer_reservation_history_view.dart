import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../config/router/app_route.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/widget/custom_appbar_widget.dart';
import '../../../../core/common/widget/show_dialog_box.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../../domain/entity/reservation_entity.dart';
import '../viewmodel/reservation_viewmodel.dart';

// final reservationListProvider =
//     StateProvider<List<ReservationEntity>>((ref) => []);

class CustomerReservationHistoryView extends ConsumerWidget {
  CustomerReservationHistoryView({super.key});

  List<ReservationEntity> _reservationsList = [];

  Future<void> _loadData(ref, context) async {
    try {
      final reservationState = await ref.watch(reservationViewModelProvider);
      _reservationsList = reservationState.allReservations!;

      showSnackbarMsg(
          context: context,
          targetTitle: 'Refresh',
          targetMessage: 'Refreshing...',
          type: ContentType.success);
    } catch (err) {
      showSnackbarMsg(
          context: context,
          targetTitle: 'Error',
          targetMessage: err.toString(),
          type: ContentType.failure);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationState = ref.watch(reservationViewModelProvider);
    _reservationsList = reservationState.allReservations!;

    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Reservation History',
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _loadData(ref, context);
        },
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.edit, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Edit - double tap',
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Icon(Icons.delete, color: Colors.white),
                SizedBox(width: 10),
                Text('Delete - long press or tap X',
                    style: TextStyle(color: Colors.white))
              ],
            ),
            const SizedBox(height: 10),
            if (reservationState.isLoading) ...{
              const Center(
                child: CircularProgressIndicator(),
              ),
            } else if (reservationState.error != null) ...{
              Expanded(
                  child: Center(
                child: Text(
                  'Error: ${reservationState.error!}',
                  style: const TextStyle(color: Colors.white),
                ),
              ))
            } else if (_reservationsList.isEmpty) ...{
              Expanded(
                flex: 3,
                child: Center(
                  child: Text('No Data Found',
                      style:
                          kTextStyle.copyWith(fontSize: 20, color: Colors.red)),
                ),
              )
            } else if (reservationState.allReservations != []) ...{
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () {
                        String textMessage =
                            'Do you sure want to delete this reservation of ${_reservationsList[index].restaurantName}?';

                        showMyDialogBox(textMessage, () {
                          ref
                              .watch(reservationViewModelProvider.notifier)
                              .deleteReservation(
                                _reservationsList[index],
                                context,
                              );

                          ref
                              .watch(reservationViewModelProvider.notifier)
                              .getAllUserReservations();

                          Navigator.pop(context);
                        }, context);
                      },
                      onDoubleTap: () {
                        Navigator.pushNamed(
                            context, AppRoute.customerReservationRoute,
                            arguments: {
                              'reservation': _reservationsList[index],
                              'restaurant': null
                            });
                      },
                      child: Container(
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
                                  // 'https://ychef.files.bbci.co.uk/1600x900/p09xq72k.jpg',
                                  '${ApiEndpoints.imageUrl}${_reservationsList[index].restaurantPicture}',
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(0),
                              title: Text(
                                reservationState
                                    .allReservations![index].restaurantName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    String textMessage =
                                        'Do you sure want to delete this reservation of ${_reservationsList[index].restaurantName}?';

                                    showMyDialogBox(textMessage, () {
                                      ref
                                          .watch(reservationViewModelProvider
                                              .notifier)
                                          .deleteReservation(
                                            reservationState
                                                .allReservations![index],
                                            context,
                                          );

                                      ref
                                          .watch(reservationViewModelProvider
                                              .notifier)
                                          .getAllUserReservations();

                                      Navigator.pop(context);
                                    }, context);
                                  },
                                  icon: const Icon(
                                    Icons.close_sharp,
                                    color: Colors.black,
                                    size: 35,
                                  )),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    children: [
                                      const ListTile(
                                        leading: Icon(
                                            FontAwesomeIcons.locationDot,
                                            color: Colors.black),
                                        contentPadding: EdgeInsets.all(0),
                                        title: Text(
                                          'NA',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            FontAwesomeIcons.calendarCheck,
                                            color: Colors.black),
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Text(
                                          reservationState
                                              .allReservations![index].date,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            FontAwesomeIcons.peopleGroup,
                                            color: Colors.black),
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Text(
                                          '${_reservationsList[index].numberOfDinners} people',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                            Icons.restaurant_menu,
                                            color: Colors.black),
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Text(
                                          'Order: ${_reservationsList[index].isFoodOrder ? 'Yes' : 'No'}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          FontAwesomeIcons.clock,
                                          color: Colors.black,
                                        ),
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Text(
                                          reservationState
                                              .allReservations![index].time
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.outdoor_grill,
                                          color: Colors.black,
                                        ),
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Text(
                                          'Type: ${_reservationsList[index].dinnerPlace}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: _reservationsList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: Colors.transparent,
                    );
                  },
                ),
              ),
            }
          ],
        ),
      ),
    );
  }
}
