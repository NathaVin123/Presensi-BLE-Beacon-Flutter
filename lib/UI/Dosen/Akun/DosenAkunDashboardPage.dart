import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DosenAkunDashboardPage extends StatefulWidget {
  DosenAkunDashboardPage({Key key}) : super(key: key);

  @override
  _DosenAkunDashboardPageState createState() => _DosenAkunDashboardPageState();
}

class _DosenAkunDashboardPageState extends State<DosenAkunDashboardPage> {
  String npp = "";
  String namadsn = "";

  bool lightSwitch = false;
  bool notifSwitch = false;

  @override
  void initState() {
    super.initState();
    getDataDosen();
  }

  getDataDosen() async {
    SharedPreferences loginDosen = await SharedPreferences.getInstance();

    npp = loginDosen.getString('npp');
    namadsn = loginDosen.getString('namadsn');
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
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () => Get.toNamed('/dosen/dashboard/akun/informasi'),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25)),
                        // decoration: BoxDecoration(),
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(22),
                                // child: ClipRRect(
                                //   borderRadius: BorderRadius.circular(8.0),
                                //   child: Image.asset(
                                //     'person-male'.png,
                                //     height: 150.0,
                                //     width: 100.0,
                                //   ),
                                // ),
                                child: CircleAvatar(
                                    backgroundColor: Colors.grey[350],
                                    radius: 50,
                                    // child: const Text('NV'),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        'person-male'.png,
                                      ),
                                    ))),
                            Center(
                                child: Column(
                              children: [
                                Text(namadsn,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'WorkSansMedium',
                                        fontSize: 24)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  npp,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'WorkSansMedium',
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ))
                          ],
                        ))),
              ),
              SizedBox(
                height: 8,
              ),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       left: 14, right: 14, top: 14, bottom: 14),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         color: Colors.grey[200],
                    //         borderRadius: BorderRadius.circular(25)),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: <Widget>[
                    //         Padding(
                    //           padding: EdgeInsets.all(20),
                    //           child: Row(
                    //             children: [
                    //               Icon(
                    //                 Icons.notifications_active,
                    //                 color: Colors.black,
                    //               ),
                    //               SizedBox(
                    //                 width: 10,
                    //               ),
                    //               Text(
                    //                 'Notifikasi Kelas',
                    //                 style: TextStyle(
                    //                     fontSize: 20,
                    //                     fontFamily: 'WorkSansMedium',
                    //                     fontWeight: FontWeight.bold),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         Align(
                    //           alignment: Alignment.bottomRight,
                    //           child: Switch(
                    //               value: notifSwitch,
                    //               onChanged: (value) {
                    //                 setState(() {
                    //                   notifSwitch = value;
                    //                   print(notifSwitch);
                    //                 });
                    //               }),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
                                        fontFamily: 'WorkSansMedium',
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
                                            fontFamily: 'WorkSansMedium',
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
                                            fontFamily: 'WorkSansMedium',
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
                          onTap: () async {
                            SharedPreferences autoLogin =
                                await SharedPreferences.getInstance();
                            autoLogin.clear();
                            Get.offAllNamed('/');

                            Fluttertoast.showToast(
                                msg: 'Anda telah keluar',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 14.0);
                          },
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
                                            fontFamily: 'WorkSansMedium',
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
