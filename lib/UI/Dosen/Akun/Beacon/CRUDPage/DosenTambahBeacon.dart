import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DosenTambahBeacon extends StatefulWidget {
  @override
  _DosenTambahBeaconState createState() => _DosenTambahBeaconState();
}

class _DosenTambahBeaconState extends State<DosenTambahBeacon> {
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
                'Tambah Beacon',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Mata Kuliah',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'WorkSansMedium',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: DropdownButton(
                        items: null,
                        onTap: () => null,
                        value: null,
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Ruang Kelas',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'WorkSansMedium',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: DropdownButton(
                        items: null,
                        onTap: () => null,
                        value: null,
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'UUID',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'WorkSansMedium',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: TextFormField()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Jarak Minimal',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'WorkSansMedium',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        items: null,
                        onTap: () => null,
                        value: null,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                        color: Colors.blue,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Pindai Beacon",
                          style: const TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 18.0,
                              color: Colors.white),
                        ),
                        onPressed: () =>
                            Get.toNamed('/dosen/dashboard/akun/beacon/pindai')),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                        color: Colors.blue,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "SIMPAN",
                          style: const TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 18.0,
                              color: Colors.white),
                        ),
                        onPressed: () {}),
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
