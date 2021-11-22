import 'dart:async';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Dosen/JadwalDosenModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DosenJadwalDashboardPage extends StatefulWidget {
  DosenJadwalDashboardPage({Key key}) : super(key: key);

  @override
  _DosenJadwalDashboardPageState createState() =>
      _DosenJadwalDashboardPageState();
}

class _DosenJadwalDashboardPageState extends State<DosenJadwalDashboardPage> {
  String _timeString;
  String _dateString;

  String npp = "";

  DateTime timeNow = DateTime.now();

  JadwalDosenRequestModel jadwalDosenRequestModel;

  JadwalDosenResponseModel jadwalDosenResponseModel;
  @override
  void initState() {
    super.initState();

    jadwalDosenRequestModel = JadwalDosenRequestModel();
    jadwalDosenResponseModel = JadwalDosenResponseModel();

    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Timer.periodic(Duration(hours: 1), (Timer t) => _getDate());

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getDataDosen();
      getDataJadwalDosen();
      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });
  }

  getDataDosen() async {
    SharedPreferences loginDosen = await SharedPreferences.getInstance();
    setState(() {
      npp = loginDosen.getString('npp');
    });
  }

  void getDataJadwalDosen() async {
    setState(() {
      jadwalDosenRequestModel.npp = npp;

      print(jadwalDosenRequestModel.toJson());
      APIService apiService = new APIService();
      apiService.postJadwalDosen(jadwalDosenRequestModel).then((value) async {
        jadwalDosenResponseModel = value;
      });
    });
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = _formatTime(now);

    setState(() {
      _timeString = formattedTime;
    });
  }

  void _getDate() {
    final DateTime now = DateTime.now();
    final String formattedDate = _formatDate(now);

    setState(() {
      _dateString = formattedDate;
    });
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('d MMMM y').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          label: Text('Segarkan'),
          icon: Icon(Icons.refresh_rounded),
          onPressed: () => getDataJadwalDosen()),
      backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        centerTitle: true,
        title: Text(
          'Jadwal Kuliah',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'WorkSansMedium',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        _dateString,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'WorkSansMedium',
                            color: Colors.white),
                      ),
                    ),
                    Center(
                      child: Text(
                        _timeString,
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'WorkSansMedium',
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Kuliah Selanjutnya',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'WorkSansMedium',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          jadwalDosenResponseModel.data == null ||
                  jadwalDosenResponseModel.data.isEmpty
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Jadwal kuliah anda kosong',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'WorkSansMedium',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                        itemCount: jadwalDosenResponseModel.data?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 8, bottom: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(25)),
                              child: new ListTile(
                                title: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Scrollbar(
                                        child: Center(
                                          child: Container(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: new Text(
                                                          '${jadwalDosenResponseModel.data[index].namamk} ${jadwalDosenResponseModel.data[index].kelas}',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'WorkSansMedium',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    new Text(
                                      'Pertemuan ke - ${jadwalDosenResponseModel.data[index].pertemuan}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'WorkSansMedium',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                jadwalDosenResponseModel
                                                    .data[index].hari1,
                                                style: TextStyle(
                                                  color: Colors.grey[50],
                                                  fontSize: 14,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                jadwalDosenResponseModel
                                                    .data[index].tglmasuk,
                                                style: TextStyle(
                                                  color: Colors.grey[50],
                                                  fontSize: 14,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Sesi ${jadwalDosenResponseModel.data[index].sesi1}',
                                                style: TextStyle(
                                                  color: Colors.grey[50],
                                                  fontSize: 14,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Tekan untuk melihat detail kuliah',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontFamily: 'WorkSansMedium',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () async {
                                  // await Get.toNamed(
                                  //     '/mahasiswa/dashboard/jadwal/detail');
                                },
                              ),
                            ),
                          );
                        }),
                  ),
                )
        ],
      ),
    );
  }
}
