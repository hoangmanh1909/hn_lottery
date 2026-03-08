// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/view/result/result_kien_thiet_view.dart';
import 'package:lottery_flutter_application/view/result/result_vietlott_view.dart';
import '../../utils/color_lot.dart';

class FResultShellView extends StatefulWidget {
  const FResultShellView({Key? key}) : super(key: key);

  @override
  State<FResultShellView> createState() => _ResultShellViewState();
}

class _ResultShellViewState extends State<FResultShellView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorLot.ColorBackground, // Sử dụng màu nền chung
        appBar: PreferredSize(
          // 1. Tăng chiều cao tổng thể để chứa cả Title và TabBar thoải mái
          preferredSize: const Size.fromHeight(110.0),
          child: AppBar(
            backgroundColor: ColorLot.ColorPrimary,
            elevation: 0,
            automaticallyImplyLeading: false, // Không nút back
            centerTitle: true,
            // 2. Bo góc dưới y hệt màn hình Sổ mơ
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            title: const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "KẾT QUẢ XỔ SỐ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // 3. Đưa TabBar vào phần bottom của AppBar
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: ColorLot.ColorBackgoundTab,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(4),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  indicator: BoxDecoration(
                    color: ColorLot.ColorPrimary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  tabs: const [
                    Tab(text: 'Vietlott'),
                    Tab(text: 'Kiến thiết'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ResultVietlottView(),
            ResultKienThietView(),
          ],
        ),
      ),
    );
  }
}
