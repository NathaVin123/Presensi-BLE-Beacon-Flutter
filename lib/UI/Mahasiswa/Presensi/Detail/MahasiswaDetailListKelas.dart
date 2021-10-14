import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Presensi/ListKelasMahasiswa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MahasiswaDetailListKelas extends StatefulWidget {
  @override
  _MahasiswaDetailListKelasState createState() =>
      _MahasiswaDetailListKelasState();
}

class _MahasiswaDetailListKelasState extends State<MahasiswaDetailListKelas>
    with WidgetsBindingObserver {
  String kelas = "";
  String jam = "";
  String tanggal = "";

  String npm = "";

  String namamhs = "";

  ListKelasMahasiswaRequestModel listKelasMahasiswaRequestModel;

  ListKelasMahasiswaResponseModel listKelasMahasiswaResponseModel;

  @override
  void initState() {
    listKelasMahasiswaRequestModel = ListKelasMahasiswaRequestModel();
    listKelasMahasiswaResponseModel = ListKelasMahasiswaResponseModel();

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getDataMahasiswa();
      Future.delayed(Duration(seconds: 10), () {
        t.cancel();
      });
    });

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getDataListKelasMahasiswa();
      Future.delayed(Duration(seconds: 10), () {
        t.cancel();
      });
    });
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
          .postListAllKelasMahasiswa(listKelasMahasiswaRequestModel)
          .then((value) async {
        listKelasMahasiswaResponseModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => getDataListKelasMahasiswa(),
          label: Text(
            'Segarkan',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'WorkSansMedium'),
          ),
          icon: Icon(Icons.search_rounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          centerTitle: true,
          title: Text(
            'List Kuliah Mahasiswa',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'WorkSansMedium',
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: <Widget>[
            listKelasMahasiswaResponseModel.data == null ||
                    listKelasMahasiswaResponseModel.data.isEmpty
                ? Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                                  fontSize: 15,
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
                                                    '${listKelasMahasiswaResponseModel.data[index].hari1}'
                                                    ','
                                                    ' '
                                                    '${listKelasMahasiswaResponseModel.data[index].tglmasuk}',
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
                                            'Ruang ${listKelasMahasiswaResponseModel.data[index].ruang}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: new Text(
                                              '${listKelasMahasiswaResponseModel.data[index].namamk} ${listKelasMahasiswaResponseModel.data[index].kelas}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: new Text(
                                              '${listKelasMahasiswaResponseModel.data[index].namadosen1}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, bottom: 8),
                                            child: new Text(
                                              'Pertemuan Ke : ${listKelasMahasiswaResponseModel.data[index].pertemuan}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
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
                                                  '${listKelasMahasiswaResponseModel.data[index].jammasuk}'
                                                  ' '
                                                  '-'
                                                  ' '
                                                  '${listKelasMahasiswaResponseModel.data[index].jamkeluar}',
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
                                          listKelasMahasiswaResponseModel
                                                      .data[index]
                                                      .bukapresensi ==
                                                  0
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                      SharedPreferences dataPresensiMahasiswa =
                                          await SharedPreferences.getInstance();

                                      await dataPresensiMahasiswa.setString(
                                          'ruang',
                                          listKelasMahasiswaResponseModel
                                              .data[index].ruang);

                                      await dataPresensiMahasiswa.setString(
                                          'uuid',
                                          listKelasMahasiswaResponseModel
                                              .data[index].uuid);

                                      await dataPresensiMahasiswa.setDouble(
                                          'jarakmin',
                                          listKelasMahasiswaResponseModel
                                              .data[index].jarakmin);

                                      await dataPresensiMahasiswa.setInt(
                                          'idkelas',
                                          listKelasMahasiswaResponseModel
                                              .data[index].idkelas);

                                      await dataPresensiMahasiswa.setString(
                                          'namamk',
                                          listKelasMahasiswaResponseModel
                                              .data[index].namamk);

                                      await dataPresensiMahasiswa.setString(
                                          'kelas',
                                          listKelasMahasiswaResponseModel
                                              .data[index].kelas);

                                      await dataPresensiMahasiswa.setString(
                                          'nppdosen1',
                                          listKelasMahasiswaResponseModel
                                              .data[index].nppdosen1);

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

                                      await dataPresensiMahasiswa.setString(
                                          'namadosen1',
                                          listKelasMahasiswaResponseModel
                                              .data[index].namadosen1);
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

                                      await dataPresensiMahasiswa.setString(
                                          'hari1',
                                          listKelasMahasiswaResponseModel
                                              .data[index].hari1);

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

                                      await dataPresensiMahasiswa.setString(
                                          'sesi1',
                                          listKelasMahasiswaResponseModel
                                              .data[index].sesi1);

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

                                      await dataPresensiMahasiswa.setInt(
                                          'sks',
                                          listKelasMahasiswaResponseModel
                                              .data[index].sks);

                                      await dataPresensiMahasiswa.setInt(
                                          'pertemuan',
                                          listKelasMahasiswaResponseModel
                                              .data[index].pertemuan);

                                      await dataPresensiMahasiswa.setString(
                                          'namadevice',
                                          listKelasMahasiswaResponseModel
                                              .data[index].namadevice);

                                      await dataPresensiMahasiswa.setInt(
                                          'kapasitas',
                                          listKelasMahasiswaResponseModel
                                              .data[index].kapasitas);

                                      await dataPresensiMahasiswa.setString(
                                          'tglmasuk',
                                          listKelasMahasiswaResponseModel
                                              .data[index].tglmasuk);

                                      await dataPresensiMahasiswa.setString(
                                          'tglkeluar',
                                          listKelasMahasiswaResponseModel
                                              .data[index].tglkeluar);

                                      await dataPresensiMahasiswa.setInt(
                                          'bukapresensi',
                                          listKelasMahasiswaResponseModel
                                              .data[index].bukapresensi);

                                      await Get.toNamed('/pindaiMahasiswa');
                                    },
                                  ),
                                ),
                              );
                            } else
                              return SizedBox(
                                height: 0,
                              );
                          }),
                    ),
                  )
          ],
        ));
  }
}
