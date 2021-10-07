import 'dart:async';
import 'package:flutter/material.dart';
import 'package:presensiblebeacon/MODEL/Mahasiswa/JadwalMahasiswaModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:intl/intl.dart';

class MahasiswaJadwalDashboardPage extends StatefulWidget {
  MahasiswaJadwalDashboardPage({Key key}) : super(key: key);

  @override
  _MahasiswaJadwalDashboardPageState createState() =>
      _MahasiswaJadwalDashboardPageState();
}

class Semester {
  String semester;
  Semester(this.semester);
}

class _MahasiswaJadwalDashboardPageState
    extends State<MahasiswaJadwalDashboardPage> {
  String _dateString;

  String npm = "";
  String semesterShared = "";

  String data;

  Semester selectedSemester;

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

  JadwalMahasiswaRequestModel jadwalMahasiswaRequestModel;

  JadwalMahasiswaResponseModel jadwalMahasiswaResponseModel;

  @override
  void initState() {
    super.initState();

    jadwalMahasiswaRequestModel = JadwalMahasiswaRequestModel();
    jadwalMahasiswaResponseModel = JadwalMahasiswaResponseModel();

    _dateString = _formatDate(DateTime.now());

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
      jadwalMahasiswaRequestModel.semester = semesterShared;

      print(jadwalMahasiswaRequestModel.toJson());
      APIService apiService = new APIService();
      apiService
          .postJadwalMahasiswa(jadwalMahasiswaRequestModel)
          .then((value) async {
        jadwalMahasiswaResponseModel = value;
      });
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
          'Jadwal Kelas',
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
                Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            _dateString,
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'WorkSansMedium',
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                Center(
                    child: Text(
                  'Pilih Semester',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'WorkSansMedium',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                          color: Colors.white,
                          style: BorderStyle.solid,
                          width: 1),
                    ),
                    child: DropdownButton(
                      iconEnabledColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      dropdownColor: Color.fromRGBO(23, 75, 137, 1),
                      underline: Text(''),
                      onTap: () => {
                        Timer.periodic(Duration(seconds: 1), (Timer t) {
                          getDataJadwalMahasiswa();
                          Future.delayed(Duration(seconds: 5), () {
                            t.cancel();
                          });
                        })
                      },
                      items: generateSemester(semesters),
                      value: selectedSemester,
                      onChanged: (item) {
                        setState(() {
                          selectedSemester = item;
                          semesterShared = selectedSemester.semester;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          jadwalMahasiswaResponseModel.data == null
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Silakan pilih semester, \n lalu tekan tombol segarkan',
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
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      new Text(
                                        jadwalMahasiswaResponseModel
                                            .data[index].namamk,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'WorkSansMedium',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        jadwalMahasiswaResponseModel
                                            .data[index].kelas,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'WorkSansMedium',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        jadwalMahasiswaResponseModel
                                            .data[index].namadosen,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'WorkSansMedium',
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Text(
                                              jadwalMahasiswaResponseModel
                                                  .data[index].hari,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'WorkSansMedium',
                                              ),
                                            ),
                                            Text(
                                              'Ruang ${jadwalMahasiswaResponseModel.data[index].ruang}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'WorkSansMedium',
                                              ),
                                            ),
                                            Text(
                                              'Sesi ${jadwalMahasiswaResponseModel.data[index].sesi}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'WorkSansMedium',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
