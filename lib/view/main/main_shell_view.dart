import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/view/main/f_result_shell_view.dart';
import 'package:lottery_flutter_application/view/main/so_mo_view.dart';
import 'f_result_view.dart'; // Import file Kết quả của bạn
// import 'home_view.dart';
// import 'so_mo_view.dart';

class MainShellView extends StatefulWidget {
  const MainShellView({super.key});

  @override
  State<MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<MainShellView> {
  int _currentIndex = 0; // Mặc định mở tab Kết quả

  // Danh sách các màn hình riêng biệt
  final List<Widget> _screens = [
    const FResultView(), // Thay bằng HomeView() của bạn
    const FResultShellView(), // Màn hình Kết quả bạn đang viết
    const SoMoView(), // Thay bằng SoMoView() của bạn
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack giúp giữ trạng thái của FResultView (không bị load lại API khi chuyển tab)
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang Chủ"),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: "Kết Quả"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Sổ mơ"),
        ],
      ),
    );
  }
}
