import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../constants/common.dart';
import 'color_lot.dart';
import 'common.dart';

Widget headBalance(int balance, String mode, String mobileNumber) {
  if (mode == Common.ANDROID_MODE_UPLOAD &&
      mobileNumber.isNotEmpty &&
      mobileNumber != Common.MOBILE_OFF) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Icon(Ionicons.wallet_outline,
                size: 20, color: ColorLot.ColorPrimary),
            Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text("Số dư"),
            )
          ],
        ),
        Text(
          formatAmountD(balance),
          style: const TextStyle(
              color: ColorLot.ColorPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600),
        )
      ],
    );
  } else {
    return const SizedBox.shrink();
  }
}
