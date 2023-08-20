import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../../config/themes/constant.dart';
import '../../../../core/common/widget/custom_appbar_widget.dart';
import '../../../../core/common/widget/custom_textformfield_widget.dart';
import '../../../../core/common/widget/device_size.dart';
import '../../domain/entity/food_menu_entity.dart';
import '../viewmodel/food_menu_viewmodel.dart';

final selectedFoodTypeProvider = StateProvider<String>((ref) => '');
final showUpdateBtnProvider = StateProvider<bool>((ref) => false);

class OwnerAddMenuView extends ConsumerStatefulWidget {
  const OwnerAddMenuView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OwnerAddMenuViewState();
}

class _OwnerAddMenuViewState extends ConsumerState<OwnerAddMenuView> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();

  final SizedBox _gap = const SizedBox(height: 15);
  final List<String> _foodTypesList = ['non-veg', 'veg'];
  String? targetedFoodItemId;

  // since the background color is white , so text and icon color is black
  Color activeColor = Colors.black;

  @override
  void dispose() {
    super.dispose();
    _itemNameController.dispose();
    _itemPriceController.dispose();
  }

  void _addFoodItem() {
    FoodMenuEntity newFoodItem = FoodMenuEntity(
      foodName: _itemNameController.text.trim(),
      foodPrice: double.parse(_itemPriceController.text.trim()),
      foodType: ref.watch(selectedFoodTypeProvider),
    );
    ref
        .watch(foodMenuViewModelProvider.notifier)
        .addFoodItem(foodItem: newFoodItem);

    _resetControllers();
  }

  void _editFoodItem(String foodItemId, FoodMenuEntity editedFoodItem) {
    // call viewmodel function
    ref
        .watch(foodMenuViewModelProvider.notifier)
        .updateAFoodItem(foodItemId: foodItemId, foodItem: editedFoodItem);

    // false the showUpdateBtnProviver
    ref.watch(showUpdateBtnProvider.notifier).state = false;

    // clear text fields
    _resetControllers();
    // back
    Navigator.pop(context);
  }

  // void _deleteFoodItem(int index, FoodMenuState foodMenuState) {
  //   print(
  //       'Delete - Index : $index, Food name: ${foodMenuState.foodMenu[index].foodName}');
  // }

  void _resetControllers() {
    _itemNameController.clear();
    _itemPriceController.clear();
    ref.watch(selectedFoodTypeProvider.notifier).state = '';
  }

  void _showModalWidget() {
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
                  height: DeviceSize.height * .6,
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        CustomTextFieldFormWidget(
                          controllerName: _itemNameController,
                          fillColor: const Color(0xFFD9D9D9),
                          fieldName: 'food name',
                          example: 'E.g Pork Bun',
                          iconData: Icons.fastfood_rounded,
                        ),
                        _gap,
                        CustomTextFieldFormWidget(
                          controllerName: _itemPriceController,
                          keyboardTextType: TextInputType.number,
                          fieldName: 'price',
                          example: 'E.g 600',
                          fillColor: const Color(0xFFD9D9D9),
                          iconData: Icons.price_change,
                        ),
                        _gap,
                        DropdownButtonFormField(
                          validator: (value) {
                            if (value == null) {
                              return 'Please select food type';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Choose food type',
                            iconColor: Colors.black,
                            fillColor: const Color(0xFFD9D9D9),
                            prefixIcon: const Icon(
                              FontAwesomeIcons.leaf,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          items: _foodTypesList
                              .map(
                                (foodType) => DropdownMenuItem(
                                  value: foodType,
                                  child: Text(foodType),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            ref.watch(selectedFoodTypeProvider.notifier).state =
                                value!;
                          },
                        ),
                        _gap,
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (ref.watch(showUpdateBtnProvider)) {
                                    FoodMenuEntity editedFoodItem =
                                        FoodMenuEntity(
                                      foodName: _itemNameController.text.trim(),
                                      foodPrice: double.parse(
                                          _itemPriceController.text.trim()),
                                      foodType:
                                          ref.watch(selectedFoodTypeProvider),
                                    );

                                    _editFoodItem(
                                        targetedFoodItemId!, editedFoodItem);
                                  } else {
                                    _addFoodItem();
                                  }
                                }
                              },
                              child: Text(ref.watch(showUpdateBtnProvider)
                                  ? 'Update'
                                  : 'Save')),
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
    // int listSize = ref.watch(foodMenuProvider).length;
    var foodMenuState = ref.watch(foodMenuViewModelProvider);
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Food Menu'),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showModalWidget();
          },
          elevation: 12,
          splashColor: Colors.red,
          backgroundColor: Colors.purple,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: DeviceSize.width * .1,
          vertical: DeviceSize.height * .01,
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'List of Food Items',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            _gap,
            const Row(
              children: [
                Icon(Icons.edit, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Edit - single tap',
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Icon(Icons.delete, color: Colors.white),
                SizedBox(width: 10),
                Text('Delete - double tap',
                    style: TextStyle(color: Colors.white))
              ],
            ),
            _gap,
            if (foodMenuState.isLoading) ...{
              const Center(
                child: CircularProgressIndicator(),
              ),
            } else if (foodMenuState.error != null) ...{
              Text(
                'Error: ${foodMenuState.error!}',
                style: const TextStyle(color: Colors.red),
              ),
            } else if (foodMenuState.foodMenu.isEmpty) ...{
              Expanded(
                flex: 3,
                child: Center(
                  child: Text('No Food Items Available',
                      style: kTextStyle.copyWith(
                          fontSize: 20, color: Colors.white)),
                ),
              )
            } else if (foodMenuState.foodMenu.isNotEmpty) ...{
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print(
                            'Food item id is : ${foodMenuState.foodMenu[index].foodMenuId}}');
                        // store fooidItemId
                        targetedFoodItemId =
                            foodMenuState.foodMenu[index].foodMenuId;

                        // show update button
                        ref.watch(showUpdateBtnProvider.notifier).state = true;

                        // fill text fields which old data
                        _itemNameController.text =
                            foodMenuState.foodMenu[index].foodName;

                        _itemPriceController.text =
                            foodMenuState.foodMenu[index].foodPrice.toString();

                        ref.watch(selectedFoodTypeProvider.notifier).state =
                            foodMenuState.foodMenu[index].foodType;

                        // show bottom sheet modal
                        _showModalWidget();
                      },
                      onDoubleTap: () {
                        // show dialog/alert box
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Delete",
                          desc:
                              "Are you sure to delete ${foodMenuState.foodMenu[index].foodName}?",
                          buttons: <DialogButton>[
                            DialogButton(
                              onPressed: () => Navigator.pop(context),
                              color: const Color.fromRGBO(218, 99, 109, 1),
                              child: const Text(
                                "No",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            DialogButton(
                              onPressed: () {
                                // delete the item
                                ref
                                    .watch(foodMenuViewModelProvider.notifier)
                                    .deleteAFoodItem(
                                      foodItem: foodMenuState.foodMenu[index],
                                    );
                                // back
                                Navigator.pop(context);
                              },
                              gradient: const LinearGradient(colors: [
                                Color.fromRGBO(109, 173, 167, 1),
                                Color.fromRGBO(52, 138, 199, 1.0)
                              ]),
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )
                          ],
                        ).show();
                        // _deleteFoodItem(index, foodMenuState);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            Text(
                              // __foodItemList[index].foodName.toString(),
                              // '${ref.watch(foodMenuProvider)[index % listSize].foodName} - ${ref.watch(foodMenuProvider)[index % listSize].foodType}',
                              '${foodMenuState.foodMenu[index].foodName} - ${foodMenuState.foodMenu[index].foodType}',
                              style: kBoldPoppinsTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: activeColor),
                            ),
                            const Spacer(),
                            Text(
                              // 'Rs. ${ref.watch(foodMenuProvider)[index % listSize].foodPrice}',
                              'Rs. ${foodMenuState.foodMenu[index].foodPrice}',
                              style: kBoldPoppinsTextStyle.copyWith(
                                  fontSize: 14, color: activeColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: foodMenuState.foodMenu.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 20,
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
