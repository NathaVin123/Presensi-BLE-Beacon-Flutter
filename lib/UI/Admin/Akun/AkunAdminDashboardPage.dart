import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sk_alert_dialog/sk_alert_dialog.dart';

class AkunAdminDashboardPage extends StatefulWidget {
  AkunAdminDashboardPage({Key key}) : super(key: key);

  @override
  _AkunAdminDashboardPageState createState() => _AkunAdminDashboardPageState();
}

class _AkunAdminDashboardPageState extends State<AkunAdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'AKUN SAYA',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'WorkSansMedium'),
          ),
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(23, 75, 137, 1)),
          child: Column(
            children: <Widget>[
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
        ));
  }
}
