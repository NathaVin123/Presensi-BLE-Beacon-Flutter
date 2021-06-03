import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presensiblebeacon/MODEL/JadwalMahasiswaModel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:intl/intl.dart';

class DosenJadwalDashboardPage extends StatefulWidget {
  DosenJadwalDashboardPage({Key key}) : super(key: key);

  @override
  _DosenJadwalDashboardPageState createState() =>
      _DosenJadwalDashboardPageState();
}

class _DosenJadwalDashboardPageState extends State<DosenJadwalDashboardPage> {
  // JadwalMahasiswaRequestModel jadwalMahasiswaRequestModel;
  // GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  // final _jadwal = <JadwalMahasiswaRequestModel>[];
  String _dateString;
  @override
  void initState() {
    super.initState();

    // jadwalMahasiswaRequestModel = new JadwalMahasiswaRequestModel();

    _dateString = _formatDate(DateTime.now());
    Timer.periodic(Duration(hours: 1), (Timer t) => _getDate());

    // APIService apiService = new APIService();
    // apiService
    //     .jadwalMahasiswa(jadwalMahasiswaRequestModel)
    //     .then((value) async {});
  }

  void _getDate() {
    final DateTime now = DateTime.now();
    final String formattedDate = _formatDate(now);

    setState(() {
      _dateString = formattedDate;
    });
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(slivers: <Widget>[
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
                'Jadwal',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSansMedium'),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Shimmer.fromColors(
              //   baseColor: Colors.grey[200],
              //   highlightColor: Colors.grey[100],
              //   enabled: true,
              //   child: Column(
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.all(10),
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: Colors.grey,
              //               borderRadius: BorderRadius.circular(25)),
              //           child: Flexible(
              //             child: ListTile(
              //               title: Text(' '),
              //               subtitle: Text(' '),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.all(10),
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: Colors.grey,
              //               borderRadius: BorderRadius.circular(25)),
              //           child: Flexible(
              //             child: ListTile(
              //               title: Text(' '),
              //               subtitle: Text(' '),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.all(10),
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: Colors.grey,
              //               borderRadius: BorderRadius.circular(25)),
              //           child: Flexible(
              //             child: ListTile(
              //               title: Text(' '),
              //               subtitle: Text(' '),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.all(10),
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: Colors.grey,
              //               borderRadius: BorderRadius.circular(25)),
              //           child: Flexible(
              //             child: ListTile(
              //               title: Text(' '),
              //               subtitle: Text(' '),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.all(10),
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: Colors.grey,
              //               borderRadius: BorderRadius.circular(25)),
              //           child: Flexible(
              //             child: ListTile(
              //               title: Text(' '),
              //               subtitle: Text(' '),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.all(10),
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: Colors.grey,
              //               borderRadius: BorderRadius.circular(25)),
              //           child: Flexible(
              //             child: ListTile(
              //               title: Text(' '),
              //               subtitle: Text(' '),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.all(10),
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: Colors.grey,
              //               borderRadius: BorderRadius.circular(25)),
              //           child: Flexible(
              //             child: ListTile(
              //               title: Text(' '),
              //               subtitle: Text(' '),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.all(10),
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: Colors.grey,
              //               borderRadius: BorderRadius.circular(25)),
              //           child: Flexible(
              //             child: ListTile(
              //               title: Text(' '),
              //               subtitle: Text(' '),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // )
              // SingleChildScrollView(
              //   child: Column(
              //     children: ListTile.divideTiles(
              //         context: context,
              //         tiles: _jadwal.map((jadwal) {
              //           return Padding(
              //             padding: EdgeInsets.all(10),
              //             child: Container(
              //               decoration: BoxDecoration(
              //                   color: Colors.grey[200],
              //                   borderRadius: BorderRadius.circular(25)),
              //             ),
              //           );
              //         })),
              //   ),
              // )
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                _dateString,
                                style: TextStyle(
                                    fontSize: 22, fontFamily: 'WorkSansMedium'),
                              ),
                            ),
                            Text(
                              'Kelas Hari Ini',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSansMedium',
                                  fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(25)),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('-'),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Divider(
                      height: 20,
                      thickness: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Jadwal yang akan datang',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSansMedium',
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(25)),
                              child: Flexible(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              'Sesi 1',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.yellow[600],
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                'SABTU',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              'R.3315',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 10,
                                      thickness: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              'Magang',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontSize: 20),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Center(
                                            child: Text(
                                              'Kelas B',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontSize: 18),
                                            ),
                                          ),
                                          // Center(
                                          //   child: Text(
                                          //     'Dosen Tek. Informatika',
                                          //     style: TextStyle(
                                          //         color: Colors.grey,
                                          //         fontWeight: FontWeight.bold,
                                          //         fontFamily: 'WorkSansMedium',
                                          //         fontSize: 18),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(25)),
                              child: Flexible(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              'Sesi 2',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.yellow[600],
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                'Senin',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              'R.3317',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 10,
                                      thickness: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              'Magang',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontSize: 20),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Center(
                                            child: Text(
                                              'Kelas A',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontSize: 18),
                                            ),
                                          ),
                                          // Center(
                                          //   child: Text(
                                          //     'Dosen Tek. Informatika',
                                          //     style: TextStyle(
                                          //         color: Colors.grey,
                                          //         fontWeight: FontWeight.bold,
                                          //         fontFamily: 'WorkSansMedium',
                                          //         fontSize: 18),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]),
          )
        ]));
  }
}
