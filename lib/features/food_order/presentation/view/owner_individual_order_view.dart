import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/themes/constant.dart';
import '../../../../core/common/widget/custom_appbar_widget.dart';
import '../../../../core/common/widget/device_size.dart';
import '../../domain/entity/food_order_entity.dart';
import '../state/food_order_state.dart';

class OwnerIndividalOrderView extends ConsumerWidget {
  OwnerIndividalOrderView({super.key});

  final TextStyle _textStyle =
      const TextStyle(color: Colors.black, fontSize: 14);

  Color activeColor = Colors.black;
  final FoodOrderEntity? _foodOrder = FoodOrderState.individualFoodOrder;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Food Order',
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: DeviceSize.width * .05,
              vertical: DeviceSize.height * .1),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.pink,
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScYe4_BdUB6SgdhwTBEAQ7ZEciwTlxXLQJOg&usqp=CAU',
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  _foodOrder!.userName,
                  style: kBoldPoppinsTextStyle.copyWith(color: activeColor),
                ),
                const SizedBox(height: 30),
                Text(
                  'Ordered',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, fontFamily: 'Poppins', color: activeColor),
                ),
                const SizedBox(height: 30),
                DataTable(
                    sortAscending: true,
                    border: const TableBorder(
                      top: BorderSide(width: 3),
                      right: BorderSide(width: 3),
                      left: BorderSide(width: 3),
                      bottom: BorderSide(width: 3),
                    ),
                    // border: TableBorder.all(),
                    columns: <DataColumn>[
                      DataColumn(
                          label: Expanded(
                              child: Text(
                        'Food',
                        style: _textStyle,
                      ))),
                      DataColumn(
                          label: Expanded(
                            child: Text(
                              'Quantity',
                              style: _textStyle,
                            ),
                          ),
                          numeric: true),
                      DataColumn(
                          label: Expanded(
                            child: Text(
                              'Price',
                              style: _textStyle,
                            ),
                          ),
                          numeric: true),
                    ],
                    rows: <DataRow>[
                      for (int i = 0; i < _foodOrder!.items.length; i++) ...{
                        DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(
                                _foodOrder!.items[i].foodName,
                                style: _textStyle,
                              ),
                            ),
                            DataCell(
                              Text(
                                _foodOrder!.items[i].quantity.toString(),
                                style: _textStyle,
                              ),
                            ),
                            DataCell(
                              Text(
                                '${_foodOrder!.items[i].price * _foodOrder!.items[i].quantity}',
                                style: _textStyle,
                              ),
                            ),
                          ],
                        ),
                      }
                    ]),
                const SizedBox(height: 30),
                Text(
                  'Total Amount is Rs ${_foodOrder!.totalAmount}',
                  style: _textStyle.copyWith(fontWeight: FontWeight.bold),
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Expanded(
                //       flex: 2,
                //       child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.red,
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(8))),
                //         onPressed: () {
                //           print('Declined got pressed');
                //         },
                //         child: const Text(
                //           'DECLINE',
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
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
                // const SizedBox(height: 10),
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: const Color(0xFF093F68),
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(8))),
                //     onPressed: () {
                //       print('Message button got pressed');
                //     },
                //     child: const Text(
                //       'MESSAGE',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
