import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_beacon/flutter_beacon.dart';

import 'package:get/get.dart';

import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Presensi/ListKelasDosenModel.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';
// import 'package:system_settings/system_settings.dart';

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
      this.getDataListKelasDosen();
      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
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

  // void getModalKelas() async {
  //   SharedPreferences modalKelas = await SharedPreferences.getInstance();

  //   kelas = modalKelas.getString('Kelas');
  //   jam = modalKelas.getString('Jam');
  //   print(kelas);
  // }

  getDataDosen() async {
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
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => getDataListKelasDosen(),
            label: Text(
              'Segarkan',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'WorkSansMedium'),
            ),
            icon: Icon(Icons.search_rounded),
          ),
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
            leading: IconButton(
                icon: Icon(
                  Icons.list_rounded,
                  color: Colors.white,
                ),
                // onPressed: () =>
                //     Get.toNamed('')
                onPressed: () => {}),
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
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Center(
                        child: Container(
                          child: Text(
                            '${namadsn ?? "-"}',
                            style: TextStyle(
                                fontSize: 14,
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
                                child: Text(
                                  'Tidak ada kuliah hari ini',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'WorkSansMedium',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              Text(
                                'Silakan tekan tombol "Segarkan" jika bermasalah',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
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
                                        children: <Widget>[
                                          Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.blue[900],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: new Text(
                                                    '${listKelasDosenResponseModel.data[index].hari1}'
                                                    ','
                                                    ' '
                                                    '${listKelasDosenResponseModel.data[index].tglmasuk}',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            'WorkSansMedium',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          new Text(
                                            'Ruang ${listKelasDosenResponseModel.data[index].ruang}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: new Text(
                                              '${listKelasDosenResponseModel.data[index].namamk} ${listKelasDosenResponseModel.data[index].kelas}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: new Text(
                                              'Pertemuan : ${listKelasDosenResponseModel.data[index].pertemuan}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                              ),
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

                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: new Text(
                                                  '${listKelasDosenResponseModel.data[index].jammasuk}'
                                                  ' '
                                                  '-'
                                                  ' '
                                                  '${listKelasDosenResponseModel.data[index].jamkeluar}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily:
                                                          'WorkSansMedium',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
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
                                                                .circular(25)),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text('Tutup',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'WorkSansMedium',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text('Buka',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'WorkSansMedium',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      SharedPreferences dataPresensiDosen =
                                          await SharedPreferences.getInstance();

                                      await dataPresensiDosen.setString(
                                          'jam', _timeString);

                                      await dataPresensiDosen.setString(
                                          'tanggalnow', _dateString);

                                      await dataPresensiDosen.setString(
                                          'ruang',
                                          listKelasDosenResponseModel
                                              .data[index].ruang);

                                      // if (listKelasDosenResponseModel
                                      //             .data[index].uuid !=
                                      //         null ||
                                      //     listKelasDosenResponseModel
                                      //
                                      //        .data[index].uuid.isNotEmpty) {

                                      if (listKelasDosenResponseModel
                                              .data[index].uuid !=
                                          null) {
                                        await dataPresensiDosen.setString(
                                            'uuid',
                                            listKelasDosenResponseModel
                                                .data[index].uuid);
                                      } else {
                                        await dataPresensiDosen.setString(
                                            'uuid', '-');
                                      }

                                      if (listKelasDosenResponseModel
                                              .data[index].namadevice !=
                                          null) {
                                        await dataPresensiDosen.setString(
                                            'namadevice',
                                            listKelasDosenResponseModel
                                                .data[index].namadevice);
                                      } else {
                                        await dataPresensiDosen.setString(
                                            'namadevice', '-');
                                      }
                                      if (listKelasDosenResponseModel
                                              .data[index].jarakmin !=
                                          null) {
                                        await dataPresensiDosen.setDouble(
                                            'jarakmin',
                                            listKelasDosenResponseModel
                                                .data[index].jarakmin);
                                      } else {
                                        await dataPresensiDosen.setDouble(
                                            'jarakmin', 0);
                                      }

                                      if (listKelasDosenResponseModel
                                              .data[index].major !=
                                          null) {
                                        await dataPresensiDosen.setInt(
                                            'major',
                                            listKelasDosenResponseModel
                                                .data[index].major);
                                      } else {
                                        await dataPresensiDosen.setInt(
                                            'major', 0);
                                      }

                                      if (listKelasDosenResponseModel
                                              .data[index].minor !=
                                          null) {
                                        await dataPresensiDosen.setInt(
                                            'minor',
                                            listKelasDosenResponseModel
                                                .data[index].minor);
                                      } else {
                                        await dataPresensiDosen.setInt(
                                            'minor', 0);
                                      }

                                      if (listKelasDosenResponseModel
                                              .data[index].jarakmin !=
                                          null) {
                                        await dataPresensiDosen.setDouble(
                                            'jarakmin',
                                            listKelasDosenResponseModel
                                                .data[index].jarakmin);
                                      } else {
                                        await dataPresensiDosen.setDouble(
                                            'jarakmin', 0);
                                      }

                                      // }

                                      await dataPresensiDosen.setInt(
                                          'idkelas',
                                          listKelasDosenResponseModel
                                              .data[index].idkelas);

                                      await dataPresensiDosen.setString(
                                          'namamk',
                                          listKelasDosenResponseModel
                                              .data[index].namamk);

                                      await dataPresensiDosen.setString(
                                          'kelas',
                                          listKelasDosenResponseModel
                                              .data[index].kelas);

                                      await dataPresensiDosen.setString(
                                          'nppdosen1',
                                          listKelasDosenResponseModel
                                              .data[index].nppdosen1);

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

                                      await dataPresensiDosen.setString(
                                          'namadosen1',
                                          listKelasDosenResponseModel
                                              .data[index].namadosen1);
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

                                      await dataPresensiDosen.setString(
                                          'hari1',
                                          listKelasDosenResponseModel
                                              .data[index].hari1);

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

                                      await dataPresensiDosen.setString(
                                          'sesi1',
                                          listKelasDosenResponseModel
                                              .data[index].sesi1);

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

                                      await dataPresensiDosen.setInt(
                                          'sks',
                                          listKelasDosenResponseModel
                                              .data[index].sks);

                                      await dataPresensiDosen.setInt(
                                          'pertemuan',
                                          listKelasDosenResponseModel
                                              .data[index].pertemuan);

                                      await dataPresensiDosen.setInt(
                                          'kapasitas',
                                          listKelasDosenResponseModel
                                              .data[index].kapasitas);

                                      await dataPresensiDosen.setString(
                                          'tglmasuk',
                                          listKelasDosenResponseModel
                                              .data[index].tglmasuk);

                                      await dataPresensiDosen.setString(
                                          'tglkeluar',
                                          listKelasDosenResponseModel
                                              .data[index].tglkeluar);

                                      await dataPresensiDosen.setInt(
                                          'bukapresensi',
                                          listKelasDosenResponseModel
                                              .data[index].bukapresensi);

                                      await Get.toNamed('/pindaiDosen');
                                    },
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
            ],
          )),
    );
  }
}
