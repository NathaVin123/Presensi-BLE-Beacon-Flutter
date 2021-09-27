import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sk_alert_dialog/sk_alert_dialog.dart';

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
      backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        centerTitle: true,
        title: Text(
          'Akun Saya',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'WorkSansMedium',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
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
                          child: Initicon(
                            text: namadsn,
                            backgroundColor: Colors.grey[400],
                            size: 80,
                          ),
                        ),
                        Center(
                            child: Column(
                          children: [
                            Text(namadsn,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'WorkSansMedium',
                                    fontSize: 18)),
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
                Padding(
                    padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () => Get.toNamed('/statistik/dosen'),
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
                // Padding(
                //     padding:
                //         EdgeInsets.only(left: 14, right: 14, bottom: 14),
                //     child: InkWell(
                //       borderRadius: BorderRadius.circular(25),
                //       onTap: () =>
                //           Get.toNamed('/dosen/dashboard/akun/beacon'),
                //       child: Container(
                //         decoration: BoxDecoration(
                //             color: Colors.grey[200],
                //             borderRadius: BorderRadius.circular(25)),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: <Widget>[
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: 24, right: 20, top: 20, bottom: 20),
                //               child: Row(
                //                 children: [
                //                   Icon(
                //                     FontAwesomeIcons.bluetooth,
                //                     color: Colors.black,
                //                     size: 20,
                //                   ),
                //                   SizedBox(
                //                     width: 11,
                //                   ),
                //                   Text(
                //                     'Konfigurasi Beacon',
                //                     style: TextStyle(
                //                         fontSize: 20,
                //                         fontFamily: 'WorkSansMedium',
                //                         fontWeight: FontWeight.bold),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     )),
                Padding(
                    padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () =>
                          Get.toNamed('/dosen/dashboard/akun/gantipassword'),
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
                                    FontAwesomeIcons.userLock,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 11,
                                  ),
                                  Text(
                                    'Ubah Password',
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
                    padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
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
                    padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        SKAlertDialog.show(
                          context: context,
                          type: SKAlertType.buttons,
                          title: 'LOG OUT',
                          message: 'Apakah anda yakin ingin keluar?',
                          okBtnText: 'Ya',
                          okBtnTxtColor: Colors.white,
                          okBtnColor: Colors.red,
                          cancelBtnText: 'Tidak',
                          cancelBtnTxtColor: Colors.white,
                          cancelBtnColor: Colors.grey,
                          onOkBtnTap: (value) async {
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
                          onCancelBtnTap: (value) {},
                        );
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
      ),
    );
  }
}
