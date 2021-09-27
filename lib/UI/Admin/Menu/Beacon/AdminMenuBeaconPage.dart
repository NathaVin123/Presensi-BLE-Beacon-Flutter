import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminMenuBeaconPage extends StatefulWidget {
  @override
  _AdminMenuBeaconPageState createState() => _AdminMenuBeaconPageState();
}

class _AdminMenuBeaconPageState extends State<AdminMenuBeaconPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color.fromRGBO(23, 75, 137, 1),
            pinned: true,
            floating: false,
            snap: false,
            expandedHeight: 85,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Konfigurasi Beacon',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.only(left: 14, right: 14, bottom: 14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () => Get.toNamed('/admin/menu/beacon/pindai'),
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
                                        FontAwesomeIcons.search,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 11,
                                      ),
                                      Text(
                                        'Pindai Beacon',
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
                          onTap: () => Get.toNamed('/admin/menu/beacon/tampil'),
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
                                        FontAwesomeIcons.list,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 11,
                                      ),
                                      Text(
                                        'Tampil Beacon',
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
                          onTap: () => Get.toNamed('/admin/menu/beacon/tambah'),
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
                                        FontAwesomeIcons.plus,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 11,
                                      ),
                                      Text(
                                        'Tambah Beacon',
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
                          onTap: () => Get.toNamed('/admin/menu/beacon/ubah'),
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
                                        'Ubah Beacon',
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
                          onTap: () => Get.toNamed('/admin/menu/beacon/hapus'),
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
                                        FontAwesomeIcons.trash,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 11,
                                      ),
                                      Text(
                                        'Hapus Beacon',
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
              ),
            ],
          ))
        ],
      ),
    );
  }
}
