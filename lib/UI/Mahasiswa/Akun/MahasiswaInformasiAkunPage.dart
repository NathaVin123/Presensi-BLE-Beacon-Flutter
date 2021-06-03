import 'package:flutter/material.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensiblebeacon/UI/Mahasiswa/Akun/MahasiswaAkunDashboardPage.dart';

class MahasiswaInformasiAkunPage extends StatefulWidget {
  MahasiswaInformasiAkunPage({Key key}) : super(key: key);

  @override
  _MahasiswaInformasiAkunPageState createState() =>
      _MahasiswaInformasiAkunPageState();
}

class _MahasiswaInformasiAkunPageState
    extends State<MahasiswaInformasiAkunPage> {
  String npm = "";
  String namamhs = "";
  String tmplahir = "";
  String tgllahir = "";
  String alamat = "";
  String fakultas = "";
  String prodi = "";
  String pembimbingakademik = "";

  @override
  void initState() {
    super.initState();
    // getDataMahasiswa();
  }

  // void getDataMahasiswa() async {
  //   SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();

  //   npm = loginMahasiswa.getString('npm');
  //   namamhs = loginMahasiswa.getString('namamhs');
  //   tmplahir = loginMahasiswa.getString('tmplahir');
  //   tgllahir = loginMahasiswa.getString('tgllahir');
  //   alamat = loginMahasiswa.getString('alamat');
  //   fakultas = loginMahasiswa.getString('fakultas');
  //   prodi = loginMahasiswa.getString('prodi');
  //   pembimbingakademik = loginMahasiswa.getString('pembimbingakademik');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            pinned: true,
            floating: false,
            snap: false,
            expandedHeight: 85,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Informasi Akun',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 14, right: 14, top: 14),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25)),
                        // decoration: BoxDecoration(),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'person-male'.png,
                                  height: 150.0,
                                  width: 100.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                  child: Column(
                                children: [
                                  Text('Nama Mahasiswa',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'WorkSansMedium',
                                          fontSize: 22)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(namamhs,
                                      style: TextStyle(
                                          fontFamily: 'WorkSansMedium',
                                          fontSize: 18)),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'NPM',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'WorkSansMedium',
                                        fontSize: 22),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    npm,
                                    style: TextStyle(
                                        fontFamily: 'WorkSansMedium',
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'Program Studi',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'WorkSansMedium',
                                        fontSize: 22),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    prodi,
                                    style: TextStyle(
                                        fontFamily: 'WorkSansMedium',
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'Fakultas',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'WorkSansMedium',
                                        fontSize: 22),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    fakultas,
                                    style: TextStyle(
                                        fontFamily: 'WorkSansMedium',
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'Dosen Pembimbing Akademik',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'WorkSansMedium',
                                        fontSize: 22),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    pembimbingakademik,
                                    style: TextStyle(
                                        fontFamily: 'WorkSansMedium',
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              )),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}