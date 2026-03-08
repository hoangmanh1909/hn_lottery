import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:lottery_flutter_application/models/radio_model.dart';
import 'package:lottery_flutter_application/models/xskt_model.dart';

import '../constants/common.dart';

String formatAmountD(dynamic amount) {
  if (amount != null) {
    return "${intl.NumberFormat.decimalPattern().format(amount)}đ";
  } else {
    return "0đ";
  }
}

String formatAmount(dynamic amount) {
  if (amount != null) {
    return intl.NumberFormat.decimalPattern().format(amount);
  } else {
    return "";
  }
}

String convertIntToString(double i) {
  if (i == 0) {
    return "";
  }
  String d = i.toStringAsFixed(0);
  if (d.length > 3) {
    String s = d.substring(0, d.length - 3);
    return "${intl.NumberFormat.decimalPattern().format(int.parse(s))}k";
  } else {
    return "${d}k";
  }
}

String convertIntToString1(double i) {
  if (i == 0) {
    return "";
  }
  String d = i.toStringAsFixed(0);
  if (d.length > 3) {
    String s = d.substring(0, d.length - 3);
    return intl.NumberFormat.decimalPattern().format(int.parse(s));
  } else {
    return d;
  }
}

String getCurrentDateManual() {
  DateTime now = DateTime.now();

  List<String> weekdays = [
    "Thứ Hai",
    "Thứ Ba",
    "Thứ Tư",
    "Thứ Năm",
    "Thứ Sáu",
    "Thứ Bảy",
    "Chủ Nhật"
  ];

  String dayName = weekdays[now.weekday - 1];
  String dateStr = "${now.day}/${now.month}/${now.year}";

  return "$dayName, $dateStr";
}

String getDayOfWeekVi(String dayEn) {
  switch (dayEn) {
    case "Monday":
      return "Thứ 2";
    case "Tuesday":
      return "Thứ 3";
    case "Wednesday":
      return "Thứ 4";
    case "Thursday":
      return "Thứ 5";
    case "Friday":
      return "Thứ 6";
    case "Saturday":
      return "Thứ 7";
    case "Sunday":
      return "Chủ nhật";
    default:
      return "N/A";
  }
}

String getProductName(int productID) {
  switch (productID) {
    case Common.ID_KENO:
      return "Keno";
    case Common.ID_DIENTOAN_636:
      return "Điện toán 6x36";
    case Common.ID_MAX3D:
      return "Max 3D";
    case Common.ID_MAX3D_PLUS:
      return "Max 3D Cộng";
    case Common.ID_MAX3D_PRO:
      return "Max 3D Pro";
    case Common.ID_MEGA:
      return "Mega 6/45";
    case Common.ID_POWER:
      return "Power 6/55";
    case Common.ID_LOTO234:
      return "Lô tô 234 cặp số";
    case Common.ID_LOTO235:
      return "Lô tô 235 số";
    case Common.ID_LOTTO_535:
      return "Lotto 5/35";
    default:
      return "N/A";
  }
}

String padLeftTwo(int n) => n.toString().padLeft(2, '0');

copyClipboard(text, BuildContext context) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.fixed,
      content: Text("Đã sao chép $text"),
      backgroundColor: Colors.black,
    ));
  }
}

DateTime dayPower() {
  final date = DateTime.now();
  var h = date.hour;
  var d = date.weekday;
  var m = date.minute;
  var s = date.second;
  var day = 0;
  switch (d) {
    case 7:
      day = 2;
      break;
    case 1:
      day = 1;
      break;
    case 2:
      if (h > 17) {
        day = 2;
      } else {
        day = 0;
      }
      break;
    case 3:
      day = 1;
      break;
    case 4:
      if (h > 17) {
        day = 2;
      } else {
        day = 0;
      }
      break;
    case 5:
      day = 1;
      break;
    case 6:
      if (h > 17) {
        day = 3;
      } else {
        day = 0;
      }
      break;
    default:
      break;
  }

  h = 18 - (h + 1);
  var newDate =
      date.add(Duration(days: day, hours: h, minutes: 60 - m, seconds: 60 - s));
  return newDate;
}

DateTime dayMega() {
  final date = DateTime.now();
  var h = date.hour;
  var d = date.weekday;
  var m = date.minute;
  var s = date.second;
  var day = 0;
  switch (d) {
    case 7:
      if (h > 17) {
        day = 3;
      } else {
        day = 0;
      }
      break;
    case 3:
    case 5:
      if (h > 17) {
        day = 2;
      } else {
        day = 0;
      }
      break;
    case 1:
      day = 2;
      break;
    case 2:
      day = 1;
      break;
    case 4:
      day = 1;
      break;
    case 6:
      day = 1;
      break;
    default:
      break;
  }
  h = 18 - (h + 1);
  var newDate =
      date.add(Duration(days: day, hours: h, minutes: 60 - m, seconds: 60 - s));
  return newDate;
}

DateTime dayMax3d() {
  final date = DateTime.now();
  var h = date.hour;
  var d = date.weekday;
  var m = date.minute;
  var s = date.second;
  var day = 0;
  switch (d) {
    case 7:
      day = 1;
      break;
    case 1:
      if (h > 17) {
        day = 2;
      } else {
        day = 0;
      }
      break;
    case 2:
      day = 1;
      break;
    case 3:
      if (h > 17) {
        day = 2;
      } else {
        day = 0;
      }
      break;
    case 4:
      day = 1;
      break;
    case 5:
      if (h > 17) {
        day = 3;
      } else {
        day = 0;
      }
      break;
    case 6:
      day = 2;
      break;
    default:
      break;
  }
  h = 18 - (h + 1);
  var newDate =
      date.add(Duration(days: day, hours: h, minutes: 60 - m, seconds: 60 - s));
  return newDate;
}

DateTime dayFullWeek() {
  final date = DateTime.now();
  var h = date.hour;
  var m = date.minute;
  var s = date.second;
  h = 18 - (h + 1);
  var newDate = date.add(Duration(hours: h, minutes: 60 - m, seconds: 60 - s));
  return newDate;
}

DateTime day636() {
  final date = DateTime.now();
  var h = date.hour;
  var d = date.weekday;
  var m = date.minute;
  var s = date.second;
  var day = 0;
  switch (d) {
    case 7:
      day = 3;
      break;
    case 1:
      day = 2;
      break;
    case 2:
      day = 1;
      break;
    case 3:
      if (h > 16) {
        day = 3;
      } else {
        day = 0;
      }
      break;
    case 4:
      day = 2;
      break;
    case 5:
      day = 1;
      break;
    case 6:
      if (h > 16) {
        day = 5;
      } else {
        day = 0;
      }
      break;
    default:
      break;
  }
  h = 18 - (h + 1);
  var newDate =
      date.add(Duration(days: day, hours: h, minutes: 60 - m, seconds: 60 - s));
  return newDate;
}

int getPriceMega(int bag) {
  int data;
  switch (bag) {
    case 5:
      data = 400000;
      break;
    case 7:
      data = 70000;
      break;
    case 8:
      data = 280000;
      break;
    case 9:
      data = 840000;
      break;
    case 10:
      data = 2100000;
      break;
    case 11:
      data = 4620000;
      break;
    case 12:
      data = 9240000;
      break;
    case 13:
      data = 17160000;
      break;
    case 14:
      data = 30030000;
      break;
    case 15:
      data = 50050000;
      break;
    case 18:
      data = 185640000;
      break;
    default:
      data = 10000;
      break;
  }
  return data;
}

int getPriceByPlayTypeLoto(int playType) {
  int data;
  switch (playType) {
    case 4:
      data = 31;
      break;
    case 6:
      data = 6;
      break;
    case 7:
      data = 21;
      break;
    case 8:
      data = 56;
      break;
    case 9:
      data = 126;
      break;
    case 10:
      data = 252;
      break;
    case 11:
      data = 462;
      break;
    case 12:
      data = 792;
      break;
    case 13:
      data = 1287;
      break;
    case 14:
      data = 2002;
      break;
    case 15:
      data = 3003;
      break;
    default:
      data = 1;
      break;
  }
  return data * 10000;
}

int getPricePower(int bag) {
  int data;
  switch (bag) {
    case 5:
      data = 500000;
      break;
    case 7:
      data = 70000;
      break;
    case 8:
      data = 280000;
      break;
    case 9:
      data = 840000;
      break;
    case 10:
      data = 2100000;
      break;
    case 11:
      data = 4620000;
      break;
    case 12:
      data = 9240000;
      break;
    case 13:
      data = 17160000;
      break;
    case 14:
      data = 30030000;
      break;
    case 15:
      data = 50050000;
      break;
    case 18:
      data = 185640000;
      break;
    default:
      data = 10000;
      break;
  }
  return data;
}

String getOrderStatus(code) {
  String name = "";
  switch (code) {
    case "S":
    case "D":
      name = "Chờ in vé";
      break;
    case "A":
      name = "Đã in vé";
      break;
    case "X":
      name = "Đã hủy";
      break;
    case "P":
      name = "Chờ thanh toán";
      break;
    default:
      name = "N/A";
      break;
  }

  return name;
}

String getNumberMainNameLotto535(int value) {
  int bagValue = value;

  if (bagValue == 5) {
    return "Vé thường";
  } else if (bagValue >= 4 && bagValue <= 15 && bagValue != 5) {
    return "Bao $bagValue số";
  } else {
    return "Không xác định";
  }
}

String getNumberSpecialNameLotto535(int value) {
  int bagValue = value;

  if (bagValue == 1) {
    return "Vé thường";
  } else {
    return "Bao $bagValue số";
  }
}

String getBagName(id) {
  var name = "";
  switch (id) {
    case 6:
      name = "Vé thường";
      break;
    case 5:
      name = "Bao 5";
      break;
    case 7:
      name = "Bao 7";
      break;
    case 8:
      name = "Bao 8";
      break;
    case 9:
      name = "Bao 9";
      break;
    case 10:
      name = "Bao 10";
      break;
    case 11:
      name = "Bao 11";
      break;
    case 12:
      name = "Bao 12";
      break;
    case 13:
      name = "Bao 13";
      break;
    case 14:
      name = "Bao 14";
      break;
    case 15:
      name = "Bao 15";
      break;
    case 18:
      name = "Bao 18";
      break;
    default:
      break;
  }

  return name;
}

String getBagName3DPro(id) {
  var name = "";
  switch (id) {
    case 1:
      name = "Vé thường";
      break;
    case 2:
      name = "Bao bộ số";
      break;
    default:
      // ignore: prefer_interpolation_to_compose_strings
      name = "Bao " + id.toString() + " số";
      break;
  }

  return name;
}

List<int> listPriceKeno() {
  return [10000, 20000, 50000, 100000, 200000, 500000];
}

double getPrize(int system, int price) {
  double prize = 0;
  switch (system) {
    case 1:
      prize = price / 10 * 20000;
      break;
    case 2:
      prize = price / 10 * 90000;
      break;
    case 3:
      prize = price / 10 * 200000;
      break;
    case 4:
      prize = price / 10 * 400000;
      break;
    case 5:
      prize = price / 10 * 4400000;
      break;
    case 6:
      prize = price / 10 * 12000000;
      break;
    case 7:
      prize = price / 10 * 40000000;
      break;
    case 8:
      prize = price / 10 * 200000000;
      break;
    case 9:
      prize = price / 10 * 800000000;
      break;
    case 10:
      prize = price / 10 * 2000000000;
      break;
  }
  return prize;
}

int getPriceMax3DBag(int bag) {
  switch (bag) {
    case 3:
      return 60000;
    case 4:
      return 120000;
    case 5:
      return 200000;
    case 6:
      return 300000;
    case 7:
      return 420000;
    case 8:
      return 560000;
    case 9:
      return 720000;
    case 10:
      return 900000;
    case 11:
      return 1100000;
    case 12:
      return 1320000;
    case 13:
      return 1560000;
    case 14:
      return 1820000;
    case 15:
      return 2100000;
    case 16:
      return 2400000;
    case 17:
      return 2720000;
    case 18:
      return 3060000;
    case 19:
      return 3420000;
    case 20:
      return 3800000;
  }
  return 0;
}

double getPrizeAdvance(String type, int price, String playType) {
  double prize = 0;
  if (playType == "1") {
    switch (type) {
      case Common.CHAN:
      case Common.LE:
        prize = price / 10 * 40;
        break;
      case Common.L1112:
      case Common.HOA:
      case Common.C1112:
        prize = price / 10 * 20;
        break;
    }
  } else {
    prize = price / 10 * 26;
  }
  return prize;
}

String getProductTypeName(String code) {
  var name = "";
  switch (code) {
    case Common.CHAN:
      name = "Chẵn";
      break;
    case Common.HOA:
      name = "Hòa";
      break;
    case Common.LE:
      name = "Lẻ";
      break;
    case Common.C1112:
      name = "Chẵn 11-12";
      break;
    case Common.L1112:
      name = "Lẻ 11-12";
      break;
    case Common.LON:
      name = "Lớn";
      break;
    case Common.HOA_LN:
      name = "Hòa lớn nhỏ";
      break;
    case Common.NHO:
      name = "Nhỏ";
      break;
    default:
      break;
  }

  return name;
}

List<XSKTModel> listXSKT() {
  List<XSKTModel> models = [];

  List<RadioModel> radios2 = [];
  List<RadioModel> radios3 = [];
  List<RadioModel> radios4 = [];
  List<RadioModel> radios5 = [];
  List<RadioModel> radios6 = [];
  List<RadioModel> radios7 = [];
  List<RadioModel> radios8 = [];

  var mienbac = RadioModel(
      id: 43,
      productID: 7,
      region: 1,
      name: "XS Miền Bắc",
      img: "assets/img/mienbac.jpg");

  var hcm = RadioModel(
      id: 22,
      productID: 14,
      region: 3,
      name: "TP. HCM",
      img: "assets/img/hochiminh.jpg");

  var tthue = RadioModel(
      id: 7,
      productID: 15,
      region: 2,
      name: "Thừa T.Huế",
      img: "assets/img/tthue.jpg");

  var dongthap = RadioModel(
      id: 23,
      productID: 14,
      region: 3,
      name: "Đồng Tháp",
      img: "assets/img/dongthap.jpg");

  var camau = RadioModel(
      id: 24,
      productID: 14,
      region: 3,
      name: "Cà Mau",
      img: "assets/img/camau.jpg");

  var phuyen = RadioModel(
      id: 8,
      productID: 15,
      region: 2,
      name: "Phú Yên",
      img: "assets/img/phuyen.jpg");

  var bentre = RadioModel(
      id: 25,
      productID: 14,
      region: 3,
      name: "Bến Tre",
      img: "assets/img/bentre.jpg");

  var quangnam = RadioModel(
      id: 9,
      productID: 15,
      region: 2,
      name: "Quảng Nam",
      img: "assets/img/quangnam.jpg");

  var vungtau = RadioModel(
      id: 26,
      productID: 14,
      region: 3,
      name: "Vũng Tàu",
      img: "assets/img/vungtau.jpg");

  var baclieu = RadioModel(
      id: 27,
      productID: 14,
      region: 3,
      name: "Bạc Liêu",
      img: "assets/img/baclieu.jpg");

  var daklak = RadioModel(
      id: 10,
      productID: 15,
      region: 2,
      name: "Đắk Lắk",
      img: "assets/img/daklak.jpg");

  var dongnai = RadioModel(
      id: 28,
      productID: 14,
      region: 3,
      name: "Đồng Nai",
      img: "assets/img/dongnai.jpg");

  var danang = RadioModel(
      id: 11,
      productID: 15,
      region: 2,
      name: "Đà Nẵng",
      img: "assets/img/danang.jpg");

  var cantho = RadioModel(
      id: 29,
      productID: 14,
      region: 3,
      name: "Cần Thơ",
      img: "assets/img/cantho.jpg");

  var soctrang = RadioModel(
      id: 30,
      productID: 14,
      region: 3,
      name: "Sóc Trăng",
      img: "assets/img/soctrang.jpg");

  var khanhhoa = RadioModel(
      id: 12,
      productID: 15,
      region: 2,
      name: "Khánh Hòa",
      img: "assets/img/khanhhoa.jpg");

  var tayninh = RadioModel(
      id: 31,
      productID: 14,
      region: 3,
      name: "Tây Ninh",
      img: "assets/img/tayninh.jpg");

  var quangbinh = RadioModel(
      id: 14,
      productID: 15,
      region: 2,
      name: "Quảng Bình",
      img: "assets/img/quangbinh.jpg");

  var angiang = RadioModel(
      id: 32,
      productID: 14,
      region: 3,
      name: "An Giang",
      img: "assets/img/angiang.jpg");

  var binhthuan = RadioModel(
      id: 33,
      productID: 14,
      region: 3,
      name: "Bình Thuận",
      img: "assets/img/binhthuan.jpg");

  var binhdinh = RadioModel(
      id: 13,
      productID: 15,
      region: 2,
      name: "Bình Định",
      img: "assets/img/binhdinh.jpg");

  var quangtri = RadioModel(
      id: 15,
      productID: 15,
      region: 2,
      name: "Quảng Trị",
      img: "assets/img/quangtri.jpg");

  var vinhlong = RadioModel(
      id: 34,
      productID: 14,
      region: 3,
      name: "Vĩnh Long",
      img: "assets/img/vinhlong.jpg");

  var gialai = RadioModel(
      id: 16,
      productID: 15,
      region: 2,
      name: "Gia Lai",
      img: "assets/img/gialai.jpg");

  var binhduong = RadioModel(
      id: 35,
      productID: 14,
      region: 3,
      name: "Bình Dương",
      img: "assets/img/binhduong.jpg");

  var travinh = RadioModel(
      id: 36,
      productID: 14,
      region: 3,
      name: "Trà Vinh",
      img: "assets/img/travinh.jpg");

  var ninhthuan = RadioModel(
      id: 17,
      productID: 15,
      region: 2,
      name: "Ninh Thuận",
      img: "assets/img/ninhthuan.jpg");

  var longan = RadioModel(
      id: 37,
      productID: 14,
      region: 3,
      name: "Long An",
      img: "assets/img/longan.jpg");

  var binhphuoc = RadioModel(
      id: 39,
      productID: 14,
      region: 3,
      name: "Bình Phước",
      img: "assets/img/binhphuoc.jpg");

  var haugiang = RadioModel(
      id: 38,
      productID: 14,
      region: 3,
      name: "Hậu Giang",
      img: "assets/img/haugiang.jpg");

  var quangngai = RadioModel(
      id: 18,
      productID: 15,
      region: 2,
      name: "Quảng Ngãi",
      img: "assets/img/quangngai.jpg");

  var daknong = RadioModel(
      id: 19,
      productID: 15,
      region: 2,
      name: "Đắk Nông",
      img: "assets/img/daknong.jpg");

  var tiengiang = RadioModel(
      id: 40,
      productID: 14,
      region: 3,
      name: "Tiền Giang",
      img: "assets/img/tiengiang.jpg");

  var kiengiang = RadioModel(
      id: 41,
      productID: 14,
      region: 3,
      name: "Kiên Giang",
      img: "assets/img/kiengiang.jpg");

  var dalat = RadioModel(
      id: 42,
      productID: 14,
      region: 3,
      name: "Đà Lạt",
      img: "assets/img/dalat.jpg");

  var kontum = RadioModel(
      id: 21,
      productID: 15,
      region: 2,
      name: "Kon Tum",
      img: "assets/img/kontum.jpg");

  radios2.add(mienbac);
  radios2.add(hcm);
  radios2.add(tthue);
  radios2.add(dongthap);
  radios2.add(camau);
  radios2.add(phuyen);

  radios3.add(mienbac);
  radios3.add(bentre);
  radios3.add(quangnam);
  radios3.add(vungtau);
  radios3.add(baclieu);
  radios3.add(daklak);

  radios4.add(mienbac);
  radios4.add(dongnai);
  radios4.add(danang);
  radios4.add(cantho);
  radios4.add(soctrang);
  radios4.add(khanhhoa);

  radios5.add(mienbac);
  radios5.add(tayninh);
  radios5.add(quangbinh);
  radios5.add(angiang);
  radios5.add(binhthuan);
  radios5.add(binhdinh);
  radios5.add(quangtri);

  radios6.add(mienbac);
  radios6.add(vinhlong);
  radios6.add(gialai);
  radios6.add(binhduong);
  radios6.add(travinh);
  radios6.add(ninhthuan);

  radios7.add(mienbac);
  radios7.add(hcm);
  radios7.add(danang);
  radios7.add(longan);
  radios7.add(binhphuoc);
  radios7.add(haugiang);
  radios7.add(quangngai);
  radios7.add(daknong);

  radios8.add(mienbac);
  radios8.add(tiengiang);
  radios8.add(khanhhoa);
  radios8.add(kiengiang);
  radios8.add(dalat);
  radios8.add(kontum);
  radios8.add(tthue);

  final date = DateTime.now();
  var day = date.weekday;
  switch (day) {
    case 1:
      models.add(XSKTModel(lable: "Thứ 2", value: radios2, day: 1, date: date));
      models.add(XSKTModel(
          lable: "Thứ 3",
          value: radios3,
          day: 2,
          date: date.add(const Duration(days: 1))));
      models.add(XSKTModel(
          lable: "Thứ 4",
          value: radios4,
          day: 3,
          date: date.add(const Duration(days: 2))));
      models.add(XSKTModel(
          lable: "Thứ 5",
          value: radios5,
          day: 4,
          date: date.add(const Duration(days: 3))));
      models.add(XSKTModel(
          lable: "Thứ 6",
          value: radios6,
          day: 5,
          date: date.add(const Duration(days: 4))));
      models.add(XSKTModel(
          lable: "Thứ 7",
          value: radios7,
          day: 6,
          date: date.add(const Duration(days: 5))));
      models.add(XSKTModel(
          lable: "Chủ nhật",
          value: radios8,
          day: 7,
          date: date.add(const Duration(days: 6))));
      break;
    case 2:
      models.add(XSKTModel(lable: "Thứ 3", value: radios3, day: 2, date: date));
      models.add(XSKTModel(
          lable: "Thứ 4",
          value: radios4,
          day: 3,
          date: date.add(const Duration(days: 1))));
      models.add(XSKTModel(
          lable: "Thứ 5",
          value: radios5,
          day: 4,
          date: date.add(const Duration(days: 2))));
      models.add(XSKTModel(
          lable: "Thứ 6",
          value: radios6,
          day: 5,
          date: date.add(const Duration(days: 3))));
      models.add(XSKTModel(
          lable: "Thứ 7",
          value: radios7,
          day: 6,
          date: date.add(const Duration(days: 4))));
      models.add(XSKTModel(
          lable: "Chủ nhật",
          value: radios8,
          day: 7,
          date: date.add(const Duration(days: 5))));
      models.add(XSKTModel(
          lable: "Thứ 2",
          value: radios2,
          day: 1,
          date: date.add(const Duration(days: 6))));
      break;
    case 3:
      models.add(XSKTModel(lable: "Thứ 4", value: radios4, day: 3, date: date));
      models.add(XSKTModel(
          lable: "Thứ 5",
          value: radios5,
          day: 4,
          date: date.add(const Duration(days: 1))));
      models.add(XSKTModel(
          lable: "Thứ 6",
          value: radios6,
          day: 5,
          date: date.add(const Duration(days: 2))));
      models.add(XSKTModel(
          lable: "Thứ 7",
          value: radios7,
          day: 6,
          date: date.add(const Duration(days: 3))));
      models.add(XSKTModel(
          lable: "Chủ nhật",
          value: radios8,
          day: 7,
          date: date.add(const Duration(days: 4))));
      models.add(XSKTModel(
          lable: "Thứ 2",
          value: radios2,
          day: 1,
          date: date.add(const Duration(days: 5))));
      models.add(XSKTModel(
          lable: "Thứ 3",
          value: radios3,
          day: 2,
          date: date.add(const Duration(days: 6))));
      break;
    case 4:
      models.add(XSKTModel(lable: "Thứ 5", value: radios5, day: 4, date: date));
      models.add(XSKTModel(
          lable: "Thứ 6",
          value: radios6,
          day: 5,
          date: date.add(const Duration(days: 1))));
      models.add(XSKTModel(
          lable: "Thứ 7",
          value: radios7,
          day: 6,
          date: date.add(const Duration(days: 2))));
      models.add(XSKTModel(
          lable: "Chủ nhật",
          value: radios8,
          day: 7,
          date: date.add(const Duration(days: 3))));
      models.add(XSKTModel(
          lable: "Thứ 2",
          value: radios2,
          day: 1,
          date: date.add(const Duration(days: 4))));
      models.add(XSKTModel(
          lable: "Thứ 3",
          value: radios3,
          day: 2,
          date: date.add(const Duration(days: 5))));
      models.add(XSKTModel(
          lable: "Thứ 4",
          value: radios4,
          day: 3,
          date: date.add(const Duration(days: 6))));
      break;
    case 5:
      models.add(XSKTModel(lable: "Thứ 6", value: radios6, day: 5, date: date));
      models.add(XSKTModel(
          lable: "Thứ 7",
          value: radios7,
          day: 6,
          date: date.add(const Duration(days: 1))));
      models.add(XSKTModel(
          lable: "Chủ nhật",
          value: radios8,
          day: 7,
          date: date.add(const Duration(days: 2))));
      models.add(XSKTModel(
          lable: "Thứ 2",
          value: radios2,
          day: 1,
          date: date.add(const Duration(days: 3))));
      models.add(XSKTModel(
          lable: "Thứ 3",
          value: radios3,
          day: 2,
          date: date.add(const Duration(days: 4))));
      models.add(XSKTModel(
          lable: "Thứ 4",
          value: radios4,
          day: 3,
          date: date.add(const Duration(days: 5))));
      models.add(XSKTModel(
          lable: "Thứ 5",
          value: radios5,
          day: 4,
          date: date.add(const Duration(days: 6))));
      break;
    case 6:
      models.add(XSKTModel(lable: "Thứ 7", value: radios7, day: 6, date: date));
      models.add(XSKTModel(
          lable: "Chủ nhật",
          value: radios8,
          day: 7,
          date: date.add(const Duration(days: 1))));
      models.add(XSKTModel(
          lable: "Thứ 2",
          value: radios2,
          day: 1,
          date: date.add(const Duration(days: 2))));
      models.add(XSKTModel(
          lable: "Thứ 3",
          value: radios3,
          day: 2,
          date: date.add(const Duration(days: 3))));
      models.add(XSKTModel(
          lable: "Thứ 4",
          value: radios4,
          day: 3,
          date: date.add(const Duration(days: 4))));
      models.add(XSKTModel(
          lable: "Thứ 5",
          value: radios5,
          day: 4,
          date: date.add(const Duration(days: 5))));
      models.add(XSKTModel(
          lable: "Thứ 6",
          value: radios6,
          day: 5,
          date: date.add(const Duration(days: 6))));
      break;
    case 7:
      models.add(
          XSKTModel(lable: "Chủ nhật", value: radios8, day: 7, date: date));
      models.add(XSKTModel(
          lable: "Thứ 2",
          value: radios2,
          day: 1,
          date: date.add(const Duration(days: 1))));
      models.add(XSKTModel(
          lable: "Thứ 3",
          value: radios3,
          day: 2,
          date: date.add(const Duration(days: 2))));
      models.add(XSKTModel(
          lable: "Thứ 4",
          value: radios4,
          day: 3,
          date: date.add(const Duration(days: 3))));
      models.add(XSKTModel(
          lable: "Thứ 5",
          value: radios5,
          day: 4,
          date: date.add(const Duration(days: 4))));
      models.add(XSKTModel(
          lable: "Thứ 6",
          value: radios6,
          day: 5,
          date: date.add(const Duration(days: 5))));
      models.add(XSKTModel(
          lable: "Thứ 7",
          value: radios7,
          day: 6,
          date: date.add(const Duration(days: 6))));
      break;
  }

  return models;
}

List<RadioModel> listRadio() {
  List<RadioModel> listRadio = [];
  var mienbac = RadioModel(
      id: 43,
      productID: 7,
      region: 1,
      name: "XS Miền Bắc",
      img: "assets/img/mienbac.jpg");
  listRadio.add(mienbac);
  var hcm = RadioModel(
      id: 22,
      productID: 14,
      region: 3,
      name: "TP. HCM",
      img: "assets/img/hochiminh.jpg");
  listRadio.add(hcm);
  var tthue = RadioModel(
      id: 7,
      productID: 15,
      region: 2,
      name: "Thừa T.Huế",
      img: "assets/img/tthue.jpg");
  listRadio.add(tthue);
  var dongthap = RadioModel(
      id: 23,
      productID: 14,
      region: 3,
      name: "Đồng Tháp",
      img: "assets/img/dongthap.jpg");
  listRadio.add(dongthap);
  var camau = RadioModel(
      id: 24,
      productID: 14,
      region: 3,
      name: "Cà Mau",
      img: "assets/img/camau.jpg");
  listRadio.add(camau);
  var phuyen = RadioModel(
      id: 8,
      productID: 15,
      region: 2,
      name: "Phú Yên",
      img: "assets/img/phuyen.jpg");
  listRadio.add(phuyen);
  var bentre = RadioModel(
      id: 25,
      productID: 14,
      region: 3,
      name: "Bến Tre",
      img: "assets/img/bentre.jpg");
  listRadio.add(bentre);
  var quangnam = RadioModel(
      id: 9,
      productID: 15,
      region: 2,
      name: "Quảng Nam",
      img: "assets/img/quangnam.jpg");
  listRadio.add(quangnam);
  var vungtau = RadioModel(
      id: 26,
      productID: 14,
      region: 3,
      name: "Vũng Tàu",
      img: "assets/img/vungtau.jpg");
  listRadio.add(vungtau);
  var baclieu = RadioModel(
      id: 27,
      productID: 14,
      region: 3,
      name: "Bạc Liêu",
      img: "assets/img/baclieu.jpg");
  listRadio.add(baclieu);
  var daklak = RadioModel(
      id: 10,
      productID: 15,
      region: 2,
      name: "Đắk Lắk",
      img: "assets/img/daklak.jpg");
  listRadio.add(daklak);
  var dongnai = RadioModel(
      id: 28,
      productID: 14,
      region: 3,
      name: "Đồng Nai",
      img: "assets/img/dongnai.jpg");
  listRadio.add(dongnai);
  var danang = RadioModel(
      id: 11,
      productID: 15,
      region: 2,
      name: "Đà Nẵng",
      img: "assets/img/danang.jpg");
  listRadio.add(danang);
  var cantho = RadioModel(
      id: 29,
      productID: 14,
      region: 3,
      name: "Cần Thơ",
      img: "assets/img/cantho.jpg");
  listRadio.add(cantho);
  var soctrang = RadioModel(
      id: 30,
      productID: 14,
      region: 3,
      name: "Sóc Trăng",
      img: "assets/img/soctrang.jpg");
  listRadio.add(soctrang);
  var khanhhoa = RadioModel(
      id: 12,
      productID: 15,
      region: 2,
      name: "Khánh Hòa",
      img: "assets/img/khanhhoa.jpg");
  listRadio.add(khanhhoa);
  var tayninh = RadioModel(
      id: 31,
      productID: 14,
      region: 3,
      name: "Tây Ninh",
      img: "assets/img/tayninh.jpg");
  listRadio.add(tayninh);
  var quangbinh = RadioModel(
      id: 14,
      productID: 15,
      region: 2,
      name: "Quảng Bình",
      img: "assets/img/quangbinh.jpg");
  listRadio.add(quangbinh);
  var angiang = RadioModel(
      id: 32,
      productID: 14,
      region: 3,
      name: "An Giang",
      img: "assets/img/angiang.jpg");
  listRadio.add(angiang);
  var binhthuan = RadioModel(
      id: 33,
      productID: 14,
      region: 3,
      name: "Bình Thuận",
      img: "assets/img/binhthuan.jpg");
  listRadio.add(binhthuan);
  var binhdinh = RadioModel(
      id: 13,
      productID: 15,
      region: 2,
      name: "Bình Định",
      img: "assets/img/binhdinh.jpg");
  listRadio.add(binhdinh);
  var quangtri = RadioModel(
      id: 15,
      productID: 15,
      region: 2,
      name: "Quảng Trị",
      img: "assets/img/quangtri.jpg");
  listRadio.add(quangtri);
  var vinhlong = RadioModel(
      id: 34,
      productID: 14,
      region: 3,
      name: "Vĩnh Long",
      img: "assets/img/vinhlong.jpg");
  listRadio.add(vinhlong);
  var gialai = RadioModel(
      id: 16,
      productID: 15,
      region: 2,
      name: "Gia Lai",
      img: "assets/img/gialai.jpg");
  listRadio.add(gialai);
  var binhduong = RadioModel(
      id: 35,
      productID: 14,
      region: 3,
      name: "Bình Dương",
      img: "assets/img/binhduong.jpg");
  listRadio.add(binhduong);
  var travinh = RadioModel(
      id: 36,
      productID: 14,
      region: 3,
      name: "Trà Vinh",
      img: "assets/img/travinh.jpg");
  listRadio.add(travinh);
  var ninhthuan = RadioModel(
      id: 17,
      productID: 15,
      region: 2,
      name: "Ninh Thuận",
      img: "assets/img/ninhthuan.jpg");
  listRadio.add(ninhthuan);
  var longan = RadioModel(
      id: 37,
      productID: 14,
      region: 3,
      name: "Long An",
      img: "assets/img/longan.jpg");
  listRadio.add(longan);
  var binhphuoc = RadioModel(
      id: 39,
      productID: 14,
      region: 3,
      name: "Bình Phước",
      img: "assets/img/binhphuoc.jpg");
  listRadio.add(binhphuoc);
  var haugiang = RadioModel(
      id: 38,
      productID: 14,
      region: 3,
      name: "Hậu Giang",
      img: "assets/img/haugiang.jpg");
  listRadio.add(haugiang);
  var quangngai = RadioModel(
      id: 18,
      productID: 15,
      region: 2,
      name: "Quảng Ngãi",
      img: "assets/img/quangngai.jpg");
  listRadio.add(quangngai);
  var daknong = RadioModel(
      id: 19,
      productID: 15,
      region: 2,
      name: "Đắk Nông",
      img: "assets/img/daknong.jpg");
  listRadio.add(daknong);
  var tiengiang = RadioModel(
      id: 40,
      productID: 14,
      region: 3,
      name: "Tiền Giang",
      img: "assets/img/tiengiang.jpg");
  listRadio.add(tiengiang);
  var kiengiang = RadioModel(
      id: 41,
      productID: 14,
      region: 3,
      name: "Kiên Giang",
      img: "assets/img/kiengiang.jpg");
  listRadio.add(kiengiang);
  var dalat = RadioModel(
      id: 42,
      productID: 14,
      region: 3,
      name: "Đà Lạt",
      img: "assets/img/dalat.jpg");
  listRadio.add(dalat);
  var kontum = RadioModel(
      id: 21,
      productID: 15,
      region: 2,
      name: "Kon Tum",
      img: "assets/img/kontum.jpg");
  listRadio.add(kontum);
  return listRadio;
}

DateTime getDayXSKT(DateTime date) {
  var h = date.hour;
  var m = date.minute;
  var s = date.second;

  h = 18 - (h + 1);
  var newDate = date.add(Duration(hours: h, minutes: 60 - m, seconds: 60 - s));
  return newDate;
}

String getByDateDDMMYYYY(DateTime date) {
  return DateFormat("dd/MM/yyyy").format(date);
}
