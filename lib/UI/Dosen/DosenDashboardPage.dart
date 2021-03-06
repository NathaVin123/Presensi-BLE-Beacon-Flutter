import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:presensiblebeacon/UI/Dosen/Presensi/DosenPresensiDashboardPage.dart'
    as Presensi;
import 'package:presensiblebeacon/UI/Dosen/Jadwal/DosenJadwalDashboardPage.dart'
    as Jadwal;
import 'package:presensiblebeacon/UI/Dosen/Riwayat/DosenRiwayatDashboardPage.dart'
    as Riwayat;
import 'package:presensiblebeacon/UI/Dosen/Akun/DosenAkunDashboardPage.dart'
    as Akun;

class DosenDashboardPage extends StatefulWidget {
  @override
  _DosenDashboardPageState createState() => _DosenDashboardPageState();
}

class _DosenDashboardPageState extends State<DosenDashboardPage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  var currentPage = 0;
  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 4);
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
          new Presensi.DosenPresensiDashboardPage(),
          new Jadwal.DosenJadwalDashboardPage(),
          new Riwayat.DosenRiwayatDashboardPage(),
          new Akun.DosenAkunDashboardPage(),
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
              icon: new Icon(Icons.arrow_upward_rounded,
                  color: controller.index == 0 ? Colors.black : Colors.grey),
              text: "Presensi",
            ),
            new Tab(
              icon: new Icon(Icons.schedule_rounded,
                  color: controller.index == 1 ? Colors.black : Colors.grey),
              text: "Jadwal",
            ),
            new Tab(
              icon: new Icon(Icons.history_rounded,
                  color: controller.index == 2 ? Colors.black : Colors.grey),
              text: "Riwayat",
            ),
            new Tab(
              icon: new Icon(Icons.person_rounded,
                  color: controller.index == 3 ? Colors.black : Colors.grey),
              text: "Akun",
            )
          ],
        ),
      ),
    );
  }
}
