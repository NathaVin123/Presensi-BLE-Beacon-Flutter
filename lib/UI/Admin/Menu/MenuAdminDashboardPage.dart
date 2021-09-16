import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MenuAdminDashboardPage extends StatefulWidget {
  MenuAdminDashboardPage({Key key}) : super(key: key);

  @override
  _MenuAdminDashboardPageState createState() => _MenuAdminDashboardPageState();
}

class _MenuAdminDashboardPageState extends State<MenuAdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'ADMIN',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'WorkSansMedium'),
          ),
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(23, 75, 137, 1)),
          // decoration: BoxDecoration(color: Colors.black),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () => Get.toNamed('/admin/menu/beacon'),
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
                                  FontAwesomeIcons.bluetooth,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 11,
                                ),
                                Text(
                                  'Pengaturan Beacon',
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
                    onTap: () => Get.toNamed('/admin/menu/ruangan/menu'),
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
                                  Icons.room_preferences_outlined,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 11,
                                ),
                                Text(
                                  'Pengaturan Ruangan',
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
                    onTap: () => {},
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
                                  FontAwesomeIcons.edit,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 11,
                                ),
                                Text(
                                  'Ubah Jadwal Kelas',
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
            ],
          ),
        ));
  }
}
