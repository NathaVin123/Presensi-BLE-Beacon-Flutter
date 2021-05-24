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
  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 4);
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
        controller: controller,
        children: <Widget>[
          new Presensi.DosenPresensiDashboardPage(),
          new Jadwal.DosenJadwalDashboardPage(),
          new Riwayat.DosenRiwayatDashboardPage(),
          new Akun.DosenAkunDashboardPage(),
        ],
      ),
      bottomNavigationBar: new Material(
        color: Colors.blue,
        child: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(
              icon: new Icon(
                Icons.arrow_upward_rounded,
              ),
              text: "Presensi",
            ),
            new Tab(
              icon: new Icon(
                Icons.schedule_rounded,
              ),
              text: "Jadwal",
            ),
            new Tab(
              icon: new Icon(
                Icons.history_rounded,
              ),
              text: "Riwayat",
            ),
            new Tab(
              icon: new Icon(
                Icons.person_pin_rounded,
              ),
              text: "Akun",
            )
          ],
        ),
      ),
    );
  }
}
