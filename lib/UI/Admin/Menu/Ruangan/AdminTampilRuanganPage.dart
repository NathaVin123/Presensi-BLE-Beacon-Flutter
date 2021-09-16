import 'package:flutter/material.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/ListDetailRuanganModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminTampilRuanganPage extends StatefulWidget {
  AdminTampilRuanganPage({Key key}) : super(key: key);

  @override
  _AdminTampilRuanganPageState createState() => _AdminTampilRuanganPageState();
}

class _AdminTampilRuanganPageState extends State<AdminTampilRuanganPage> {
  ListDetailRuanganResponseModel listDetailRuanganResponseModel;

  @override
  void initState() {
    super.initState();

    listDetailRuanganResponseModel = ListDetailRuanganResponseModel();

    getListDetailRuangan();
  }

  void getListDetailRuangan() async {
    setState(() {
      print(listDetailRuanganResponseModel.toJson());

      APIService apiService = new APIService();

      apiService.getListDetailRuangan().then((value) async {
        listDetailRuanganResponseModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        centerTitle: true,
        title: Text(
          'Tampil Ruangan',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'WorkSansMedium',
              fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: () => {_streamRanging?.resume(), getDataRuangBeacon()},
        onPressed: () => getListDetailRuangan(),
        label: Text(
          'Segarkan',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontFamily: 'WorkSansMedium'),
        ),
        icon: Icon(Icons.search_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      // body: CustomScrollView(
      //   slivers: <Widget>[
      //     SliverAppBar(
      //       iconTheme: IconThemeData(color: Colors.white),
      //       backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      //       pinned: true,
      //       floating: false,
      //       snap: false,
      //       expandedHeight: 85,
      //       flexibleSpace: const FlexibleSpaceBar(
      //         centerTitle: true,
      //         title: Text(
      //           'Ubah Beacon',
      //           style: TextStyle(
      //               color: Colors.white,
      //               fontFamily: 'WorkSansMedium',
      //               fontWeight: FontWeight.bold),
      //         ),
      //       ),
      //     ),
      //     SliverToBoxAdapter(
      //     child: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Center(
      //       child: Text(
      //     'Aplikasi sedang dalam pembangunan, tunggu update selanjutnya ya...',
      //     style: TextStyle(color: Colors.white),
      //   )),
      // )
      body: Column(
        children: <Widget>[
          listDetailRuanganResponseModel.data == null
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Silakan tekan tombol segarkan',
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
                  child: ListView.builder(
                      itemCount: listDetailRuanganResponseModel.data?.length,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      'Ruang ${listDetailRuanganResponseModel.data[index].ruang}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'WorkSansMedium',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    new Text(
                                      'Fakultas ${listDetailRuanganResponseModel.data[index].fakultas}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'WorkSansMedium',
                                      ),
                                    ),
                                    new Text(
                                      'Prodi ${listDetailRuanganResponseModel.data[index].prodi}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'WorkSansMedium',
                                      ),
                                    ),
                                    new Text(
                                      'Nama Device : ${listDetailRuanganResponseModel.data[index].namadevice}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'WorkSansMedium',
                                      ),
                                    ),
                                    new Text(
                                      'Jarak Minimal :  ${listDetailRuanganResponseModel.data[index].jarak} m',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'WorkSansMedium',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {},
                            ),
                          ),
                        );
                      }),
                )
        ],
      ),
    );
  }
}
