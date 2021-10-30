import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Beacon/RuangBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/ListKelasMahasiswa.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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

  String kelas = "";
  String jam = "";
  String tanggal = "";

  String npm = "";
  String namamhs = "";

  int statusPresensi = 0;

  ListKelasMahasiswaRequestModel listKelasMahasiswaRequestModel;

  ListKelasMahasiswaResponseModel listKelasMahasiswaResponseModel;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();

    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Timer.periodic(Duration(hours: 1), (Timer t) => _getDate());

    listKelasMahasiswaRequestModel = ListKelasMahasiswaRequestModel();
    listKelasMahasiswaResponseModel = ListKelasMahasiswaResponseModel();

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getDataMahasiswa();
      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });

    Timer.periodic(Duration(milliseconds: 1500), (Timer t) {
      getDataListKelasMahasiswa();
      // Future.delayed(Duration(seconds: 10), () {
      //   t.cancel();
      // });
    });

    Timer.periodic(Duration(milliseconds: 1000), (Timer t) {
      getDetailKelas();
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

  void getDataMahasiswa() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();
    setState(() {
      npm = loginMahasiswa.getString('npm');
      namamhs = loginMahasiswa.getString('namamhs');
    });
  }

  void getDataListKelasMahasiswa() async {
    setState(() {
      listKelasMahasiswaRequestModel.npm = npm;

      // listKelasMahasiswaRequestModel.tglnow = _dateString + ' ' + _timeString;

      print(listKelasMahasiswaRequestModel.toJson());

      APIService apiService = new APIService();
      apiService
          .postListKelasMahasiswa(listKelasMahasiswaRequestModel)
          .then((value) async {
        listKelasMahasiswaResponseModel = value;
      });
    });
  }

  getDetailKelas() async {
    SharedPreferences dataPresensiMahasiswa =
        await SharedPreferences.getInstance();

    setState(() {
      statusPresensi = dataPresensiMahasiswa.getInt('statuspresensi');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: () => getDataListKelasMahasiswa(),
          //   label: Text(
          //     'Segarkan',
          //     style: TextStyle(
          //         fontWeight: FontWeight.bold, fontFamily: 'WorkSansMedium'),
          //   ),
          //   icon: Icon(Icons.refresh_rounded),
          // ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Color.fromRGBO(23, 75, 137, 1),
            // leading: IconButton(
            //     icon: Icon(
            //       Icons.list_rounded,
            //       color: Colors.white,
            //     ),
            //     // onPressed: () =>
            //     //     Get.toNamed('')
            //     onPressed: () =>
            //         Get.toNamed('/mahasiswa/dashboard/presensi/detail/list')),
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
                        // child: Text(
                        //   _dateString,
                        //   style: TextStyle(
                        //       fontSize: 22,
                        //       fontFamily: 'WorkSansMedium',
                        //       color: Colors.white),
                        // ),
                        ),
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
                            child: Text(
                              '${namamhs ?? "-"}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'WorkSansMedium',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )),
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
              listKelasMahasiswaResponseModel.data == null ||
                      listKelasMahasiswaResponseModel.data.isEmpty
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
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
                            itemCount:
                                listKelasMahasiswaResponseModel.data.length,
                            itemBuilder: (context, index) {
                              if (listKelasMahasiswaResponseModel
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            listKelasMahasiswaResponseModel
                                                        .data[index]
                                                        .bukapresensi ==
                                                    0
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                          child: Text(
                                                              'Kelas Tertutup',
                                                              style: TextStyle(
                                                                  fontSize: 18,
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
                                                          child: Text(
                                                              'Kelas Terbuka',
                                                              style: TextStyle(
                                                                  fontSize: 18,
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
                                                  ),
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: new Text(
                                                    '${listKelasMahasiswaResponseModel.data[index].namamk} ${listKelasMahasiswaResponseModel.data[index].kelas}',
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
                                                    'Pertemuan ke - ${listKelasMahasiswaResponseModel.data[index].pertemuan}',
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
                                                        Icons.person,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: new AutoSizeText(
                                                          listKelasMahasiswaResponseModel
                                                              .data[index]
                                                              .namadosen1,
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
                                                          'Ruang ${listKelasMahasiswaResponseModel.data[index].ruang}',
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
                                                      '${listKelasMahasiswaResponseModel.data[index].hari1}'
                                                      ','
                                                      ' '
                                                      '${listKelasMahasiswaResponseModel.data[index].tglmasuk}',
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
                                              child: Row(
                                                children: [
                                                  Icon(Icons.alarm_on_rounded),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: new Text(
                                                      '${listKelasMahasiswaResponseModel.data[index].jammasuk}'
                                                      ' '
                                                      '-'
                                                      ' '
                                                      '${listKelasMahasiswaResponseModel.data[index].jamkeluar}',
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
                                            listKelasMahasiswaResponseModel
                                                        .data[index]
                                                        .bukapresensi ==
                                                    0
                                                ? SizedBox(height: 0)
                                                : statusPresensi == 0
                                                    ? MaterialButton(
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
                                                                        18,
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
                                                              dataPresensiMahasiswa =
                                                              await SharedPreferences
                                                                  .getInstance();

                                                          await dataPresensiMahasiswa
                                                              .setString('jam',
                                                                  _timeString);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'tanggal',
                                                                  _dateString);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'ruang',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .ruang);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'uuid',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .uuid);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'namadevice',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .namadevice);

                                                          await dataPresensiMahasiswa
                                                              .setDouble(
                                                                  'jarakmin',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .jarakmin);

                                                          if (listKelasMahasiswaResponseModel
                                                                  .data[index]
                                                                  .uuid !=
                                                              null) {
                                                            await dataPresensiMahasiswa
                                                                .setString(
                                                                    'uuid',
                                                                    listKelasMahasiswaResponseModel
                                                                        .data[
                                                                            index]
                                                                        .uuid);
                                                          } else {
                                                            await dataPresensiMahasiswa
                                                                .setString(
                                                                    'uuid',
                                                                    '-');
                                                          }

                                                          if (listKelasMahasiswaResponseModel
                                                                  .data[index]
                                                                  .namadevice !=
                                                              null) {
                                                            await dataPresensiMahasiswa.setString(
                                                                'namadevice',
                                                                listKelasMahasiswaResponseModel
                                                                    .data[index]
                                                                    .namadevice);
                                                          } else {
                                                            await dataPresensiMahasiswa
                                                                .setString(
                                                                    'namadevice',
                                                                    '-');
                                                          }
                                                          if (listKelasMahasiswaResponseModel
                                                                  .data[index]
                                                                  .jarakmin !=
                                                              null) {
                                                            await dataPresensiMahasiswa
                                                                .setDouble(
                                                                    'jarakmin',
                                                                    listKelasMahasiswaResponseModel
                                                                        .data[
                                                                            index]
                                                                        .jarakmin);
                                                          } else {
                                                            await dataPresensiMahasiswa
                                                                .setDouble(
                                                                    'jarakmin',
                                                                    0);
                                                          }

                                                          if (listKelasMahasiswaResponseModel
                                                                  .data[index]
                                                                  .major !=
                                                              null) {
                                                            await dataPresensiMahasiswa
                                                                .setInt(
                                                                    'major',
                                                                    listKelasMahasiswaResponseModel
                                                                        .data[
                                                                            index]
                                                                        .major);
                                                          } else {
                                                            await dataPresensiMahasiswa
                                                                .setInt(
                                                                    'major', 0);
                                                          }

                                                          await dataPresensiMahasiswa
                                                              .setInt(
                                                                  'idkelas',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .idkelas);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'namamk',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .namamk);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'kelas',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .kelas);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'nppdosen1',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .nppdosen1);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'nppdosen2',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].nppdosen2);
                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'nppdosen3',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].nppdosen3);
                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'nppdosen4',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].nppdosen4);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'namadosen1',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .namadosen1);
                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'namadosen2',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].namadosen2);
                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'namadosen3',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].namadosen3);
                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'namadosen4',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].namadosen4);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'hari1',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .hari1);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'hari2',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].hari2);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'hari3',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].hari3);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'hari4',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].hari4);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'sesi1',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .sesi1);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'sesi2',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].sesi2);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'sesi3',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].sesi3);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'sesi4',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].sesi4);

                                                          await dataPresensiMahasiswa
                                                              .setInt(
                                                                  'sks',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .sks);

                                                          await dataPresensiMahasiswa
                                                              .setInt(
                                                                  'pertemuan',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .pertemuan);

                                                          await dataPresensiMahasiswa
                                                              .setInt(
                                                                  'kapasitas',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .kapasitas);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'tglmasuk',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .tglmasuk);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'tglkeluar',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .tglkeluar);

                                                          await dataPresensiMahasiswa.setInt(
                                                              'bukapresensi',
                                                              listKelasMahasiswaResponseModel
                                                                  .data[index]
                                                                  .bukapresensi);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'jammasuk',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .jammasuk);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'jamkeluar',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .jamkeluar);

                                                          await Get.offAllNamed(
                                                              '/pindaiMahasiswa');
                                                        },
                                                      )
                                                    : MaterialButton(
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
                                                                'Detail Presensi Keluar',
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'WorkSansSemiBold',
                                                                    fontSize:
                                                                        18,
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
                                                              dataPresensiMahasiswa =
                                                              await SharedPreferences
                                                                  .getInstance();

                                                          await dataPresensiMahasiswa
                                                              .setString('jam',
                                                                  _timeString);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'tanggal',
                                                                  _dateString);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'ruang',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .ruang);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'uuid',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .uuid);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'namadevice',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .namadevice);

                                                          await dataPresensiMahasiswa
                                                              .setDouble(
                                                                  'jarakmin',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .jarakmin);

                                                          if (listKelasMahasiswaResponseModel
                                                                  .data[index]
                                                                  .uuid !=
                                                              null) {
                                                            await dataPresensiMahasiswa
                                                                .setString(
                                                                    'uuid',
                                                                    listKelasMahasiswaResponseModel
                                                                        .data[
                                                                            index]
                                                                        .uuid);
                                                          } else {
                                                            await dataPresensiMahasiswa
                                                                .setString(
                                                                    'uuid',
                                                                    '-');
                                                          }

                                                          if (listKelasMahasiswaResponseModel
                                                                  .data[index]
                                                                  .namadevice !=
                                                              null) {
                                                            await dataPresensiMahasiswa.setString(
                                                                'namadevice',
                                                                listKelasMahasiswaResponseModel
                                                                    .data[index]
                                                                    .namadevice);
                                                          } else {
                                                            await dataPresensiMahasiswa
                                                                .setString(
                                                                    'namadevice',
                                                                    '-');
                                                          }
                                                          if (listKelasMahasiswaResponseModel
                                                                  .data[index]
                                                                  .jarakmin !=
                                                              null) {
                                                            await dataPresensiMahasiswa
                                                                .setDouble(
                                                                    'jarakmin',
                                                                    listKelasMahasiswaResponseModel
                                                                        .data[
                                                                            index]
                                                                        .jarakmin);
                                                          } else {
                                                            await dataPresensiMahasiswa
                                                                .setDouble(
                                                                    'jarakmin',
                                                                    0);
                                                          }

                                                          if (listKelasMahasiswaResponseModel
                                                                  .data[index]
                                                                  .major !=
                                                              null) {
                                                            await dataPresensiMahasiswa
                                                                .setInt(
                                                                    'major',
                                                                    listKelasMahasiswaResponseModel
                                                                        .data[
                                                                            index]
                                                                        .major);
                                                          } else {
                                                            await dataPresensiMahasiswa
                                                                .setInt(
                                                                    'major', 0);
                                                          }

                                                          await dataPresensiMahasiswa
                                                              .setInt(
                                                                  'idkelas',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .idkelas);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'namamk',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .namamk);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'kelas',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .kelas);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'nppdosen1',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .nppdosen1);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'nppdosen2',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].nppdosen2);
                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'nppdosen3',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].nppdosen3);
                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'nppdosen4',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].nppdosen4);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'namadosen1',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .namadosen1);
                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'namadosen2',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].namadosen2);
                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'namadosen3',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].namadosen3);
                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'namadosen4',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].namadosen4);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'hari1',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .hari1);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'hari2',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].hari2);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'hari3',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].hari3);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'hari4',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].hari4);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'sesi1',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .sesi1);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'sesi2',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].sesi2);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'sesi3',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].sesi3);

                                                          // await dataPresensiMahasiswa.setString(
                                                          //     'sesi4',
                                                          //     listKelasMahasiswaResponseModel
                                                          //         .data[index].sesi4);

                                                          await dataPresensiMahasiswa
                                                              .setInt(
                                                                  'sks',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .sks);

                                                          await dataPresensiMahasiswa
                                                              .setInt(
                                                                  'pertemuan',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .pertemuan);

                                                          await dataPresensiMahasiswa
                                                              .setInt(
                                                                  'kapasitas',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .kapasitas);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'tglmasuk',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .tglmasuk);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'tglkeluar',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .tglkeluar);

                                                          await dataPresensiMahasiswa.setInt(
                                                              'bukapresensi',
                                                              listKelasMahasiswaResponseModel
                                                                  .data[index]
                                                                  .bukapresensi);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'jammasuk',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .jammasuk);

                                                          await dataPresensiMahasiswa
                                                              .setString(
                                                                  'jamkeluar',
                                                                  listKelasMahasiswaResponseModel
                                                                      .data[
                                                                          index]
                                                                      .jamkeluar);

                                                          await Get.offAllNamed(
                                                              '/pindaiMahasiswa');
                                                        },
                                                      ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else if (listKelasMahasiswaResponseModel
                                      .data[index].bukapresensi ==
                                  3) {
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                    child: Text(
                                                        'Kelas Berakhir',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'WorkSansMedium',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
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
                                                    '${listKelasMahasiswaResponseModel.data[index].namamk} ${listKelasMahasiswaResponseModel.data[index].kelas}',
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
                                                    'Pertemuan ke - ${listKelasMahasiswaResponseModel.data[index].pertemuan}',
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
                                                        Icons.person,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: new AutoSizeText(
                                                          listKelasMahasiswaResponseModel
                                                              .data[index]
                                                              .namadosen1,
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
                                                          'Ruang ${listKelasMahasiswaResponseModel.data[index].ruang}',
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
                                                      '${listKelasMahasiswaResponseModel.data[index].hari1}'
                                                      ','
                                                      ' '
                                                      '${listKelasMahasiswaResponseModel.data[index].tglmasuk}',
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
                                              child: Row(
                                                children: [
                                                  Icon(Icons.alarm_on_rounded),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: new Text(
                                                      '${listKelasMahasiswaResponseModel.data[index].jammasuk}'
                                                      ' '
                                                      '-'
                                                      ' '
                                                      '${listKelasMahasiswaResponseModel.data[index].jamkeluar}',
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
                                            //         color: Colors.green,
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 25)),
                                            //     child: Padding(
                                            //       padding:
                                            //           const EdgeInsets.all(8),
                                            //       child: new Text(
                                            //         '',
                                            //         style: TextStyle(
                                            //           fontSize: 14,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            listKelasMahasiswaResponseModel
                                                        .data[index]
                                                        .bukapresensi ==
                                                    0
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                          child: Text(
                                                              'Kelas Tertutup',
                                                              style: TextStyle(
                                                                  fontSize: 18,
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
                                                          child: Text(
                                                              'Kelas Terbuka',
                                                              style: TextStyle(
                                                                  fontSize: 18,
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
                                                  ),
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: new Text(
                                                    '${listKelasMahasiswaResponseModel.data[index].namamk} ${listKelasMahasiswaResponseModel.data[index].kelas}',
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
                                                    'Pertemuan ke - ${listKelasMahasiswaResponseModel.data[index].pertemuan}',
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
                                                        Icons.person,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: new AutoSizeText(
                                                          listKelasMahasiswaResponseModel
                                                              .data[index]
                                                              .namadosen1,
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
                                                          'Ruang ${listKelasMahasiswaResponseModel.data[index].ruang}',
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
                                                      '${listKelasMahasiswaResponseModel.data[index].hari1}'
                                                      ','
                                                      ' '
                                                      '${listKelasMahasiswaResponseModel.data[index].tglmasuk}',
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
                                              child: Row(
                                                children: [
                                                  Icon(Icons.alarm_on_rounded),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: new Text(
                                                      '${listKelasMahasiswaResponseModel.data[index].jammasuk}'
                                                      ' '
                                                      '-'
                                                      ' '
                                                      '${listKelasMahasiswaResponseModel.data[index].jamkeluar}',
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.yellow[700],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: new Text(
                                                    'Mohon tunggu dosen membuka kelas',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                          'WorkSansMedium',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              // return Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Column(
                              //     children: [
                              //       Container(
                              //         decoration: BoxDecoration(
                              //             color: Colors.green,
                              //             borderRadius:
                              //                 BorderRadius.circular(25)),
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Text(
                              //             'Mohon tunggu dosen anda membuka kelas anda',
                              //             style: TextStyle(
                              //                 fontSize: 18,
                              //                 fontFamily: 'WorkSansMedium',
                              //                 fontWeight: FontWeight.bold,
                              //                 color: Colors.white),
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // );
                            }),
                      ),
                    )
            ],
          )),
    );
  }
}
