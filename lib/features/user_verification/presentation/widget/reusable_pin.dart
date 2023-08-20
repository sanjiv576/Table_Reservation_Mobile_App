import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReusablePinput extends StatelessWidget {
  const ReusablePinput(
      {super.key, required this.onChangedFunc, required this.controllerName});

  final onChangedFunc;
  final controllerName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 70,
      child: TextFormField(
        onChanged: onChangedFunc,
        controller: controllerName,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        style: Theme.of(context).textTheme.headlineSmall,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
