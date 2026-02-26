import 'package:flutter/material.dart';

import '../constants/common.dart';

ImageProvider<Object> imageProduct(productID) {
  switch (productID) {
    case Common.ID_KENO:
      return const AssetImage('assets/img/keno.png');
    case Common.ID_MEGA:
      return const AssetImage('assets/img/mega.png');
    case Common.ID_POWER:
      return const AssetImage('assets/img/power.png');
    case Common.ID_MAX3D:
      return const AssetImage('assets/img/max3dtrang.png');
    case Common.ID_MAX3D_PLUS:
      return const AssetImage('assets/img/max3dcongtrang.png');
    case Common.ID_MAX3D_PRO:
      return const AssetImage('assets/img/max_3dpro.png');
    default:
      return const AssetImage('assets/img/mienbac.png');
  }
}
