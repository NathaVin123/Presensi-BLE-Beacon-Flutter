import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DosenDetailPresensiPage extends StatefulWidget {
  @override
  _DosenDetailPresensiPageState createState() =>
      _DosenDetailPresensiPageState();
}

class _DosenDetailPresensiPageState extends State<DosenDetailPresensiPage> {
  String ruang = "";
  String namamk = "";
  String hari = "";
  String sesi = "";
  String jam = "";
  String tanggal = "";

  @override
  void initState() {
    super.initState();

    getDetailKelas();
  }

  getDetailKelas() async {
    SharedPreferences dataPresensiDosen = await SharedPreferences.getInstance();

    setState(() {
      ruang = dataPresensiDosen.getString('ruang');
      namamk = dataPresensiDosen.getString('namamk');
      hari = dataPresensiDosen.getString('hari');
      sesi = dataPresensiDosen.getString('sesi');
      jam = dataPresensiDosen.getString('jam');
      tanggal = dataPresensiDosen.getString('tanggal');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
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
                'Presensi',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25)),
                  child: new Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Tanggal',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                tanggal,
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Ruangan',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                ruang,
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Mata Kuliah',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                namamk,
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Kelas',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '-',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Jam Masuk',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                jam,
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Jam Keluar',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '-',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Divider(
                  height: 20,
                  thickness: 10,
                ),
                new Align(
                  child: new Padding(
                    padding: EdgeInsets.all(10),
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MaterialButton(
                            color: Colors.blue,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.only(
                                left: 50, right: 50, top: 25, bottom: 25),
                            onPressed: () => {
                              Get.toNamed(
                                  '/mahasiswa/dashboard/presensi/detail/tampilpeserta')
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  'Lihat Peserta Kelas',
                                  style: TextStyle(
                                      fontFamily: 'WorkSansMedium',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            color: Colors.green,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.only(
                                left: 50, right: 50, top: 25, bottom: 25),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  'Masuk',
                                  style: TextStyle(
                                      fontFamily: 'WorkSansMedium',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            color: Colors.grey,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.only(
                                left: 50, right: 50, top: 25, bottom: 25),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_downward_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  'Keluar',
                                  style: TextStyle(
                                      fontFamily: 'WorkSansMedium',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            color: Colors.red,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.only(
                                left: 50, right: 50, top: 25, bottom: 25),
                            onPressed: () =>
                                {Get.offAllNamed('/dosen/dashboard')},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  'Kembali ke Menu',
                                  style: TextStyle(
                                      fontFamily: 'WorkSansMedium',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
