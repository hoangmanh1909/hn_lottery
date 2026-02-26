import 'package:flutter/material.dart';

import 'dimen.dart';

Widget textBold(text, Color color) {
  return Text(
    text,
    style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: Dimen.fontSizeDefault,
        color: color),
  );
}
