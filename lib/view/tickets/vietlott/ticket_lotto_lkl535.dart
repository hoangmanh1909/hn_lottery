import 'package:flutter/material.dart';
import 'dart:math' as math;

class PlayTypeViewModel {
  final int bag;
  final String name;

  PlayTypeViewModel({required this.bag, required this.name});
}

class TicketLotto535 extends StatefulWidget {
  @override
  _TicketLotto535State createState() => _TicketLotto535State();
}

class _TicketLotto535State extends State<TicketLotto535> {
  // Danh sách loại vé số chính
  static List<PlayTypeViewModel> playTypesLotto = [
    PlayTypeViewModel(bag: 5, name: "Vé thường"),
    PlayTypeViewModel(bag: 4, name: "Bao 4 số"),
    PlayTypeViewModel(bag: 6, name: "Bao 6 số"),
    PlayTypeViewModel(bag: 7, name: "Bao 7 số"),
    PlayTypeViewModel(bag: 8, name: "Bao 8 số"),
    PlayTypeViewModel(bag: 9, name: "Bao 9 số"),
    PlayTypeViewModel(bag: 10, name: "Bao 10 số"),
    PlayTypeViewModel(bag: 11, name: "Bao 11 số"),
    PlayTypeViewModel(bag: 12, name: "Bao 12 số"),
    PlayTypeViewModel(bag: 13, name: "Bao 13 số"),
    PlayTypeViewModel(bag: 14, name: "Bao 14 số"),
    PlayTypeViewModel(bag: 15, name: "Bao 15 số"),
  ];

  // Danh sách loại vé số đặc biệt
  static List<PlayTypeViewModel> playTypesSpecialLotto = [
    PlayTypeViewModel(bag: 1, name: "Vé thường"),
    PlayTypeViewModel(bag: 2, name: "Bao 2 số"),
    PlayTypeViewModel(bag: 3, name: "Bao 3 số"),
    PlayTypeViewModel(bag: 4, name: "Bao 4 số"),
    PlayTypeViewModel(bag: 5, name: "Bao 5 số"),
    PlayTypeViewModel(bag: 6, name: "Bao 6 số"),
    PlayTypeViewModel(bag: 7, name: "Bao 7 số"),
    PlayTypeViewModel(bag: 8, name: "Bao 8 số"),
    PlayTypeViewModel(bag: 9, name: "Bao 9 số"),
    PlayTypeViewModel(bag: 10, name: "Bao 10 số"),
    PlayTypeViewModel(bag: 11, name: "Bao 11 số"),
    PlayTypeViewModel(bag: 12, name: "Bao 12 số"),
  ];

  PlayTypeViewModel selectedMainType = playTypesLotto[0];
  PlayTypeViewModel selectedSpecialType = playTypesSpecialLotto[0];
  String selectedDate = '22/06/2025';

  // Danh sách số chính đã chọn cho mỗi hàng
  Map<String, List<int>> selectedMainNumbers = {
    'A': [1, 2, 6], // Ví dụ đã chọn 3 số
    'B': [6, 7, 9, 14, 20, 21, 24], // Ví dụ đã chọn 7 số
    'C': [],
    'D': [],
    'E': [],
    'F': [],
  };

  // Số đặc biệt đã chọn cho mỗi hàng
  Map<String, List<int>> selectedSpecialNumbers = {
    'A': [4], // Ví dụ đã chọn 1 số đặc biệt
    'B': [],
    'C': [],
    'D': [],
    'E': [],
    'F': [],
  };

  List<int> availableNumbers = List.generate(35, (index) => index + 1);

  int calculateTotal() {
    // Tính toán tạm thời - có thể thay đổi theo logic thực tế
    return 2520000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Chọn số xổ số'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần chọn loại vé
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Số chính',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<PlayTypeViewModel>(
                              value: selectedMainType,
                              isExpanded: true,
                              items:
                                  playTypesLotto.map((PlayTypeViewModel type) {
                                return DropdownMenuItem<PlayTypeViewModel>(
                                  value: type,
                                  child: Text(type.name),
                                );
                              }).toList(),
                              onChanged: (PlayTypeViewModel? newValue) {
                                setState(() {
                                  selectedMainType = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Số đặc biệt',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<PlayTypeViewModel>(
                              value: selectedSpecialType,
                              isExpanded: true,
                              items: playTypesSpecialLotto
                                  .map((PlayTypeViewModel type) {
                                return DropdownMenuItem<PlayTypeViewModel>(
                                  value: type,
                                  child: Text(
                                    type.name,
                                    style: TextStyle(color: Colors.red[600]),
                                  ),
                                );
                              }).toList(),
                              onChanged: (PlayTypeViewModel? newValue) {
                                setState(() {
                                  selectedSpecialType = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Phần chọn ngày
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chọn kỳ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedDate,
                        isExpanded: true,
                        items: ['22/06/2025', '23/06/2025', '24/06/2025']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDate = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Phần chọn số
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Hiển thị 6 hàng chọn số
                  ...selectedMainNumbers.keys.map((row) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          // Ký hiệu hàng
                          Container(
                            width: 30,
                            child: Text(
                              row,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[600],
                              ),
                            ),
                          ),
                          // Hiển thị số chính (màu cam)
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                // Hiển thị tất cả ô cho số chính
                                ...List.generate(selectedMainType.bag, (index) {
                                  bool hasNumber =
                                      index < selectedMainNumbers[row]!.length;
                                  int? number = hasNumber
                                      ? selectedMainNumbers[row]![index]
                                      : null;

                                  return GestureDetector(
                                    onTap: () {
                                      if (hasNumber) {
                                        // Xóa số đã chọn
                                        setState(() {
                                          selectedMainNumbers[row]!
                                              .removeAt(index);
                                        });
                                      } else {
                                        // Chọn số mới
                                        _showNumberPicker(context, row, 'main');
                                      }
                                    },
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: hasNumber
                                            ? Colors.orange
                                            : Colors.transparent,
                                        border: Border.all(
                                            color: Colors.orange[300]!,
                                            width: 2),
                                      ),
                                      child: Center(
                                        child: hasNumber
                                            ? Text(
                                                number
                                                    .toString()
                                                    .padLeft(2, '0'),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : null,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          // Hiển thị số đặc biệt (màu đỏ)
                          ...List.generate(selectedSpecialType.bag, (index) {
                            bool hasNumber =
                                index < selectedSpecialNumbers[row]!.length;
                            int? number = hasNumber
                                ? selectedSpecialNumbers[row]![index]
                                : null;

                            return Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  if (hasNumber) {
                                    // Xóa số đã chọn
                                    setState(() {
                                      selectedSpecialNumbers[row]!
                                          .removeAt(index);
                                    });
                                  } else {
                                    // Chọn số mới
                                    _showNumberPicker(context, row, 'special');
                                  }
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hasNumber
                                        ? Colors.red
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: Colors.red[300]!, width: 2),
                                  ),
                                  child: Center(
                                    child: hasNumber
                                        ? Text(
                                            number.toString().padLeft(2, '0'),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          }),
                          SizedBox(width: 8),
                          // Icon xóa
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMainNumbers[row]!.clear();
                                selectedSpecialNumbers[row]!.clear();
                              });
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          // Icon TC
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                'TC',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  SizedBox(height: 16),

                  // Tạm tính
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tạm tính',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${calculateTotal().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Nút hành động
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Chọn hàng đầu tiên có thể chọn thêm số
                      String? availableRow;
                      for (String row in selectedMainNumbers.keys) {
                        if (selectedMainNumbers[row]!.length <
                            selectedMainType.bag) {
                          availableRow = row;
                          break;
                        }
                      }

                      if (availableRow != null) {
                        _showNumberPicker(context, availableRow, 'main');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tất cả hàng đã đủ số!')),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Chọn nhanh',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý đặt vé
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đặt vé thành công!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Đặt vé',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNumberPicker(BuildContext context, String row, String type) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chọn số ${type == 'main' ? 'chính' : 'đặc biệt'} cho hàng $row (01-35)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: type == 'main' ? Colors.orange : Colors.red,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 35,
                  itemBuilder: (context, index) {
                    int number = index + 1;
                    bool isSelected = type == 'main'
                        ? selectedMainNumbers[row]!.contains(number)
                        : selectedSpecialNumbers[row]!.contains(number);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (type == 'main') {
                            if (!selectedMainNumbers[row]!.contains(number) &&
                                selectedMainNumbers[row]!.length <
                                    selectedMainType.bag) {
                              selectedMainNumbers[row]!.add(number);
                            }
                          } else {
                            if (!selectedSpecialNumbers[row]!
                                    .contains(number) &&
                                selectedSpecialNumbers[row]!.length <
                                    selectedSpecialType.bag) {
                              selectedSpecialNumbers[row]!.add(number);
                            }
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? (type == 'main' ? Colors.orange : Colors.red)
                              : Colors.transparent,
                          border: Border.all(
                              color:
                                  type == 'main' ? Colors.orange : Colors.red,
                              width: 2),
                        ),
                        child: Center(
                          child: Text(
                            number.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : (type == 'main'
                                      ? Colors.orange
                                      : Colors.red),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
