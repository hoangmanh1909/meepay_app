// ignore_for_file: prefer_const_constructors

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/view/main/home_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  List<TabItem> items = [
    TabItem(
      icon: Ionicons.notifications_outline,
      title: 'Thông báo',
    ),
    TabItem(
      icon: Ionicons.storefront_outline,
      title: 'Cửa hàng',
    ),
  ];
  final List<Widget> _widgetOptions = <Widget>[HomeView(), HomeView()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ColorMP.ColorPrimary,
      ),
      body: Container(
        color: ColorMP.ColorBackground,
        child: _widgetOptions.isNotEmpty
            ? _widgetOptions.elementAt(_selectedIndex)
            : SizedBox.shrink(),
      ),
      bottomNavigationBar: BottomBarInspiredInside(
        items: items,
        backgroundColor: Colors.white,
        color: ColorMP.ColorPrimary,
        colorSelected: Colors.white,
        indexSelected: _selectedIndex,
        onTap: (int index) => setState(() {
          _selectedIndex = index;
        }),
        chipStyle: const ChipStyle(convexBridge: true),
        itemStyle: ItemStyle.circle,
        animated: false,
      ),
    );
  }
}
