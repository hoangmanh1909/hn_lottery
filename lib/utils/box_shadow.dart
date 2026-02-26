import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';

BoxShadow boxShadow() {
  return const BoxShadow(
      color: ColorLot.ColorShadow, blurRadius: 15.0, offset: Offset(0.0, 0.75));
}
