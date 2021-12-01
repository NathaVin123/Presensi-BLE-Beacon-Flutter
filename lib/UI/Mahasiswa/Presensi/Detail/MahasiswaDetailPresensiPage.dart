import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Presensi/FBE/PresensiINMahasiswaToFBEModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/FH/PresensiINMahasiswaToFHModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/FISIP/PresensiINMahasiswaToFISIPModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/FTB/PresensiINMahasiswaToFTBModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/FTI/PresensiINMahasiswaToFTIModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/FT/PresensiINMahasiswaToFTModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/KSI/Mahasiswa/PresensiINMahasiswaToKSIModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/FBE/PresensiOUTMahasiswaToFBEModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/FH/PresensiOUTMahasiswaToFHModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/FISIP/PresensiOUTMahasiswaToFISIPModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/FTB/PresensiOUTMahasiswaToFTBModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/FTI/PresensiOUTMahasiswaToFTIModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/FT/PresensiOUTMahasiswaToFTModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/KSI/Mahasiswa/PresensiOUTMahasiswaToKSIModel.dart';
import 'package:presensiblebeacon/UTILS/LoginProgressHUD.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sk_alert_dialog/sk_alert_dialog.dart';

class MahasiswaDetailPresensiPage extends StatefulWidget {
  @override
  _MahasiswaDetailPresensiPageState createState() =>
      _MahasiswaDetailPresensiPageState();
}

class _MahasiswaDetailPresensiPageState
    extends State<MahasiswaDetailPresensiPage> {
  String npm = "";
  String fakultas = "";
  int idkelas = 0;
  String ruang = "";
  String namamk = "";
  String dosen = "";
  String kelas = "";
  int sks = 0;
  int pertemuan = 0;
  String hari = "";
  String sesi = "";
  int kapasitas = 0;
  String jam = "";
  String tanggalnow = "";
  String tglmasuk = "";
  String tglkeluar = "";
  int bukapresensi = 0;

  String idkelasString;
  String idkelasFakultas;

  int statusPresensi = 0;

  bool isApiCallProcess = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  PresensiINMahasiswaToKSIRequestModel presensiINMahasiswaToKSIRequestModel;

  PresensiOUTMahasiswaToKSIRequestModel presensiOUTMahasiswaToKSIRequestModel;

  PresensiINMahasiswaToFBERequestModel presensiINMahasiswaToFBERequestModel;

  PresensiOUTMahasiswaToFBERequestModel presensiOUTMahasiswaToFBERequestModel;

  PresensiINMahasiswaToFHRequestModel presensiINMahasiswaToFHRequestModel;

  PresensiOUTMahasiswaToFHRequestModel presensiOUTMahasiswaToFHRequestModel;

  PresensiINMahasiswaToFISIPRequestModel presensiINMahasiswaToFISIPRequestModel;

  PresensiOUTMahasiswaToFISIPRequestModel
      presensiOUTMahasiswaToFISIPRequestModel;

  PresensiINMahasiswaToFTRequestModel presensiINMahasiswaToFTRequestModel;

  PresensiOUTMahasiswaToFTRequestModel presensiOUTMahasiswaToFTRequestModel;

  PresensiINMahasiswaToFTBRequestModel presensiINMahasiswaToFTBRequestModel;

  PresensiOUTMahasiswaToFTBRequestModel presensiOUTMahasiswaToFTBRequestModel;

  PresensiINMahasiswaToFTIRequestModel presensiINMahasiswaToFTIRequestModel;

  PresensiOUTMahasiswaToFTIRequestModel presensiOUTMahasiswaToFTIRequestModel;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getDetailKelas();
      getDetailMahasiswa();

      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });

    presensiINMahasiswaToKSIRequestModel =
        PresensiINMahasiswaToKSIRequestModel();

    presensiOUTMahasiswaToKSIRequestModel =
        PresensiOUTMahasiswaToKSIRequestModel();

    presensiINMahasiswaToFBERequestModel =
        PresensiINMahasiswaToFBERequestModel();

    presensiOUTMahasiswaToFBERequestModel =
        PresensiOUTMahasiswaToFBERequestModel();

    presensiINMahasiswaToFHRequestModel = PresensiINMahasiswaToFHRequestModel();

    presensiOUTMahasiswaToFHRequestModel =
        PresensiOUTMahasiswaToFHRequestModel();

    presensiINMahasiswaToFISIPRequestModel =
        PresensiINMahasiswaToFISIPRequestModel();

    presensiOUTMahasiswaToFISIPRequestModel =
        PresensiOUTMahasiswaToFISIPRequestModel();

    presensiINMahasiswaToFTRequestModel = PresensiINMahasiswaToFTRequestModel();

    presensiOUTMahasiswaToFTRequestModel =
        PresensiOUTMahasiswaToFTRequestModel();

    presensiINMahasiswaToFTBRequestModel =
        PresensiINMahasiswaToFTBRequestModel();

    presensiOUTMahasiswaToFTBRequestModel =
        PresensiOUTMahasiswaToFTBRequestModel();

    presensiINMahasiswaToFTIRequestModel =
        PresensiINMahasiswaToFTIRequestModel();

    presensiOUTMahasiswaToFTIRequestModel =
        PresensiOUTMahasiswaToFTIRequestModel();

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getIDKelasFakultas();

      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });
  }

  getDetailMahasiswa() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();

    setState(() {
      npm = loginMahasiswa.getString('npm');
      fakultas = loginMahasiswa.getString('fakultas');
    });
  }

  getDetailKelas() async {
    SharedPreferences dataPresensiMahasiswa =
        await SharedPreferences.getInstance();

    setState(() {
      idkelas = dataPresensiMahasiswa.getInt('idkelas');
      ruang = dataPresensiMahasiswa.getString('ruang');
      namamk = dataPresensiMahasiswa.getString('namamk');
      dosen = dataPresensiMahasiswa.getString('namadosen1');
      kelas = dataPresensiMahasiswa.getString('kelas');
      sks = dataPresensiMahasiswa.getInt('sks');
      pertemuan = dataPresensiMahasiswa.getInt('pertemuan');
      hari = dataPresensiMahasiswa.getString('hari1');
      sesi = dataPresensiMahasiswa.getString('sesi1');
      kapasitas = dataPresensiMahasiswa.getInt('kapasitas');
      jam = dataPresensiMahasiswa.getString('jam');
      tanggalnow = dataPresensiMahasiswa.getString('tanggal');
      tglmasuk = dataPresensiMahasiswa.getString('tglmasuk');
      tglkeluar = dataPresensiMahasiswa.getString('tglkeluar');
      bukapresensi = dataPresensiMahasiswa.getInt('bukapresensi');
      statusPresensi = dataPresensiMahasiswa.getInt('statuspresensi');
    });
  }

  getIDKelasFakultas() async {
    idkelasString = idkelas.toString();

    idkelasFakultas = idkelasString.substring(2);
  }

  @override
  Widget build(BuildContext context) {
    return LoginProgressHUD(
      child: buildDetailPresensiMahasiswa(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0,
    );
  }

  Widget buildDetailPresensiMahasiswa(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color.fromRGBO(23, 75, 137, 1),
            pinned: true,
            floating: false,
            snap: false,
            expandedHeight: 85,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Presensi',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25)),
                  child: new Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Tanggal',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          statusPresensi == 0 || statusPresensi == null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Center(
                                    child: new Text(
                                      '${tglmasuk ?? "-"}',
                                      style: TextStyle(
                                          fontFamily: 'WorkSansMedium',
                                          // fontWeight:
                                          //     FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Center(
                                    child: new Text(
                                      '${tglkeluar ?? "-"}',
                                      style: TextStyle(
                                          fontFamily: 'WorkSansMedium',
                                          // fontWeight:
                                          //     FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'NPM',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${npm ?? "-"}',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: new Center(
                          //     child: new Text(
                          //       '${idkelasFakultas ?? "-"}',
                          //       style: TextStyle(
                          //           fontFamily: 'WorkSansMedium',
                          //           // fontWeight:
                          //           //     FontWeight.bold,
                          //           fontSize: 16),
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Ruangan',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${ruang ?? "-"}',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Mata Kuliah',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${namamk ?? "-"}',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Dosen',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${dosen ?? "-"}',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Kelas',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${kelas ?? "-"}',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'SKS',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${sks ?? "-"}',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Pertemuan Ke',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${pertemuan ?? "-"}',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Hari',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${hari ?? "-"}',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Sesi',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${sesi ?? "-"}',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Kapasitas',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${kapasitas ?? "-"}',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        children: <Widget>[
                          statusPresensi == 0 || statusPresensi == null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Center(
                                    child: new Text(
                                      'Tanggal Masuk',
                                      style: TextStyle(
                                          fontFamily: 'WorkSansMedium',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Center(
                                    child: new Text(
                                      'Tanggal Keluar',
                                      style: TextStyle(
                                          fontFamily: 'WorkSansMedium',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${tanggalnow ?? "-"}',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          statusPresensi == 0 || statusPresensi == null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Center(
                                    child: new Text(
                                      'Jam Masuk',
                                      style: TextStyle(
                                          fontFamily: 'WorkSansMedium',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Center(
                                    child: new Text(
                                      'Jam Keluar',
                                      style: TextStyle(
                                          fontFamily: 'WorkSansMedium',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${jam ?? "-"}',
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium',
                                    // fontWeight:
                                    //     FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                new Align(
                  child: new Padding(
                    padding: EdgeInsets.all(10),
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MaterialButton(
                            color: Colors.blue,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.only(
                                left: 50, right: 50, top: 25, bottom: 25),
                            onPressed: () => {
                              Get.toNamed(
                                  '/mahasiswa/dashboard/presensi/detail/tampilpeserta')
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  'Lihat Peserta Kelas',
                                  style: TextStyle(
                                      fontFamily: 'WorkSansMedium',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          statusPresensi == 0 || statusPresensi == null
                              ? MaterialButton(
                                  color: Colors.green,
                                  shape: StadiumBorder(),
                                  padding: EdgeInsets.only(
                                      left: 50, right: 50, top: 25, bottom: 25),
                                  onPressed: () {
                                    SKAlertDialog.show(
                                      context: context,
                                      type: SKAlertType.buttons,
                                      title: 'Masuk ?',
                                      message:
                                          'Apakah anda yakin ingin\nmasuk ke kelas ini ?',
                                      okBtnText: 'Ya',
                                      okBtnTxtColor: Colors.white,
                                      okBtnColor: Colors.green,
                                      cancelBtnText: 'Tidak',
                                      cancelBtnTxtColor: Colors.white,
                                      cancelBtnColor: Colors.grey,
                                      onOkBtnTap: (value) async {
                                        SharedPreferences
                                            dataPresensiMahasiswa =
                                            await SharedPreferences
                                                .getInstance();

                                        await dataPresensiMahasiswa.setInt(
                                            'statuspresensi', 1);

                                        setState(() {
                                          isApiCallProcess = true;

                                          presensiINMahasiswaToKSIRequestModel
                                              .idkelas = idkelas;

                                          presensiINMahasiswaToKSIRequestModel
                                              .npm = npm;

                                          presensiINMahasiswaToKSIRequestModel
                                              .pertemuan = pertemuan;

                                          presensiINMahasiswaToKSIRequestModel
                                              .tglin = jam + ' ' + tanggalnow;

                                          // if (fakultas ==
                                          //     'Bisnis dan Ekonomika') {
                                          //   presensiINMahasiswaToFBERequestModel
                                          //       .idkelas = idkelasFakultas;

                                          //   presensiINMahasiswaToFBERequestModel
                                          //       .npm = npm;

                                          //   presensiINMahasiswaToFBERequestModel
                                          //       .pertemuan = pertemuan;

                                          //   presensiINMahasiswaToFBERequestModel
                                          //       .tglin = jam + ' ' + tanggalnow;
                                          // } else if (fakultas == 'Hukum') {
                                          //   presensiINMahasiswaToFHRequestModel
                                          //       .idkelas = idkelasFakultas;

                                          //   presensiINMahasiswaToFHRequestModel
                                          //       .npm = npm;

                                          //   presensiINMahasiswaToFHRequestModel
                                          //       .pertemuan = pertemuan;

                                          //   presensiINMahasiswaToFHRequestModel
                                          //       .tglin = jam + ' ' + tanggalnow;
                                          // } else if (fakultas ==
                                          //     'Teknobiologi') {
                                          //   presensiINMahasiswaToFTBRequestModel
                                          //       .idkelas = idkelasFakultas;

                                          //   presensiINMahasiswaToFTBRequestModel
                                          //       .npm = npm;

                                          //   presensiINMahasiswaToFTBRequestModel
                                          //       .pertemuan = pertemuan;

                                          //   presensiINMahasiswaToFTBRequestModel
                                          //       .tglin = jam + ' ' + tanggalnow;
                                          // } else if (fakultas ==
                                          //     'Ilmu Sosial dan Politik') {
                                          //   presensiINMahasiswaToFISIPRequestModel
                                          //       .idkelas = idkelasFakultas;

                                          //   presensiINMahasiswaToFISIPRequestModel
                                          //       .npm = npm;

                                          //   presensiINMahasiswaToFISIPRequestModel
                                          //       .pertemuan = pertemuan;

                                          //   presensiINMahasiswaToFISIPRequestModel
                                          //       .tglin = jam + ' ' + tanggalnow;
                                          // } else if (fakultas == 'Teknik') {
                                          //   presensiINMahasiswaToFTRequestModel
                                          //       .idkelas = idkelasFakultas;

                                          //   presensiINMahasiswaToFTRequestModel
                                          //       .npm = npm;

                                          //   presensiINMahasiswaToFTRequestModel
                                          //       .pertemuan = pertemuan;

                                          //   presensiINMahasiswaToFTRequestModel
                                          //       .tglin = jam + ' ' + tanggalnow;
                                          // } else if (fakultas ==
                                          //     'Teknologi Industri') {
                                          //   presensiINMahasiswaToFTIRequestModel
                                          //       .idkelas = idkelasFakultas;

                                          //   presensiINMahasiswaToFTIRequestModel
                                          //       .npm = npm;

                                          //   presensiINMahasiswaToFTIRequestModel
                                          //       .pertemuan = pertemuan;

                                          //   presensiINMahasiswaToFTIRequestModel
                                          //       .tglin = jam + ' ' + tanggalnow;
                                          // }
                                        });

                                        print(
                                            PresensiINMahasiswaToKSIRequestModel()
                                                .toJson());

                                        // print(
                                        //     PresensiINMahasiswaToFBERequestModel()
                                        //         .toJson());

                                        // print(
                                        //     PresensiINMahasiswaToFHRequestModel()
                                        //         .toJson());

                                        // print(
                                        //     PresensiINMahasiswaToFISIPRequestModel()
                                        //         .toJson());

                                        // print(
                                        //     PresensiINMahasiswaToFTRequestModel()
                                        //         .toJson());

                                        // print(
                                        //     PresensiINMahasiswaToFTBRequestModel()
                                        //         .toJson());

                                        // print(
                                        //     PresensiINMahasiswaToFTIRequestModel()
                                        //         .toJson());

                                        APIService apiService =
                                            new APIService();

                                        // if (fakultas ==
                                        //     'Bisnis dan Ekonomika') {
                                        //   await apiService
                                        //       .postInsertPresensiMhsToFBE(
                                        //           presensiINMahasiswaToFBERequestModel);
                                        // } else if (fakultas == 'Hukum') {
                                        //   await apiService
                                        //       .postInsertPresensiMhsToFH(
                                        //           presensiINMahasiswaToFHRequestModel);
                                        // } else if (fakultas == 'Teknobiologi') {
                                        //   await apiService
                                        //       .postInsertPresensiMhsToFH(
                                        //           presensiINMahasiswaToFHRequestModel);
                                        // } else if (fakultas ==
                                        //     'Ilmu Sosial dan Politik') {
                                        //   await apiService
                                        //       .postInsertPresensiMhsToFISIP(
                                        //           presensiINMahasiswaToFISIPRequestModel);
                                        // } else if (fakultas == 'Teknik') {
                                        //   await apiService
                                        //       .postInsertPresensiMhsToFT(
                                        //           presensiINMahasiswaToFTRequestModel);
                                        // } else if (fakultas ==
                                        //     'Teknologi Industri') {
                                        //   await apiService
                                        //       .postInsertPresensiMhsToFTI(
                                        //           presensiINMahasiswaToFTIRequestModel);
                                        // }

                                        await apiService
                                            .postInsertPresensiMhsToKSI(
                                                presensiINMahasiswaToKSIRequestModel)
                                            .then((value) async {
                                          if (value != null) {
                                            setState(() {
                                              isApiCallProcess = false;
                                            });
                                          }

                                          Get.offAllNamed(
                                              '/mahasiswa/dashboard');

                                          await Fluttertoast.showToast(
                                              msg: 'Berhasil masuk ke kelas',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 14.0);
                                        });
                                      },
                                      onCancelBtnTap: (value) {},
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.arrow_upward_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Text(
                                        'Masuk',
                                        style: TextStyle(
                                            fontFamily: 'WorkSansMedium',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                )
                              : MaterialButton(
                                  color: Colors.red,
                                  shape: StadiumBorder(),
                                  padding: EdgeInsets.only(
                                      left: 50, right: 50, top: 25, bottom: 25),
                                  onPressed: () {
                                    SKAlertDialog.show(
                                      context: context,
                                      type: SKAlertType.buttons,
                                      title: 'Keluar ?',
                                      message:
                                          'Apakah anda yakin ingin\nkeluar dari kelas ini ?',
                                      okBtnText: 'Ya',
                                      okBtnTxtColor: Colors.white,
                                      okBtnColor: Colors.red,
                                      cancelBtnText: 'Tidak',
                                      cancelBtnTxtColor: Colors.white,
                                      cancelBtnColor: Colors.grey,
                                      onOkBtnTap: (value) async {
                                        SharedPreferences
                                            dataPresensiMahasiswa =
                                            await SharedPreferences
                                                .getInstance();

                                        await dataPresensiMahasiswa.setInt(
                                            'statuspresensi', 0);

                                        setState(() {
                                          isApiCallProcess = true;

                                          presensiOUTMahasiswaToKSIRequestModel
                                              .idkelas = idkelas;

                                          presensiOUTMahasiswaToKSIRequestModel
                                              .npm = npm;

                                          presensiOUTMahasiswaToKSIRequestModel
                                              .pertemuan = pertemuan;

                                          presensiOUTMahasiswaToKSIRequestModel
                                              .tglout = jam + ' ' + tanggalnow;

                                          presensiOUTMahasiswaToKSIRequestModel
                                              .status = 'H';
                                          // if (fakultas ==
                                          //     'Bisnis dan Ekonomika') {
                                          //   presensiOUTMahasiswaToFBERequestModel
                                          //       .idkelas = idkelasFakultas;

                                          //   presensiOUTMahasiswaToFBERequestModel
                                          //       .npm = npm;

                                          //   presensiOUTMahasiswaToFBERequestModel
                                          //       .pertemuan = pertemuan;

                                          //   presensiOUTMahasiswaToFBERequestModel
                                          //           .tglout =
                                          //       jam + ' ' + tanggalnow;

                                          //   presensiOUTMahasiswaToFBERequestModel
                                          //       .status = 'H';
                                          // } else if (fakultas == 'Hukum') {
                                          //   presensiOUTMahasiswaToFHRequestModel
                                          //       .idkelas = idkelasFakultas;

                                          //   presensiOUTMahasiswaToFHRequestModel
                                          //       .npm = npm;

                                          //   presensiOUTMahasiswaToFHRequestModel
                                          //       .pertemuan = pertemuan;

                                          //   presensiOUTMahasiswaToFHRequestModel
                                          //           .tglout =
                                          //       jam + ' ' + tanggalnow;

                                          //   presensiOUTMahasiswaToFHRequestModel
                                          //       .status = 'H';
                                          // } else if (fakultas ==
                                          //     'Teknobiologi') {
                                          //   presensiOUTMahasiswaToFTBRequestModel
                                          //       .idkelas = idkelasFakultas;

                                          //   presensiOUTMahasiswaToFTBRequestModel
                                          //       .npm = npm;

                                          //   presensiOUTMahasiswaToFTBRequestModel
                                          //       .pertemuan = pertemuan;

                                          //   presensiOUTMahasiswaToFTBRequestModel
                                          //           .tglout =
                                          //       jam + ' ' + tanggalnow;

                                          //   presensiOUTMahasiswaToFTBRequestModel
                                          //       .status = 'H';
                                          // } else if (fakultas ==
                                          //     'Ilmu Sosial dan Politik') {
                                          //   presensiOUTMahasiswaToFISIPRequestModel
                                          //       .idkelas = idkelasFakultas;

                                          //   presensiOUTMahasiswaToFISIPRequestModel
                                          //       .npm = npm;

                                          //   presensiOUTMahasiswaToFISIPRequestModel
                                          //       .pertemuan = pertemuan;

                                          //   presensiOUTMahasiswaToFISIPRequestModel
                                          //           .tglout =
                                          //       jam + ' ' + tanggalnow;

                                          //   presensiOUTMahasiswaToFISIPRequestModel
                                          //       .status = 'H';
                                          // } else if (fakultas == 'Teknik') {
                                          //   presensiOUTMahasiswaToFTRequestModel
                                          //       .idkelas = idkelasFakultas;

                                          //   presensiOUTMahasiswaToFTRequestModel
                                          //       .npm = npm;

                                          //   presensiOUTMahasiswaToFTRequestModel
                                          //       .pertemuan = pertemuan;

                                          //   presensiOUTMahasiswaToFTRequestModel
                                          //           .tglout =
                                          //       jam + ' ' + tanggalnow;

                                          //   presensiOUTMahasiswaToFTRequestModel
                                          //       .status = 'H';
                                          // } else if (fakultas ==
                                          //     'Teknologi Industri') {
                                          //   presensiOUTMahasiswaToFTIRequestModel
                                          //       .idkelas = idkelasFakultas;

                                          //   presensiOUTMahasiswaToFTIRequestModel
                                          //       .npm = npm;

                                          //   presensiOUTMahasiswaToFTIRequestModel
                                          //       .pertemuan = pertemuan;

                                          //   presensiOUTMahasiswaToFTIRequestModel
                                          //           .tglout =
                                          //       jam + ' ' + tanggalnow;

                                          //   presensiOUTMahasiswaToFTIRequestModel
                                          //       .status = 'H';
                                          // }
                                        });

                                        print(
                                            PresensiOUTMahasiswaToKSIRequestModel()
                                                .toJson());

                                        // print(
                                        //     PresensiOUTMahasiswaToFBERequestModel()
                                        //         .toJson());

                                        // print(
                                        //     PresensiOUTMahasiswaToFHRequestModel()
                                        //         .toJson());

                                        // print(
                                        //     PresensiOUTMahasiswaToFISIPRequestModel()
                                        //         .toJson());

                                        // print(
                                        //     PresensiOUTMahasiswaToFTRequestModel()
                                        //         .toJson());

                                        // print(
                                        //     PresensiOUTMahasiswaToFTBRequestModel()
                                        //         .toJson());

                                        // print(
                                        //     PresensiOUTMahasiswaToFTIRequestModel()
                                        //         .toJson());

                                        APIService apiService =
                                            new APIService();

                                        // if (fakultas ==
                                        //     'Bisnis dan Ekonomika') {
                                        //   await apiService
                                        //       .putUpdatePresensiMhsToFBE(
                                        //           presensiOUTMahasiswaToFBERequestModel);
                                        // } else if (fakultas == 'Hukum') {
                                        //   await apiService.putUpdatePresensiMhsToFH(
                                        //       presensiOUTMahasiswaToFHRequestModel);
                                        // } else if (fakultas == 'Teknobiologi') {
                                        //   await apiService
                                        //       .putUpdatePresensiMhsToFTB(
                                        //           presensiOUTMahasiswaToFTBRequestModel);
                                        // } else if (fakultas ==
                                        //     'Ilmu Sosial dan Politik') {
                                        //   await apiService
                                        //       .putUpdatePresensiMhsToFISIP(
                                        //           presensiOUTMahasiswaToFISIPRequestModel);
                                        // } else if (fakultas == 'Teknik') {
                                        //   await apiService.putUpdatePresensiMhsToFT(
                                        //       presensiOUTMahasiswaToFTRequestModel);
                                        // } else if (fakultas ==
                                        //     'Teknologi Industri') {
                                        //   await apiService
                                        //       .putUpdatePresensiMhsToFTI(
                                        //           presensiOUTMahasiswaToFTIRequestModel);
                                        // }

                                        await apiService
                                            .putUpdatePresensiMhsToKSI(
                                                presensiOUTMahasiswaToKSIRequestModel)
                                            .then((value) async {
                                          if (value != null) {
                                            setState(() {
                                              isApiCallProcess = false;
                                            });
                                          }

                                          Get.offAllNamed(
                                              '/mahasiswa/dashboard');

                                          await Fluttertoast.showToast(
                                              msg:
                                                  'Berhasil keluar dari kelas, data presensi telah tersimpan',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 14.0);
                                        });
                                      },
                                      onCancelBtnTap: (value) {},
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.arrow_downward_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Text(
                                        'Keluar',
                                        style: TextStyle(
                                            fontFamily: 'WorkSansMedium',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            color: Colors.blue,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.only(
                                left: 50, right: 50, top: 25, bottom: 25),
                            onPressed: () =>
                                {Get.offAllNamed('/mahasiswa/dashboard')},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  'Kembali ke Menu',
                                  style: TextStyle(
                                      fontFamily: 'WorkSansMedium',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
