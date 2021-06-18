import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:presensiblebeacon/MODEL/Mahasiswa/JadwalMahasiswaModel.dart';
// import 'package:presensiblebeacon/MODEL/Mahasiswa/JadwalMahasiswaModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MahasiswaJadwalDashboardPage extends StatefulWidget {
  MahasiswaJadwalDashboardPage({Key key}) : super(key: key);

  @override
  _MahasiswaJadwalDashboardPageState createState() =>
      _MahasiswaJadwalDashboardPageState();
}

class _MahasiswaJadwalDashboardPageState
    extends State<MahasiswaJadwalDashboardPage> {
  String _dateString;

  String npm = "";
  String semester = '6';

  String namamk = "";

  @override
  void initState() {
    super.initState();

    getDataMahasiswa();

    _dateString = _formatDate(DateTime.now());

    Timer.periodic(Duration(hours: 1), (Timer t) => _getDate());
  }

  getDataMahasiswa() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();
    setState(() {
      npm = loginMahasiswa.getString('npm');
    });
  }

  Future getJadwalDataFromAPI(String npm, String semester) async {
    final queryParams = {'NPM': npm, 'SEMESTER': semester};

    String queryString = Uri(queryParameters: queryParams).query;

    var response = await http.get(Uri.https('192.168.100.227:5000',
        'api' + 'jadwalmhs' + 'postgetall' + '?' + queryString));

    var jsonData = jsonDecode(response.body);
    List<Data> jadwalmhs = [];

    for (var d in jsonData) {
      Data data = Data(d['kodemk'], d["namamk"], d["kelas"], d["sks"],
          d["namadosen"], d["hari"], d["sesi"], d["semester"], d["ruang"]);
      jadwalmhs.add(data);
    }
    print(jadwalmhs.length);
    return jadwalmhs;
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
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Reload'),
          onPressed: () => null,
        ),
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
                'Jadwal Kelas',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSansMedium'),
              ),
            ),
          ),
          SliverFillRemaining(
            child: FutureBuilder(
              future: getJadwalDataFromAPI(npm, semester),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(child: Text('Loading...')),
                  );
                } else
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(snapshot.data[i].namamk),
                      );
                    },
                  );
              },
            ),
          )
          // SliverList(
          //   delegate: SliverChildListDelegate([
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
          // SingleChildScrollView(
          //   child: Column(
          //     children: <Widget>[
          //       Padding(
          //           padding: EdgeInsets.only(top: 10, bottom: 10),
          //           child: Column(
          //             children: <Widget>[
          //               Padding(
          //                 padding: const EdgeInsets.all(10),
          //                 child: Text(
          //                   _dateString,
          //                   style: TextStyle(
          //                       fontSize: 22, fontFamily: 'WorkSansMedium'),
          //                 ),
          //               ),
          //               Text(
          //                 'Kuliah Hari Ini',
          //                 style: TextStyle(
          //                     color: Colors.black,
          //                     fontWeight: FontWeight.bold,
          //                     fontFamily: 'WorkSansMedium',
          //                     fontSize: 20),
          //               ),
          //               Padding(
          //                 padding:
          //                     const EdgeInsets.only(top: 10, bottom: 10),
          //                 child: CarouselSlider(
          //                   items: [
          //                     Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Container(
          //                         decoration: BoxDecoration(
          //                             color: Colors.grey[200],
          //                             borderRadius:
          //                                 BorderRadius.circular(25)),
          //                         child: Padding(
          //                           padding: EdgeInsets.all(10),
          //                           child: Column(
          //                             children: [
          //                               Align(
          //                                 alignment: Alignment.centerLeft,
          //                                 child: Padding(
          //                                   padding:
          //                                       const EdgeInsets.all(5.0),
          //                                   child: Text('Mata Kuliah : -',
          //                                       style: TextStyle(
          //                                           fontSize: 14,
          //                                           fontWeight:
          //                                               FontWeight.bold,
          //                                           fontFamily:
          //                                               'WorkSansMedium')),
          //                                 ),
          //                               ),
          //                               Align(
          //                                 alignment: Alignment.centerLeft,
          //                                 child: Padding(
          //                                   padding:
          //                                       const EdgeInsets.all(5.0),
          //                                   child: Text('Ruangan : -',
          //                                       style: TextStyle(
          //                                           fontSize: 14,
          //                                           fontWeight:
          //                                               FontWeight.bold,
          //                                           fontFamily:
          //                                               'WorkSansMedium')),
          //                                 ),
          //                               ),
          //                               Align(
          //                                 alignment: Alignment.centerLeft,
          //                                 child: Padding(
          //                                   padding:
          //                                       const EdgeInsets.all(5.0),
          //                                   child: Text('Sesi : -',
          //                                       style: TextStyle(
          //                                           fontSize: 14,
          //                                           fontWeight:
          //                                               FontWeight.bold,
          //                                           fontFamily:
          //                                               'WorkSansMedium')),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                   options: CarouselOptions(
          //                       initialPage: 0,
          //                       enlargeCenterPage: false,
          //                       height: 125,
          //                       scrollDirection: Axis.horizontal,
          //                       autoPlay: true,
          //                       autoPlayAnimationDuration:
          //                           Duration(seconds: 1)),
          //                 ),
          //               ),
          //             ],
          //           )),
          //       Divider(
          //         height: 20,
          //         thickness: 5,
          //       ),
          //       Padding(
          //         padding: EdgeInsets.all(10),
          //         child: Column(
          //           children: <Widget>[
          //             Padding(
          //               padding: const EdgeInsets.all(10),
          //               child: Text(
          //                 'Jadwal yang akan datang',
          //                 style: TextStyle(
          //                     color: Colors.black,
          //                     fontWeight: FontWeight.bold,
          //                     fontFamily: 'WorkSansMedium',
          //                     fontSize: 20),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(top: 10, bottom: 10),
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                     color: Colors.grey[200],
          //                     borderRadius: BorderRadius.circular(25)),
          //                 child: Flexible(
          //                   child: Column(
          //                     children: <Widget>[
          //                       Padding(
          //                         padding: const EdgeInsets.all(10),
          //                         child: Row(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceAround,
          //                           children: <Widget>[
          //                             Padding(
          //                               padding: const EdgeInsets.all(10),
          //                               child: Text(
          //                                 'Sesi 1',
          //                                 style: TextStyle(
          //                                     color: Colors.black,
          //                                     fontWeight: FontWeight.bold,
          //                                     fontFamily: 'WorkSansMedium',
          //                                     fontSize: 16),
          //                               ),
          //                             ),
          //                             Container(
          //                               decoration: BoxDecoration(
          //                                   color: Colors.yellow[600],
          //                                   borderRadius:
          //                                       BorderRadius.circular(25)),
          //                               child: Padding(
          //                                 padding: const EdgeInsets.all(10),
          //                                 child: Text(
          //                                   'SABTU',
          //                                   style: TextStyle(
          //                                       color: Colors.white,
          //                                       fontWeight: FontWeight.bold,
          //                                       fontFamily:
          //                                           'WorkSansMedium',
          //                                       fontSize: 16),
          //                                 ),
          //                               ),
          //                             ),
          //                             Padding(
          //                               padding: const EdgeInsets.all(10),
          //                               child: Text(
          //                                 'R.3315',
          //                                 style: TextStyle(
          //                                     color: Colors.black,
          //                                     fontWeight: FontWeight.bold,
          //                                     fontFamily: 'WorkSansMedium',
          //                                     fontSize: 16),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                       Divider(
          //                         height: 10,
          //                         thickness: 5,
          //                       ),
          //                       Padding(
          //                         padding: const EdgeInsets.all(10),
          //                         child: Column(
          //                           children: <Widget>[
          //                             Center(
          //                               child: Text(
          //                                 'Magang',
          //                                 style: TextStyle(
          //                                     color: Colors.black,
          //                                     fontWeight: FontWeight.bold,
          //                                     fontFamily: 'WorkSansMedium',
          //                                     fontSize: 20),
          //                               ),
          //                             ),
          //                             SizedBox(
          //                               height: 5,
          //                             ),
          //                             Center(
          //                               child: Text(
          //                                 'Kelas A',
          //                                 style: TextStyle(
          //                                     color: Colors.grey,
          //                                     fontWeight: FontWeight.bold,
          //                                     fontFamily: 'WorkSansMedium',
          //                                     fontSize: 18),
          //                               ),
          //                             ),
          //                             SizedBox(
          //                               height: 5,
          //                             ),
          //                             Center(
          //                               child: Text(
          //                                 'Dosen Tek. Informatika',
          //                                 style: TextStyle(
          //                                     color: Colors.grey,
          //                                     fontWeight: FontWeight.bold,
          //                                     fontFamily: 'WorkSansMedium',
          //                                     fontSize: 18),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // )
          // ]),
          // )
        ]));
  }
}
