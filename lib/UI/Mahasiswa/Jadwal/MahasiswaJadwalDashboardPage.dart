import 'dart:async';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Mahasiswa/JadwalMahasiswaModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MahasiswaJadwalDashboardPage extends StatefulWidget {
  MahasiswaJadwalDashboardPage({Key key}) : super(key: key);

  @override
  _MahasiswaJadwalDashboardPageState createState() =>
      _MahasiswaJadwalDashboardPageState();
}

class _MahasiswaJadwalDashboardPageState
    extends State<MahasiswaJadwalDashboardPage> {
  String _timeString;
  String _dateString;

  String npm = "";

  DateTime timeNow = DateTime.now();

  JadwalMahasiswaRequestModel jadwalMahasiswaRequestModel;

  JadwalMahasiswaResponseModel jadwalMahasiswaResponseModel;
  @override
  void initState() {
    super.initState();

    jadwalMahasiswaRequestModel = JadwalMahasiswaRequestModel();
    jadwalMahasiswaResponseModel = JadwalMahasiswaResponseModel();

    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Timer.periodic(Duration(hours: 1), (Timer t) => _getDate());

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getDataMahasiswa();
      getDataJadwalMahasiswa();
      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });
  }

  getDataMahasiswa() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();
    setState(() {
      npm = loginMahasiswa.getString('npm');
    });
  }

  void getDataJadwalMahasiswa() async {
    setState(() {
      jadwalMahasiswaRequestModel.npm = npm;

      print(jadwalMahasiswaRequestModel.toJson());
      APIService apiService = new APIService();
      apiService
          .postJadwalMahasiswa(jadwalMahasiswaRequestModel)
          .then((value) async {
        jadwalMahasiswaResponseModel = value;
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
          onPressed: () => getDataJadwalMahasiswa()),
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
                        'Kuliah 1 Minggu Selanjutnya',
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
          jadwalMahasiswaResponseModel.data == null ||
                  jadwalMahasiswaResponseModel.data.isEmpty
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
                        itemCount: jadwalMahasiswaResponseModel.data?.length,
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
                                                          '${jadwalMahasiswaResponseModel.data[index].namamk} ${jadwalMahasiswaResponseModel.data[index].kelas}',
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
                                      'Pertemuan ke - ${jadwalMahasiswaResponseModel.data[index].pertemuan}',
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
                                                jadwalMahasiswaResponseModel
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
                                                jadwalMahasiswaResponseModel
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
                                                'Sesi ${jadwalMahasiswaResponseModel.data[index].sesi1}',
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
                                    ExpansionTile(
                                      title: Text(
                                        'Lihat lebih detail',
                                        style: TextStyle(
                                            fontFamily: 'WorkSansMedium',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      children: [
                                        Scrollbar(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Dosen Pengampu : ${jadwalMahasiswaResponseModel.data[index].namadosen1}',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'WorkSansMedium',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Ruang : ${jadwalMahasiswaResponseModel.data[index].ruang}',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'SKS : ${jadwalMahasiswaResponseModel.data[index].sks}',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Jam Kelas : ${jadwalMahasiswaResponseModel.data[index].jammasuk} - ${jadwalMahasiswaResponseModel.data[index].jamkeluar}',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
