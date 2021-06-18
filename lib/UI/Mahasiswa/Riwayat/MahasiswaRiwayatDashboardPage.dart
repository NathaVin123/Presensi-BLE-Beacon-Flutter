import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presensiblebeacon/MODEL/Mahasiswa/RiwayatMahasiswaModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class MahasiswaRiwayatDashboardPage extends StatefulWidget {
  MahasiswaRiwayatDashboardPage({Key key}) : super(key: key);

  @override
  _MahasiswaRiwayatDashboardPageState createState() =>
      _MahasiswaRiwayatDashboardPageState();
}

class _MahasiswaRiwayatDashboardPageState
    extends State<MahasiswaRiwayatDashboardPage> {
  String npm = "";
  String semester = '6';

  String namamk = "";

  @override
  void initState() {
    super.initState();

    getDataMahasiswa();
  }

  getDataMahasiswa() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();
    setState(() {
      npm = loginMahasiswa.getString('npm');
    });
  }

  Future getRiwayatDataFromAPI(String npm, String semester) async {
    final queryParams = {'NPM': npm, 'SEMESTER': semester};

    String queryString = Uri(queryParameters: queryParams).query;

    var response = await http.get(Uri.https('192.168.100.227:5000',
        'api' + 'riwayatmhs' + 'postgetall' + '?' + queryString));

    var jsonData = jsonDecode(response.body);
    List<Data> riwayatmhs = [];

    for (var r in jsonData) {
      Data data = Data(r['idkelas'], r["namamk"], r["pertemuan"], r["status"],
          r["tglin"], r["tglout"], r["tglverifikasi"], r["semester"]);
      riwayatmhs.add(data);
    }

    print(riwayatmhs.length);
    return riwayatmhs;
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
                  'Riwayat Kelas',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'WorkSansMedium',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
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
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            '03/06/2021',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'WorkSansMedium',
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'Pertemuan ke - 5',
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
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Dosen Tek. Informatika',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
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
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            '03/05/2021',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'WorkSansMedium',
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'Pertemuan ke - 4',
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
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Dosen Tek. Informatika',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
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
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            '03/04/2021',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'WorkSansMedium',
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'Pertemuan ke - 3',
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
                                          'Kelas E',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Dosen Tek. Informatika',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
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
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            '03/03/2021',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'WorkSansMedium',
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'Pertemuan ke - 2',
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
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Dosen Tek. Informatika',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
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
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            '03/02/2021',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'WorkSansMedium',
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'Pertemuan ke - 1',
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
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Dosen Tek. Informatika',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
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
              ]),
            )
          ],
        ));
  }
}
