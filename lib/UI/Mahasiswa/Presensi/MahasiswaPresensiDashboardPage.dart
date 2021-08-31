import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Beacon/RuangBeaconModel.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:system_setting/system_setting.dart';

class MahasiswaPresensiDashboardPage extends StatefulWidget {
  @override
  _MahasiswaPresensiDashboardPageState createState() =>
      _MahasiswaPresensiDashboardPageState();
}

class _MahasiswaPresensiDashboardPageState
    extends State<MahasiswaPresensiDashboardPage> with WidgetsBindingObserver {
  RuangBeaconResponseModel ruangBeaconResponseModel;

  bool authorizationStatusOk = false;
  bool locationServiceEnabled = false;
  bool bluetoothEnabled = false;

  String _timeString;
  String _dateString;

  String namamhs = "";

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();

    ruangBeaconResponseModel = RuangBeaconResponseModel();

    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Timer.periodic(Duration(hours: 1), (Timer t) => _getDate());

    getDataMahasiswa();

    getDataRuangBeacon();
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
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  void getDataMahasiswa() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();
    setState(() {
      namamhs = loginMahasiswa.getString('namamhs');
    });
  }

  void getDataRuangBeacon() async {
    setState(() {
      print(ruangBeaconResponseModel.toJson());
      APIService apiService = new APIService();
      apiService.getKelasBeacon().then((value) async {
        ruangBeaconResponseModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          floatingActionButton: FloatingActionButton.extended(
            // onPressed: () => {_streamRanging?.resume(), getDataRuangBeacon()},
            onPressed: () => getDataRuangBeacon(),
            label: Text(
              'Segarkan',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'WorkSansMedium'),
            ),
            icon: Icon(Icons.search_rounded),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Color.fromRGBO(23, 75, 137, 1),
            leading: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () =>
                  Get.toNamed('/mahasiswa/dashboard/presensi/notifikasi'),
            ),
            title: Image.asset(
              'SplashPage_LogoAtmaJaya'.png,
              height: 30,
            ),
            centerTitle: true,
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Column(
                  children: [
                    Center(
                      // alignment: Alignment.centerRight,
                      child: Text(
                        _dateString,
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'WorkSansMedium',
                            color: Colors.white),
                      ),
                    ),
                    Center(
                      // alignment: Alignment.centerLeft,
                      child: Text(
                        _timeString,
                        style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'WorkSansMedium',
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          new Text(
                            'Halo, ',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'WorkSansMedium',
                                color: Colors.white),
                          ),
                          new Text(
                            '${namamhs ?? "-"}',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'WorkSansMedium',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 20,
                thickness: 5,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 25, top: 10, bottom: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Center(
                    child: Text(
                      'Kuliah Hari Ini',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'WorkSansMedium',
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              ruangBeaconResponseModel.data == null
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            'Silakan tekan tombol segarkan',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'WorkSansMedium',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: ruangBeaconResponseModel.data?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 8, bottom: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(25)),
                                child: new ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        new Text(
                                          ruangBeaconResponseModel
                                              .data[index].ruang,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        new Text(
                                          'Mata Kuliah : ${ruangBeaconResponseModel.data[index].namamk}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'WorkSansMedium',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    SharedPreferences dataPresensiMahasiswa =
                                        await SharedPreferences.getInstance();
                                    await dataPresensiMahasiswa.setString(
                                        'ruang',
                                        ruangBeaconResponseModel
                                            .data[index].ruang);
                                    await dataPresensiMahasiswa.setString(
                                        'namamk',
                                        ruangBeaconResponseModel
                                            .data[index].namamk);
                                    await dataPresensiMahasiswa.setString(
                                        'namadosen',
                                        ruangBeaconResponseModel
                                            .data[index].namadosen);
                                    await dataPresensiMahasiswa.setString(
                                        'hari',
                                        ruangBeaconResponseModel
                                            .data[index].hari);
                                    await dataPresensiMahasiswa.setString(
                                        'sesi',
                                        ruangBeaconResponseModel
                                            .data[index].sesi);
                                    await dataPresensiMahasiswa.setString(
                                        'uuid',
                                        ruangBeaconResponseModel
                                            .data[index].uuid);
                                    await dataPresensiMahasiswa.setString(
                                        'jam', _timeString);
                                    await dataPresensiMahasiswa.setString(
                                        'tanggal', _dateString);
                                    await Get.toNamed('/pindaiMahasiswa');
                                  },
                                ),
                              ),
                            );
                          }),
                    )
            ],
          )),
    );
  }
}
