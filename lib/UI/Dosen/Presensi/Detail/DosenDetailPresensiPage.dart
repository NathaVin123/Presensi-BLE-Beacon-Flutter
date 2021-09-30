import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINDosenBukaPresensiModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sk_alert_dialog/sk_alert_dialog.dart';

class DosenDetailPresensiPage extends StatefulWidget {
  @override
  _DosenDetailPresensiPageState createState() =>
      _DosenDetailPresensiPageState();
}

class _DosenDetailPresensiPageState extends State<DosenDetailPresensiPage> {
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

  var _materiFieldController = TextEditingController();

  bool isApiCallProcess = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  PresensiINDosenBukaPresensiRequestModel
      presensiINDosenBukaPresensiRequestModel;

  @override
  void initState() {
    super.initState();

    presensiINDosenBukaPresensiRequestModel =
        PresensiINDosenBukaPresensiRequestModel();

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getDetailKelas();
      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });
  }

  getDetailKelas() async {
    SharedPreferences dataPresensiDosen = await SharedPreferences.getInstance();

    setState(() {
      idkelas = dataPresensiDosen.getInt('idkelas');
      ruang = dataPresensiDosen.getString('ruang');
      namamk = dataPresensiDosen.getString('namamk');
      kelas = dataPresensiDosen.getString('kelas');
      sks = dataPresensiDosen.getInt('sks');
      pertemuan = dataPresensiDosen.getInt('pertemuan');
      hari = dataPresensiDosen.getString('hari1');
      sesi = dataPresensiDosen.getString('sesi1');
      kapasitas = dataPresensiDosen.getInt('kapasitas');
      jam = dataPresensiDosen.getString('jam');
      tanggal = dataPresensiDosen.getString('tanggal');
      bukapresensi = dataPresensiDosen.getInt('bukapresensi');
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
            iconTheme: IconThemeData(color: Colors.black),
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
                          bukapresensi == 0
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
                                  )),
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
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: new Center(
                          //     child: new Text(
                          //       'Jam Keluar',
                          //       style: TextStyle(
                          //           fontFamily: 'WorkSansMedium',
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 20),
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: new Center(
                          //     child: new Text(
                          //       '-',
                          //       style: TextStyle(
                          //           fontFamily: 'WorkSansMedium',
                          //           // fontWeight:
                          //           //     FontWeight.bold,
                          //           fontSize: 18),
                          //     ),
                          //   ),
                          // ),
                        ],
                      )),
                ),
                bukapresensi == 1
                    ? Column(
                        children: <Widget>[
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: globalFormKey,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'Materi',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: TextFormField(
                                        controller: _materiFieldController,
                                        style: const TextStyle(
                                            fontFamily: 'WorkSansSemiBold',
                                            fontSize: 16.0,
                                            color: Colors.black),
                                        keyboardType: TextInputType.text,
                                        decoration: new InputDecoration(
                                            hintText:
                                                'Silahkan Isi Materi Anda'),
                                        validator: (input) => input.length < 1
                                            ? "Materi tidak boleh kosong"
                                            : null,
                                        // onSaved: (input) =>
                                        //     ubahBeaconRequestModel.uuid = input,
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 0,
                      ),
                Divider(
                  height: 20,
                  thickness: 10,
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
                                  '/dosen/dashboard/presensi/detail/tampilpeserta')
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
                          bukapresensi == 0
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
                                          'Apakah anda yakin ingin\nmembuka kelas ini ?',
                                      okBtnText: 'Ya',
                                      okBtnTxtColor: Colors.white,
                                      okBtnColor: Colors.green,
                                      cancelBtnText: 'Tidak',
                                      cancelBtnTxtColor: Colors.white,
                                      cancelBtnColor: Colors.grey,
                                      onOkBtnTap: (value) async {
                                        print(
                                            presensiINDosenBukaPresensiRequestModel
                                                .toJson());

                                        print(idkelas);

                                        print(bukapresensi);

                                        setState(() {
                                          isApiCallProcess = true;

                                          presensiINDosenBukaPresensiRequestModel
                                              .idkelas = idkelas;

                                          presensiINDosenBukaPresensiRequestModel
                                              .bukapresensi = 1;
                                        });

                                        APIService apiService =
                                            new APIService();

                                        apiService
                                            .putBukaPresensiDosen(
                                                presensiINDosenBukaPresensiRequestModel)
                                            .then((value) async {
                                          if (value != null) {
                                            setState(() {
                                              isApiCallProcess = false;
                                            });
                                          }
                                          Get.offAllNamed('/dosen/dashboard');

                                          await Fluttertoast.showToast(
                                              msg: 'Berhasil Membuka Kelas',
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
                              :
                              // MaterialButton(
                              //     color: Colors.grey,
                              //     shape: StadiumBorder(),
                              //     padding: EdgeInsets.only(
                              //         left: 50, right: 50, top: 25, bottom: 25),
                              //     onPressed: () {},
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: <Widget>[
                              //         Icon(
                              //           Icons.arrow_upward_rounded,
                              //           color: Colors.white,
                              //         ),
                              //         SizedBox(
                              //           width: 25,
                              //         ),
                              //         Text(
                              //           'Masuk',
                              //           style: TextStyle(
                              //               fontFamily: 'WorkSansMedium',
                              //               fontWeight: FontWeight.bold,
                              //               color: Colors.white,
                              //               fontSize: 18),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              SizedBox(
                                  height: 0,
                                ),
                          bukapresensi == 0
                              ? SizedBox(
                                  height: 0,
                                )
                              // MaterialButton(
                              //     color: Colors.grey,
                              //     shape: StadiumBorder(),
                              //     padding: EdgeInsets.only(
                              //         left: 50, right: 50, top: 25, bottom: 25),
                              //     onPressed: () {},
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: <Widget>[
                              //         Icon(
                              //           Icons.arrow_downward_rounded,
                              //           color: Colors.white,
                              //         ),
                              //         SizedBox(
                              //           width: 25,
                              //         ),
                              //         Text(
                              //           'Keluar',
                              //           style: TextStyle(
                              //               fontFamily: 'WorkSansMedium',
                              //               fontWeight: FontWeight.bold,
                              //               color: Colors.white,
                              //               fontSize: 18),
                              //         ),
                              //       ],
                              //     ),
                              //   )
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
                                          'Apakah anda yakin\ningin mengakhiri kelas ?',
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

                                        print(
                                            presensiINDosenBukaPresensiRequestModel
                                                .toJson());

                                        print(idkelas);

                                        print(bukapresensi);

                                        setState(() {
                                          isApiCallProcess = true;

                                          presensiINDosenBukaPresensiRequestModel
                                              .idkelas = idkelas;

                                          presensiINDosenBukaPresensiRequestModel
                                              .bukapresensi = 0;
                                        });

                                        APIService apiService =
                                            new APIService();

                                        apiService
                                            .putBukaPresensiDosen(
                                                presensiINDosenBukaPresensiRequestModel)
                                            .then((value) async {
                                          if (value != null) {
                                            setState(() {
                                              isApiCallProcess = false;
                                            });
                                          }
                                          Get.offAllNamed('/dosen/dashboard');

                                          await Fluttertoast.showToast(
                                              msg:
                                                  'Berhasil Mengakhiri Kelas, data presensi sudah tersimpan',
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
                                {Get.offAllNamed('/dosen/dashboard')},
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
