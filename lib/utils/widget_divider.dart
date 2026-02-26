import 'package:flutter/material.dart';

Widget dividerLot() {
  return Column(
    children: [
      const SizedBox(
        height: 8,
      ),
      Divider(
        height: 1,
        color: Colors.grey[200],
      ),
      const SizedBox(
        height: 8,
      )
    ],
  );
}
