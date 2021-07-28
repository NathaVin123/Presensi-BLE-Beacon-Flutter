import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MahasiswaDetailPresensiPage extends StatefulWidget {
  @override
  _MahasiswaDetailPresensiPageState createState() =>
      _MahasiswaDetailPresensiPageState();
}

class _MahasiswaDetailPresensiPageState
    extends State<MahasiswaDetailPresensiPage> {
  // String kelas = "";
  // String jam = "";
  // String tanggal = "";

  // void getModalKelas() async {
  //   SharedPreferences modalKelas = await SharedPreferences.getInstance();
  //   setState(() {
  //     kelas = modalKelas.getString('Kelas');
  //     jam = modalKelas.getString('Jam');
  //     tanggal = modalKelas.getString('Tanggal');
  //   });
  // }

  String ruang = "";
  String namamk = "";
  String namadosen = "";
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
    SharedPreferences dataPresensiMahasiswa =
        await SharedPreferences.getInstance();

    setState(() {
      ruang = dataPresensiMahasiswa.getString('ruang');
      namamk = dataPresensiMahasiswa.getString('namamk');
      namadosen = dataPresensiMahasiswa.getString('namadosen');
      hari = dataPresensiMahasiswa.getString('hari');
      sesi = dataPresensiMahasiswa.getString('sesi');
      jam = dataPresensiMahasiswa.getString('jam');
      tanggal = dataPresensiMahasiswa.getString('tanggal');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Container(
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                // new Center(
                //   child: Padding(
                //     padding: EdgeInsets.only(top: 25, bottom: 10),
                //     child: new Text(
                //       'Presensi',
                //       style: TextStyle(
                //           fontFamily: 'WorkSansMedium',
                //           fontWeight: FontWeight.bold,
                //           fontSize: 24),
                //     ),
                //   ),
                // ),
                // Divider(
                //   height: 20,
                //   thickness: 5,
                // ),
                new Padding(
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
                              'Dosen',
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
                              namadosen,
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
                new Align(
                  child: new Padding(
                    padding: EdgeInsets.all(10),
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MaterialButton(
                            color: Colors.green,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.only(
                                left: 125, right: 125, top: 25, bottom: 25),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'MASUK',
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
                          // MaterialButton(
                          //   color: Colors.red,
                          //   shape: StadiumBorder(),
                          //   padding: EdgeInsets.only(
                          //       left: 125, right: 125, top: 25, bottom: 25),
                          //   onPressed: () {},
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //     children: <Widget>[
                          //       Icon(
                          //         Icons.arrow_downward_rounded,
                          //         color: Colors.white,
                          //       ),
                          //       SizedBox(
                          //         height: 10,
                          //       ),
                          //       Text(
                          //         'KELUAR',
                          //         style: TextStyle(
                          //             fontFamily: 'WorkSansMedium',
                          //             fontWeight: FontWeight.bold,
                          //             color: Colors.white,
                          //             fontSize: 18),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
