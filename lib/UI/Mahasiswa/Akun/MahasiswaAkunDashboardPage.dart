import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MahasiswaAkunDashboardPage extends StatefulWidget {
  MahasiswaAkunDashboardPage({Key key}) : super(key: key);

  @override
  _MahasiswaAkunDashboardPageState createState() =>
      _MahasiswaAkunDashboardPageState();
}

class _MahasiswaAkunDashboardPageState
    extends State<MahasiswaAkunDashboardPage> {
  String npm = "";
  String namamhs = "";

  bool lightSwitch = false;
  bool notifSwitch = false;

  ThemeData _lightTheme = ThemeData(
    accentColor: Colors.pink,
    brightness: Brightness.light,
    primaryColor: Colors.blue,
  );

  ThemeData _darkTheme = ThemeData(
    accentColor: Colors.red,
    brightness: Brightness.dark,
    primaryColor: Colors.amber,
  );

  @override
  void initState() {
    super.initState();
    getDataMahasiswa();
  }

  void getDataMahasiswa() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();

    npm = loginMahasiswa.getString('npm');
    namamhs = loginMahasiswa.getString('namamhs');

    print(npm);
    print(namamhs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            pinned: true,
            floating: false,
            snap: false,
            expandedHeight: 85,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Akun',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            children: <Widget>[
              // SizedBox(
              //   height: 45,
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 25, right: 25),
              //   child: Align(
              //     alignment: Alignment.topLeft,
              //     child: Text(
              //       'Akun',
              //       style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () async {
                      // SharedPreferences loginMahasiswa =
                      //     await SharedPreferences.getInstance();
                      // String npm = (loginMahasiswa.getString('npm') ?? 'null');
                      // Get.snackbar('title', npm);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25)),
                        // decoration: BoxDecoration(),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'person-male'.png,
                                  height: 150.0,
                                  width: 100.0,
                                ),
                              ),
                            ),
                            Center(
                                child: Column(
                              children: [
                                Text(namamhs,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                SizedBox(
                                  height: 22,
                                ),
                                Text(
                                  npm,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ))
                          ],
                        ))),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Pengaturan',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  )),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 14, right: 14, top: 14, bottom: 14),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.notifications_active,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Notifikasi Kelas',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Switch(
                                  value: notifSwitch,
                                  onChanged: (value) {
                                    setState(() {
                                      notifSwitch = value;
                                      print(notifSwitch);
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 24, right: 20, top: 20, bottom: 20),
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.solidMoon,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 11,
                                  ),
                                  Text(
                                    'Dark Mode',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Switch(
                                  value: lightSwitch,
                                  onChanged: (toggle) {
                                    setState(() {
                                      lightSwitch = toggle;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 14, right: 14, bottom: 14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () => Get.toNamed('/statistik/mahasiswa'),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 24, right: 20, top: 20, bottom: 20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.chartBar,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 11,
                                      ),
                                      Text(
                                        'Statistik',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 14, right: 14, bottom: 14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () => Get.toNamed('/tentang'),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_rounded,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Tentang Aplikasi',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 14, right: 14, bottom: 14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () => Get.offAllNamed('/login'),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Keluar',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
