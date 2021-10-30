import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_beacon/flutter_beacon.dart';

import 'package:get/get.dart';

import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Presensi/ListKelasDosenModel.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';
import 'package:widget_marquee/widget_marquee.dart';

class DosenPresensiDashboardPage extends StatefulWidget {
  @override
  _DosenPresensiDashboardPageState createState() =>
      _DosenPresensiDashboardPageState();
}

class Semester {
  String semester;
  Semester(this.semester);
}

class _DosenPresensiDashboardPageState extends State<DosenPresensiDashboardPage>
    with WidgetsBindingObserver {
  final StreamController<BluetoothState> streamController = StreamController();

  // RuangBeaconResponseModel ruangBeaconResponseModel;

  List<Data> matakuliahListSearch = List<Data>();

  bool authorizationStatusOk = false;
  bool locationServiceEnabled = false;
  bool bluetoothEnabled = false;

  String _timeString;
  String _dateString;

  // String _timeStringFilter;
  // String _dateStringFilter;

  String kelas = "";
  String jam = "";
  String jammasuk = "";
  String jamkeluar = "";
  String tanggal = "";

  String npp = "";
  String namadsn = "";

  String semesterShared = "";

  Semester selectedSemester;

  DateTime timeNow = DateTime.now();

  List<Semester> semesters = [
    Semester("1"),
    Semester("2"),
    Semester("3"),
    Semester("4"),
    Semester("5"),
    Semester("6"),
    Semester("7"),
    Semester("8"),
  ];

  List<DropdownMenuItem> generateSemester(List<Semester> semesters) {
    List<DropdownMenuItem> items = [];

    for (var item in semesters) {
      items.add(DropdownMenuItem(
        child: Text((item.semester)),
        value: item,
      ));
    }
    return items;
  }

  ListKelasDosenRequestModel listKelasDosenRequestModel;

  ListKelasDosenResponseModel listKelasDosenResponseModel;

  @override
  void initState() {
    print(timeNow);

    WidgetsBinding.instance.addObserver(this);

    super.initState();

    // ruangBeaconResponseModel = RuangBeaconResponseModel();

    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());

    // _timeStringFilter = _formatTime(DateTime.now());
    // _dateStringFilter = _formatDate(DateTime.now());

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Timer.periodic(Duration(hours: 1), (Timer t) => _getDate());

    // getDataRuangBeacon();

    listKelasDosenRequestModel = ListKelasDosenRequestModel();
    listKelasDosenResponseModel = ListKelasDosenResponseModel();

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      this.getDataDosen();
      // this.getDataListKelasDosen();
      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });

    Timer.periodic(Duration(milliseconds: 1500), (Timer t) {
      // this.getDataDosen();
      this.getDataListKelasDosen();
      // Future.delayed(Duration(seconds: 5), () {
      //   t.cancel();
      // });
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

  // void getModalKelas() async {
  //   SharedPreferences modalKelas = await SharedPreferences.getInstance();

  //   kelas = modalKelas.getString('Kelas');
  //   jam = modalKelas.getString('Jam');
  //   print(kelas);
  // }

  void getDataDosen() async {
    SharedPreferences loginDosen = await SharedPreferences.getInstance();
    setState(() {
      npp = loginDosen.getString('npp');
      namadsn = loginDosen.getString('namadsn');
    });
  }

  // void getDataRuangBeacon() async {
  //   setState(() {
  //     print(ruangBeaconResponseModel.toJson());
  //     APIService apiService = new APIService();
  //     apiService.getKelasBeacon().then((value) async {
  //       ruangBeaconResponseModel = value;
  //     });
  //   });
  // }

  void getDataListKelasDosen() async {
    setState(() {
      listKelasDosenRequestModel.npp = npp;
      // listKelasDosenRequestModel.tglnow = _dateString + ' ' + _timeString;
      // listKelasDosenRequestModel. = semesterShared;

      print(listKelasDosenRequestModel.toJson());

      APIService apiService = new APIService();
      apiService
          .postListKelasDosen(listKelasDosenRequestModel)
          .then((value) async {
        listKelasDosenResponseModel = value;

        matakuliahListSearch = value.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: () => getDataListKelasDosen(),
          //   label: Text(
          //     'Segarkan',
          //     style: TextStyle(
          //         fontWeight: FontWeight.bold, fontFamily: 'WorkSansMedium'),
          //   ),
          //   icon: Icon(Icons.refresh_rounded),
          // ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Color.fromRGBO(23, 75, 137, 1),
            // leading: IconButton(
            //     icon: Icon(
            //       Icons.notifications,
            //       color: Colors.white,
            //     ),
            //     onPressed: () =>
            //         Get.toNamed('/dosen/dashboard/presensi/notifikasi')),
            // leading: IconButton(
            //     icon: Icon(
            //       Icons.list_rounded,
            //       color: Colors.white,
            //     ),
            //     // onPressed: () =>
            //     //     Get.toNamed('')
            //     onPressed: () =>
            //         Get.toNamed('/dosen/dashboard/presensi/detail/list')),
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
                    // Center(
                    //   // alignment: Alignment.centerRight,
                    //   child: Text(
                    //     _dateString,
                    //     style: TextStyle(
                    //         fontSize: 22,
                    //         fontFamily: 'WorkSansMedium',
                    //         color: Colors.white),
                    //   ),
                    // ),
                    Center(
                      // alignment: Alignment.centerLeft,
                      child: Text(
                        _timeString,
                        style: TextStyle(
                            fontSize: 30,
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
                      child: Center(
                        child: Container(
                          child: Scrollbar(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  '${namadsn ?? "-"}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'WorkSansMedium',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
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
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //         color: Colors.grey[200],
              //         borderRadius: BorderRadius.circular(25)),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: TextFormField(
              //         decoration: InputDecoration(
              //           hintText: 'Cari Mata Kuliah',
              //           border: InputBorder.none,
              //           focusedBorder: InputBorder.none,
              //           enabledBorder: InputBorder.none,
              //           errorBorder: InputBorder.none,
              //           disabledBorder: InputBorder.none,
              //         ),
              //         style: const TextStyle(
              //             fontFamily: 'WorkSansSemiBold',
              //             fontSize: 16.0,
              //             color: Colors.black),
              //         onChanged: (text) {
              //           text = text.toLowerCase();
              //           setState(() {
              //             matakuliahListSearch = listKelasDosenResponseModel
              //                 .data
              //                 .where((matakuliah) {
              //               var namaMataKuliah =
              //                   matakuliah.namamk.toLowerCase();
              //               return namaMataKuliah.contains(text);
              //             }).toList();
              //           });
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              listKelasDosenResponseModel.data == null ||
                      listKelasDosenResponseModel.data.isEmpty
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Padding(
                              //   padding: const EdgeInsets.all(16),
                              //   child: CircularProgressIndicator(
                              //     color: Colors.white,
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Tidak ada kuliah',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'WorkSansMedium',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              // Text(
                              //   'Silakan tekan tombol "Segarkan" jika bermasalah',
                              //   style: TextStyle(
                              //       fontSize: 14,
                              //       fontFamily: 'WorkSansMedium',
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.white),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                            itemCount: listKelasDosenResponseModel.data.length,
                            itemBuilder: (context, index) {
                              if (listKelasDosenResponseModel
                                          .data[index].bukapresensi ==
                                      0 ||
                                  listKelasDosenResponseModel
                                          .data[index].bukapresensi ==
                                      1) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: new ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            listKelasDosenResponseModel
                                                        .data[index]
                                                        .bukapresensi ==
                                                    0
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25)),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .door_front_door_rounded,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(
                                                                  'Kelas Tertutup',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontFamily:
                                                                          'WorkSansMedium',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25)),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .meeting_room_rounded,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(
                                                                  'Kelas Terbuka',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontFamily:
                                                                          'WorkSansMedium',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Center(
                                                    child: Container(
                                                      child: Marquee(
                                                        child: Text(
                                                          '${listKelasDosenResponseModel.data[index].namamk} ${listKelasDosenResponseModel.data[index].kelas}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'WorkSansMedium',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: new Text(
                                                    'Pertemuan ke - ${listKelasDosenResponseModel.data[index].pertemuan}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                          'WorkSansMedium',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.room_rounded,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: new AutoSizeText(
                                                          'Ruang ${listKelasDosenResponseModel.data[index].ruang}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'WorkSansMedium',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                      Icons.date_range_rounded),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: new Text(
                                                      '${listKelasDosenResponseModel.data[index].hari1}'
                                                      ','
                                                      ' '
                                                      '${listKelasDosenResponseModel.data[index].tglmasuk}',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'WorkSansMedium',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.only(top: 8),
                                            //   child: new Text(
                                            //     'SKS : ${listKelasDosenResponseModel.data[index].sks}',
                                            //     style: TextStyle(
                                            //       fontSize: 15,
                                            //       fontFamily: 'WorkSansMedium',
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            // ),
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.only(top: 8),
                                            //   child: new Text(
                                            //     'Hari : ${listKelasDosenResponseModel.data[index].hari1}',
                                            //     style: TextStyle(
                                            //       fontSize: 15,
                                            //       fontFamily: 'WorkSansMedium',
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            // ),
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.only(top: 8),
                                            //   child: new Text(
                                            //     'Sesi : ${listKelasDosenResponseModel.data[index].sesi1}',
                                            //     style: TextStyle(
                                            //       fontSize: 15,
                                            //       fontFamily: 'WorkSansMedium',
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            // ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.alarm_on_rounded),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: new Text(
                                                      '${listKelasDosenResponseModel.data[index].jammasuk}'
                                                      ' '
                                                      '-'
                                                      ' '
                                                      '${listKelasDosenResponseModel.data[index].jamkeluar}',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'WorkSansMedium',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Divider(
                                                height: 1,
                                                color: Colors.black,
                                              ),
                                            ),
                                            listKelasDosenResponseModel
                                                        .data[index]
                                                        .bukapresensi ==
                                                    0
                                                ? Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .yellow[700],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: new Text(
                                                              'Mahasiswa belum bisa presensi, perlu membuka kelas',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'WorkSansMedium',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      MaterialButton(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      26),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .meeting_room_rounded,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(
                                                                'Detail Presensi Masuk',
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'WorkSansSemiBold',
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        color: Colors.green,
                                                        shape: StadiumBorder(),
                                                        onPressed: () async {
                                                          SharedPreferences
                                                              dataPresensiDosen =
                                                              await SharedPreferences
                                                                  .getInstance();

                                                          await dataPresensiDosen
                                                              .setString('jam',
                                                                  _timeString);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'tanggalnow',
                                                                  _dateString);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'ruang',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .ruang);

                                                          // if (listKelasDosenResponseModel
                                                          //             .data[index].uuid !=
                                                          //         null ||
                                                          //     listKelasDosenResponseModel
                                                          //
                                                          //        .data[index].uuid.isNotEmpty) {

                                                          if (listKelasDosenResponseModel
                                                                  .data[index]
                                                                  .uuid !=
                                                              null) {
                                                            await dataPresensiDosen
                                                                .setString(
                                                                    'uuid',
                                                                    listKelasDosenResponseModel
                                                                        .data[
                                                                            index]
                                                                        .uuid);
                                                          } else {
                                                            await dataPresensiDosen
                                                                .setString(
                                                                    'uuid',
                                                                    '-');
                                                          }

                                                          if (listKelasDosenResponseModel
                                                                  .data[index]
                                                                  .namadevice !=
                                                              null) {
                                                            await dataPresensiDosen.setString(
                                                                'namadevice',
                                                                listKelasDosenResponseModel
                                                                    .data[index]
                                                                    .namadevice);
                                                          } else {
                                                            await dataPresensiDosen
                                                                .setString(
                                                                    'namadevice',
                                                                    '-');
                                                          }
                                                          if (listKelasDosenResponseModel
                                                                  .data[index]
                                                                  .jarakmin !=
                                                              null) {
                                                            await dataPresensiDosen
                                                                .setDouble(
                                                                    'jarakmin',
                                                                    listKelasDosenResponseModel
                                                                        .data[
                                                                            index]
                                                                        .jarakmin);
                                                          } else {
                                                            await dataPresensiDosen
                                                                .setDouble(
                                                                    'jarakmin',
                                                                    0);
                                                          }

                                                          if (listKelasDosenResponseModel
                                                                  .data[index]
                                                                  .major !=
                                                              null) {
                                                            await dataPresensiDosen
                                                                .setInt(
                                                                    'major',
                                                                    listKelasDosenResponseModel
                                                                        .data[
                                                                            index]
                                                                        .major);
                                                          } else {
                                                            await dataPresensiDosen
                                                                .setInt(
                                                                    'major', 0);
                                                          }

                                                          if (listKelasDosenResponseModel
                                                                  .data[index]
                                                                  .minor !=
                                                              null) {
                                                            await dataPresensiDosen
                                                                .setInt(
                                                                    'minor',
                                                                    listKelasDosenResponseModel
                                                                        .data[
                                                                            index]
                                                                        .minor);
                                                          } else {
                                                            await dataPresensiDosen
                                                                .setInt(
                                                                    'minor', 0);
                                                          }

                                                          // }

                                                          await dataPresensiDosen
                                                              .setInt(
                                                                  'idkelas',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .idkelas);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'namamk',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .namamk);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'kelas',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .kelas);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'nppdosen1',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .nppdosen1);

                                                          // await dataPresensiDosen.setString(
                                                          //     'nppdosen2',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].nppdosen2);
                                                          // await dataPresensiDosen.setString(
                                                          //     'nppdosen3',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].nppdosen3);
                                                          // await dataPresensiDosen.setString(
                                                          //     'nppdosen4',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].nppdosen4);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'namadosen1',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .namadosen1);
                                                          // await dataPresensiDosen.setString(
                                                          //     'namadosen2',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].namadosen2);
                                                          // await dataPresensiDosen.setString(
                                                          //     'namadosen3',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].namadosen3);
                                                          // await dataPresensiDosen.setString(
                                                          //     'namadosen4',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].namadosen4);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'hari1',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .hari1);

                                                          // await dataPresensiDosen.setString(
                                                          //     'hari2',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].hari2);

                                                          // await dataPresensiDosen.setString(
                                                          //     'hari3',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].hari3);

                                                          // await dataPresensiDosen.setString(
                                                          //     'hari4',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].hari4);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'sesi1',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .sesi1);

                                                          // await dataPresensiDosen.setString(
                                                          //     'sesi2',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].sesi2);

                                                          // await dataPresensiDosen.setString(
                                                          //     'sesi3',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].sesi3);

                                                          // await dataPresensiDosen.setString(
                                                          //     'sesi4',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].sesi4);

                                                          await dataPresensiDosen
                                                              .setInt(
                                                                  'sks',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .sks);

                                                          await dataPresensiDosen
                                                              .setInt(
                                                                  'pertemuan',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .pertemuan);

                                                          await dataPresensiDosen
                                                              .setInt(
                                                                  'kapasitas',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .kapasitas);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'tglmasuk',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .tglmasuk);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'tglkeluar',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .tglkeluar);

                                                          await dataPresensiDosen.setInt(
                                                              'bukapresensi',
                                                              listKelasDosenResponseModel
                                                                  .data[index]
                                                                  .bukapresensi);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'jammasuk',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .jammasuk);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'jamkeluar',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .jamkeluar);

                                                          await Get.offAllNamed(
                                                              '/pindaiDosen');
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .yellow[700],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: new Text(
                                                              'Persilahkan mahasiswa untuk presensi masuk',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'WorkSansMedium',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      MaterialButton(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      26),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .door_front_door_rounded,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(
                                                                'Detail Presensi Keluar',
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'WorkSansSemiBold',
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        color: Colors.red,
                                                        shape: StadiumBorder(),
                                                        onPressed: () async {
                                                          SharedPreferences
                                                              dataPresensiDosen =
                                                              await SharedPreferences
                                                                  .getInstance();

                                                          await dataPresensiDosen
                                                              .setString('jam',
                                                                  _timeString);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'tanggalnow',
                                                                  _dateString);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'ruang',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .ruang);

                                                          // if (listKelasDosenResponseModel
                                                          //             .data[index].uuid !=
                                                          //         null ||
                                                          //     listKelasDosenResponseModel
                                                          //
                                                          //        .data[index].uuid.isNotEmpty) {

                                                          if (listKelasDosenResponseModel
                                                                  .data[index]
                                                                  .uuid !=
                                                              null) {
                                                            await dataPresensiDosen
                                                                .setString(
                                                                    'uuid',
                                                                    listKelasDosenResponseModel
                                                                        .data[
                                                                            index]
                                                                        .uuid);
                                                          } else {
                                                            await dataPresensiDosen
                                                                .setString(
                                                                    'uuid',
                                                                    '-');
                                                          }

                                                          if (listKelasDosenResponseModel
                                                                  .data[index]
                                                                  .namadevice !=
                                                              null) {
                                                            await dataPresensiDosen.setString(
                                                                'namadevice',
                                                                listKelasDosenResponseModel
                                                                    .data[index]
                                                                    .namadevice);
                                                          } else {
                                                            await dataPresensiDosen
                                                                .setString(
                                                                    'namadevice',
                                                                    '-');
                                                          }
                                                          if (listKelasDosenResponseModel
                                                                  .data[index]
                                                                  .jarakmin !=
                                                              null) {
                                                            await dataPresensiDosen
                                                                .setDouble(
                                                                    'jarakmin',
                                                                    listKelasDosenResponseModel
                                                                        .data[
                                                                            index]
                                                                        .jarakmin);
                                                          } else {
                                                            await dataPresensiDosen
                                                                .setDouble(
                                                                    'jarakmin',
                                                                    0);
                                                          }

                                                          if (listKelasDosenResponseModel
                                                                  .data[index]
                                                                  .major !=
                                                              null) {
                                                            await dataPresensiDosen
                                                                .setInt(
                                                                    'major',
                                                                    listKelasDosenResponseModel
                                                                        .data[
                                                                            index]
                                                                        .major);
                                                          } else {
                                                            await dataPresensiDosen
                                                                .setInt(
                                                                    'major', 0);
                                                          }

                                                          if (listKelasDosenResponseModel
                                                                  .data[index]
                                                                  .minor !=
                                                              null) {
                                                            await dataPresensiDosen
                                                                .setInt(
                                                                    'minor',
                                                                    listKelasDosenResponseModel
                                                                        .data[
                                                                            index]
                                                                        .minor);
                                                          } else {
                                                            await dataPresensiDosen
                                                                .setInt(
                                                                    'minor', 0);
                                                          }

                                                          // }

                                                          await dataPresensiDosen
                                                              .setInt(
                                                                  'idkelas',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .idkelas);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'namamk',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .namamk);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'kelas',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .kelas);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'nppdosen1',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .nppdosen1);

                                                          // await dataPresensiDosen.setString(
                                                          //     'nppdosen2',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].nppdosen2);
                                                          // await dataPresensiDosen.setString(
                                                          //     'nppdosen3',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].nppdosen3);
                                                          // await dataPresensiDosen.setString(
                                                          //     'nppdosen4',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].nppdosen4);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'namadosen1',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .namadosen1);
                                                          // await dataPresensiDosen.setString(
                                                          //     'namadosen2',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].namadosen2);
                                                          // await dataPresensiDosen.setString(
                                                          //     'namadosen3',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].namadosen3);
                                                          // await dataPresensiDosen.setString(
                                                          //     'namadosen4',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].namadosen4);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'hari1',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .hari1);

                                                          // await dataPresensiDosen.setString(
                                                          //     'hari2',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].hari2);

                                                          // await dataPresensiDosen.setString(
                                                          //     'hari3',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].hari3);

                                                          // await dataPresensiDosen.setString(
                                                          //     'hari4',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].hari4);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'sesi1',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .sesi1);

                                                          // await dataPresensiDosen.setString(
                                                          //     'sesi2',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].sesi2);

                                                          // await dataPresensiDosen.setString(
                                                          //     'sesi3',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].sesi3);

                                                          // await dataPresensiDosen.setString(
                                                          //     'sesi4',
                                                          //     listKelasDosenResponseModel
                                                          //         .data[index].sesi4);

                                                          await dataPresensiDosen
                                                              .setInt(
                                                                  'sks',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .sks);

                                                          await dataPresensiDosen
                                                              .setInt(
                                                                  'pertemuan',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .pertemuan);

                                                          await dataPresensiDosen
                                                              .setInt(
                                                                  'kapasitas',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .kapasitas);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'tglmasuk',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .tglmasuk);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'tglkeluar',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .tglkeluar);

                                                          await dataPresensiDosen.setInt(
                                                              'bukapresensi',
                                                              listKelasDosenResponseModel
                                                                  .data[index]
                                                                  .bukapresensi);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'jammasuk',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .jammasuk);

                                                          await dataPresensiDosen
                                                              .setString(
                                                                  'jamkeluar',
                                                                  listKelasDosenResponseModel
                                                                      .data[
                                                                          index]
                                                                      .jamkeluar);

                                                          await Get.offAllNamed(
                                                              '/pindaiDosen');
                                                        },
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        ),
                                      ),
                                      // onTap: () async {

                                      // },
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: new ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons
                                                              .door_front_door_rounded,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text('Kelas Berakhir',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    'WorkSansMedium',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: new Text(
                                                    '${listKelasDosenResponseModel.data[index].namamk} ${listKelasDosenResponseModel.data[index].kelas}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'WorkSansMedium',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: new Text(
                                                    'Pertemuan ke - ${listKelasDosenResponseModel.data[index].pertemuan}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                          'WorkSansMedium',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.room_rounded,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: new AutoSizeText(
                                                          'Ruang ${listKelasDosenResponseModel.data[index].ruang}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'WorkSansMedium',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                      Icons.date_range_rounded),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: new Text(
                                                      '${listKelasDosenResponseModel.data[index].hari1}'
                                                      ','
                                                      ' '
                                                      '${listKelasDosenResponseModel.data[index].tglmasuk}',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'WorkSansMedium',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.only(top: 8),
                                            //   child: new Text(
                                            //     'SKS : ${listKelasDosenResponseModel.data[index].sks}',
                                            //     style: TextStyle(
                                            //       fontSize: 15,
                                            //       fontFamily: 'WorkSansMedium',
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            // ),
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.only(top: 8),
                                            //   child: new Text(
                                            //     'Hari : ${listKelasDosenResponseModel.data[index].hari1}',
                                            //     style: TextStyle(
                                            //       fontSize: 15,
                                            //       fontFamily: 'WorkSansMedium',
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            // ),
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.only(top: 8),
                                            //   child: new Text(
                                            //     'Sesi : ${listKelasDosenResponseModel.data[index].sesi1}',
                                            //     style: TextStyle(
                                            //       fontSize: 15,
                                            //       fontFamily: 'WorkSansMedium',
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            // ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.alarm_on_rounded),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: new Text(
                                                      '${listKelasDosenResponseModel.data[index].jammasuk}'
                                                      ' '
                                                      '-'
                                                      ' '
                                                      '${listKelasDosenResponseModel.data[index].jamkeluar}',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'WorkSansMedium',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Divider(
                                                height: 1,
                                                color: Colors.black,
                                              ),
                                            ),
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.all(8.0),
                                            //   child: Container(
                                            //     decoration: BoxDecoration(
                                            //         color: Colors.red,
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 25)),
                                            //     child: Padding(
                                            //       padding:
                                            //           const EdgeInsets.all(8),
                                            //       child: new Text(
                                            //         'Kelas Berakhir',
                                            //         style: TextStyle(
                                            //           fontSize: 16,
                                            //           fontFamily:
                                            //               'WorkSansMedium',
                                            //           fontWeight:
                                            //               FontWeight.bold,
                                            //           color: Colors.white,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      // onTap: () async {

                                      // },
                                    ),
                                  ),
                                );
                              }
                            }),
                      ),
                    )
            ],
          )),
    );
  }
}
