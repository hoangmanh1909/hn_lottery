// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';

showProcess(BuildContext context) {
  final spinkit = SpinKitDualRing(color: ColorLot.ColorPrimary);

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return spinkit;
    },
  );
}
