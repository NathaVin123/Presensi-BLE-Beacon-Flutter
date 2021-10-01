import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToKSIModel.dart';
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
  int idkelas = 0;
  String ruang = "";
  String namamk = "";
  String kelas = "";
  int sks = 0;
  int pertemuan = 0;
  String hari = "";
  String sesi = "";
  int kapasitas = 0;
  String jam = "";
  String tanggal = "";
  int bukapresensi = 0;

  int statusPresensi = 0;

  bool isApiCallProcess = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  PresensiINMahasiswaToKSIRequestModel presensiINMahasiswaToKSIRequestModel;

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
  }

  getDetailMahasiswa() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();

    setState(() {
      npm = loginMahasiswa.getString('npm');
    });
  }

  getDetailKelas() async {
    SharedPreferences dataPresensiMahasiswa =
        await SharedPreferences.getInstance();

    setState(() {
      idkelas = dataPresensiMahasiswa.getInt('idkelas');
      ruang = dataPresensiMahasiswa.getString('ruang');
      namamk = dataPresensiMahasiswa.getString('namamk');
      kelas = dataPresensiMahasiswa.getString('kelas');
      sks = dataPresensiMahasiswa.getInt('sks');
      pertemuan = dataPresensiMahasiswa.getInt('pertemuan');
      hari = dataPresensiMahasiswa.getString('hari1');
      sesi = dataPresensiMahasiswa.getString('sesi1');
      kapasitas = dataPresensiMahasiswa.getInt('kapasitas');
      jam = dataPresensiMahasiswa.getString('jam');
      tanggal = dataPresensiMahasiswa.getString('tanggal');
      bukapresensi = dataPresensiMahasiswa.getInt('bukapresensi');

      statusPresensi = dataPresensiMahasiswa.getInt('statuspresensi');
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                '${tanggal ?? "-"}',
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'ID Kelas',
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
                                '${idkelas ?? "-"}',
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Text(
                                'Buka Presensi',
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
                                '${bukapresensi ?? "-"}',
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
                                'Status',
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
                                '${statusPresensi ?? "-"}',
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
                      )),
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
                                              .tglin = jam + ' ' + tanggal;
                                        });

                                        print(
                                            PresensiINMahasiswaToKSIRequestModel()
                                                .toJson());

                                        APIService apiService =
                                            new APIService();

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

                                        Get.offAllNamed('/mahasiswa/dashboard');

                                        await Fluttertoast.showToast(
                                            msg:
                                                'Berhasil keluar dari kelas, data presensi telah tersimpan',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 14.0);
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
