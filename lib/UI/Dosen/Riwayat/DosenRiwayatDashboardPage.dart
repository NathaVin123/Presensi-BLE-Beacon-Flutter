import 'dart:async';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Dosen/RiwayatDosenModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DosenRiwayatDashboardPage extends StatefulWidget {
  DosenRiwayatDashboardPage({Key key}) : super(key: key);

  @override
  _DosenRiwayatDashboardPageState createState() =>
      _DosenRiwayatDashboardPageState();
}

class _DosenRiwayatDashboardPageState extends State<DosenRiwayatDashboardPage> {
  String _timeString;
  String _dateString;

  String npp = "";

  DateTime timeNow = DateTime.now();

  RiwayatDosenRequestModel riwayatDosenRequestModel;

  RiwayatDosenResponseModel riwayatDosenResponseModel;
  @override
  void initState() {
    super.initState();

    riwayatDosenRequestModel = RiwayatDosenRequestModel();
    riwayatDosenResponseModel = RiwayatDosenResponseModel();

    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Timer.periodic(Duration(hours: 1), (Timer t) => _getDate());

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getDataDosen();
      getDataRiwayatDosen();
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

  void getDataRiwayatDosen() async {
    setState(() {
      riwayatDosenRequestModel.npp = npp;

      print(riwayatDosenRequestModel.toJson());
      APIService apiService = new APIService();
      apiService.postRiwayatDosen(riwayatDosenRequestModel).then((value) async {
        riwayatDosenResponseModel = value;
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
          onPressed: () => getDataRiwayatDosen()),
      backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        centerTitle: true,
        title: Text(
          'Riwayat Presensi Kuliah',
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
          ),
          riwayatDosenResponseModel.data == null ||
                  riwayatDosenResponseModel.data.isEmpty
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
                                  'Riwayat kuliah anda kosong',
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
                        itemCount: riwayatDosenResponseModel.data?.length,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                '${riwayatDosenResponseModel.data[index].hari1}, ${riwayatDosenResponseModel.data[index].tglmasuk}',
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
                                    Scrollbar(
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: new Text(
                                                        '${riwayatDosenResponseModel.data[index].namamk} ${riwayatDosenResponseModel.data[index].kelas}',
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
                                    new Text(
                                      'Pertemuan ke - ${riwayatDosenResponseModel.data[index].pertemuan}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'WorkSansMedium',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Tekan untuk melihat detail riwayat',
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
