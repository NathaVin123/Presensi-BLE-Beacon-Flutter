import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:presensiblebeacon/UI/Admin/Menu/MenuAdminDashboardPage.dart'
    as Menu;

import 'package:presensiblebeacon/UI/Admin/Akun/AkunAdminDashboardPage.dart'
    as Akun;

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  var currentPage = 0;
  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
    controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: new TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: <Widget>[
          new Menu.MenuAdminDashboardPage(),
          new Akun.AkunAdminDashboardPage()
        ],
      ),
      bottomNavigationBar: new Material(
        elevation: 25,
        color: Colors.white,
        child: new TabBar(
          labelStyle: TextStyle(
              fontFamily: 'WorkSansMedium',
              fontWeight: FontWeight.bold,
              fontSize: 12),
          controller: controller,
          indicatorColor: Colors.grey[800],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          // isScrollable: true,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
          tabs: <Widget>[
            new Tab(
              icon: new Icon(Icons.menu_open_rounded,
                  color: controller.index == 0 ? Colors.black : Colors.grey),
              text: "Menu",
            ),
            new Tab(
              icon: new Icon(Icons.person_rounded,
                  color: controller.index == 1 ? Colors.black : Colors.grey),
              text: "Akun",
            )
          ],
        ),
      ),
    );
  }
}
