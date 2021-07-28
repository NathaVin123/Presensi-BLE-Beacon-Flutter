import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DosenMenuBeaconPage extends StatefulWidget {
  @override
  _DosenMenuBeaconPageState createState() => _DosenMenuBeaconPageState();
}

class _DosenMenuBeaconPageState extends State<DosenMenuBeaconPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            pinned: true,
            floating: false,
            snap: false,
            expandedHeight: 85,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Konfigurasi Beacon',
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
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.only(left: 14, right: 14, bottom: 14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () => Get.toNamed(
                              '/dosen/dashboard/akun/beacon/pindai'),
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
                          onTap: () => Get.toNamed(
                              '/dosen/dashboard/akun/beacon/tambah'),
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
                          onTap: () =>
                              Get.toNamed('/dosen/dashboard/akun/beacon/ubah'),
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
                          onTap: () =>
                              Get.toNamed('/dosen/dashboard/akun/beacon/hapus'),
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
