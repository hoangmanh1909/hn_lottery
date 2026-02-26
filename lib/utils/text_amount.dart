import 'package:flutter/material.dart';

import 'color_lot.dart';

Widget textAmount(text) {
  return Text(text,
      style: const TextStyle(
          color: ColorLot.ColorPrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold));
}

Widget textAmountSize(text, double? fontSize) {
  return Text(text,
      style: TextStyle(
          color: ColorLot.ColorPrimary,
          fontSize: fontSize,
          fontWeight: FontWeight.bold));
}
