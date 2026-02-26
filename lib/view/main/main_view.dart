// ignore_for_file: use_build_context_synchronously, prefer_const_constructors
import 'dart:convert';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
// import 'package:awesome_bottom_bar/chip_style.dart';
// import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/view/main/home_view.dart';
import 'package:lottery_flutter_application/view/main/vietlott_home_view.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/common.dart';
import '../../controller/dictionary_controller.dart';
import '../../models/response/params_response.dart';
import '../../models/response/player_profile.dart';
import '../../models/response/response_object.dart';
import '../../utils/color_lot.dart';
import 'history_view.dart';
import 'notification_view.dart';
import 'personal_view.dart';
import 'result_view.dart';
import 'package:badges/badges.dart' as badges;

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  final DictionaryController _con = DictionaryController();

  PlayerProfile? playerProfile;
  final List<Widget> _widgetOptions = <Widget>[
    VietlottHomeView(),
    HistoryView(),
    ResultView(),
    PersonalView()
  ];
  bool isShowHistory = true;
  int countNotifi = 0;
  SharedPreferences? prefs;
  String mode = "ON";
  bool isLoadParam = false;
  int visit = 1;
  List<TabItem> items = [];
  String mainText = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initPref());
  }

  void initPref() async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString(Common.SHARE_MODE_UPLOAD, "OFF");
    await getParams();
    String? userMap = prefs?.getString('user');

    if (userMap != null) {
      setState(() {
        playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      });
      if (mode == Common.ANDROID_MODE_UPLOAD) {
        await getNoti();
      }
    }
  }

  getNoti() async {
    ResponseObject res =
        await _con.countNotification(playerProfile!.mobileNumber!);

    if (res.code == "00") {
      double n = jsonDecode(res.data!)["Total"];
      countNotifi = n.toInt();

      setState(() {});
    }
  }

  getParams() async {
    ResponseObject res = await _con.getPrams();

    if (res.code == "00") {
      isLoadParam = true;
      List<ParamsResponse> params = List<ParamsResponse>.from(
          (jsonDecode(res.data!)
              .map((model) => ParamsResponse.fromJson(model))));
      if (prefs != null) {
        ParamsResponse p;
        if (Common.CHANNEL == "IOS") {
          p = params
              .where((element) => element.parameter == "APPLE_MODE_UPLOAD")
              .first;
        } else {
          p = params
              .where((element) => element.parameter == "CHPLAY_MODE_UPLOAD")
              .first;
        }
        // ParamsResponse mt =
        //     params.where((element) => element.parameter == "MAIN_TEXT").first;
        // mainText = mt.value!;

        prefs!.setString(Common.SHARE_MODE_UPLOAD, p.value!);
        mode = p.value!;
        setState(() {});
      }
    }
    // else
    // {
    //   if (res.code == "401") {
    //     if (context.mounted) {
    //       prefs!.clear();
    //       Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(builder: (context) => LoginView()),
    //         (Route<dynamic> route) => false,
    //       );
    //     }
    //   } else {
    //     if (context.mounted) showMessage(context, res.message!, "99");
    //   }
    // }
  }
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  // List<BottomNavigationBarItem> _buildButtonBar() {
  //   return <BottomNavigationBarItem>[
  //     BottomNavigationBarItem(
  //       icon: Icon(Icons.local_offer_outlined),
  //       label: 'Trang chủ',
  //     ),
  //     BottomNavigationBarItem(
  //       icon: Icon(Icons.schedule_outlined),
  //       label: 'Lịch sử',
  //     ),
  //     BottomNavigationBarItem(
  //       icon: Icon(Icons.bookmarks_outlined),
  //       label: 'Kết quả',
  //     ),
  //     BottomNavigationBarItem(
  //       icon: Icon(Icons.person_outline_rounded),
  //       label: 'Cá nhân',
  //     )
  //   ];
  // }

  noti() async {
    bool isback = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const NotificationView()));
    if (isback) {
      getNoti();
    }
  }

  buildNotification() {
    // if (playerProfile != null) {
    // if (mode == Common.ANDROID_MODE_UPLOAD) {
    return countNotifi > 0
        ? Padding(
            padding: EdgeInsets.only(right: 15),
            child: InkWell(
                onTap: () {
                  noti();
                },
                child: badges.Badge(
                  showBadge: true,
                  ignorePointer: false,
                  // 1. Căn chỉnh lại position: giảm độ lệch âm để nó không bay quá xa
                  position: badges.BadgePosition.topEnd(top: -10, end: -8),
                  badgeContent: Container(
                    // 2. Ép chiều ngang tối thiểu để khi là số '1' nó vẫn tạo thành hình tròn đẹp
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    alignment: Alignment.center,
                    child: Text(
                      countNotifi > 99 ? '99+' : countNotifi.toString(),
                      style: const TextStyle(
                        color: ColorLot.ColorPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: Colors.white,
                    // 3. Chỉnh padding nhỏ lại để Badge ôm sát số
                    padding: const EdgeInsets.all(4),
                    elevation: 2, // Thêm chút bóng đổ cho sang
                  ),
                  child: const Icon(Ionicons.notifications,
                      color: Colors.white, size: 26),
                )),
          )
        : InkWell(
            onTap: () {
              Future.delayed(Duration.zero, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationView()));
              });
            },
            child: const Icon(Ionicons.notifications, color: Colors.white),
          );
    //   } else {
    //     return SizedBox.shrink();
    //   }
    // } else {
    //   if (mode == Common.ANDROID_MODE_UPLOAD) {
    //     return InkWell(
    //       onTap: () {
    //         if (mounted) {
    //           Navigator.push(context,
    //               MaterialPageRoute(builder: (context) => LoginView()));
    //         }
    //       },
    //       child: Container(
    //         padding: EdgeInsets.all(2),
    //         margin: EdgeInsets.all(2),
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.all(Radius.circular(4)),
    //             border: Border.all(
    //                 color: Colors.white, width: 1, style: BorderStyle.solid)),
    //         child: Text(
    //           "Đăng ký/Đăng nhập",
    //           style: TextStyle(color: Colors.white),
    //         ),
    //       ),
    //     );
    //   } else {
    //     return SizedBox.shrink();
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: ColorLot.ColorPrimary,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.red),
              ),
              const SizedBox(width: 10),

              // Text + balance
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Xin chào!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      "HOANG VAN MANH",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "7,900đ",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white),
                          ),
                          child: const Text(
                            "Nạp tiền",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // Icons right
              Row(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => {},
                        child: const Icon(Ionicons.trophy, color: Colors.white),
                      ),
                      const SizedBox(
                          width: 10), // Bạn tự kiểm soát khoảng cách ở đây
                      buildNotification(),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: buildBody(),

      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: _buildButtonBar(),
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: ColorLot.ColorPrimary,
      //   backgroundColor: Colors.white,
      //   onTap: _onItemTapped,
      // ),
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget buildMarquee() {
    if (mainText.isNotEmpty) {
      if (Common.CHANNEL == "ANDROID") {
        return Container(
            color: Colors.yellow,
            height: 30,
            child: Marquee(
              key: Key("_useRtlText"),
              text: " $mainText",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              velocity: 50.0,
            ));
      } else {
        if (mode == Common.ANDROID_MODE_UPLOAD) {
          return Container(
              color: Colors.yellow,
              height: 30,
              child: Marquee(
                key: Key("_useRtlText"),
                text: " $mainText",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                velocity: 50.0,
              ));
        }
      }
    }
    return SizedBox.shrink();
  }

  buildBody() {
    // if (!isLoadParam) {
    //   return SizedBox.shrink();
    // }
    // if (mode == Common.ANDROID_MODE_UPLOAD) {

    // } else {
    //   _widgetOptions = [KenoLiveView(), ResultView()];
    // }
    // setState(() {});
    return _widgetOptions.isNotEmpty
        ? _widgetOptions.elementAt(_selectedIndex)
        : SizedBox.shrink();
  }

  Widget bottomBar() {
    // if (!isLoadParam) {
    //   return SizedBox.shrink();
    // }
    // if (mode == Common.ANDROID_MODE_UPLOAD) {
    items = [
      TabItem(
        icon: Ionicons.home,
        title: 'Trang chủ',
      ),
      TabItem(
        icon: Ionicons.time,
        title: 'Lịch sử',
      ),
      TabItem(
        icon: Ionicons.flag,
        title: 'Kết quả',
      ),
      TabItem(
        icon: Ionicons.person,
        title: 'Cá nhân',
      ),
    ];

    return BottomBarDefault(
      items: items,
      backgroundColor: Colors.white,
      color: Colors.black,
      colorSelected: ColorLot.ColorPrimary,
      indexSelected: _selectedIndex,
      onTap: (int index) => setState(() {
        _selectedIndex = index;
      }),
      animated: false,
    );
    // } else {
    //   items = [
    //     TabItem(
    //       icon: Ionicons.home_outline,
    //       title: 'Trang chủ',
    //     ),
    //     TabItem(
    //       icon: Ionicons.bookmarks_outline,
    //       title: 'Kết quả',
    //     ),
    //   ];
    //   return BottomBarInspiredOutside(
    //     items: items,
    //     backgroundColor: Colors.white,
    //     color: ColorLot.ColorPrimary,
    //     colorSelected: Colors.white,
    //     indexSelected: _selectedIndex,
    //     onTap: (int index) => setState(() {
    //       _selectedIndex = index;
    //     }),
    //     top: -25,
    //     animated: true,
    //     itemStyle: ItemStyle.circle,
    //     chipStyle: const ChipStyle(
    //         drawHexagon: false, background: ColorLot.ColorPrimary),
    //   );
    // }
  }
}
