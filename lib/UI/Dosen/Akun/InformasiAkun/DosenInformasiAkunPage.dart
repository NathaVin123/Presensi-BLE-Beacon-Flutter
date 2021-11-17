import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DosenInformasiAkunPage extends StatefulWidget {
  DosenInformasiAkunPage({Key key}) : super(key: key);

  @override
  _DosenInformasiAkunPageState createState() => _DosenInformasiAkunPageState();
}

class _DosenInformasiAkunPageState extends State<DosenInformasiAkunPage> {
  String npp = "";
  String namadsn = "";
  String fakultas = "";
  String prodi = "";

  @override
  void initState() {
    super.initState();
    getDataInfoDosen();
  }

  getDataInfoDosen() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();
    setState(() {
      npp = loginMahasiswa.getString('npp');
      namadsn = loginMahasiswa.getString('namadsn');
      fakultas = loginMahasiswa.getString('fakultas');
      prodi = loginMahasiswa.getString('prodi');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color.fromRGBO(23, 75, 137, 1),
            pinned: true,
            floating: false,
            snap: false,
            expandedHeight: 85,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Informasi Akun',
                style: TextStyle(
                    color: Colors.white,
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
                              padding: EdgeInsets.all(22),
                              child: Initicon(
                                text: namadsn,
                                backgroundColor: Colors.grey[400],
                                size: 80,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                  child: Column(
                                children: <Widget>[
                                  Text('Nama Dosen',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'WorkSansMedium',
                                          fontSize: 22)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Scrollbar(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(namadsn,
                                            style: TextStyle(
                                                fontFamily: 'WorkSansMedium',
                                                fontSize: 18)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'NPP',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'WorkSansMedium',
                                        fontSize: 22),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    npp,
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
