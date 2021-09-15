import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/ListRuanganModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRuanganPage extends StatefulWidget {
  @override
  _AdminRuanganPageState createState() => _AdminRuanganPageState();
}

class _AdminRuanganPageState extends State<AdminRuanganPage>
    with WidgetsBindingObserver {
  ListRuanganResponseModel listRuanganResponseModel;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    listRuanganResponseModel = ListRuanganResponseModel();

    getListRuangan();
  }

  void getListRuangan() async {
    setState(() {
      print(listRuanganResponseModel.toJson());

      APIService apiService = new APIService();

      apiService.getListRuangan().then((value) async {
        listRuanganResponseModel = value;
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
          'Pengaturan Ruang',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'WorkSansMedium',
              fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: () => {_streamRanging?.resume(), getDataRuangBeacon()},
        onPressed: () => getListRuangan(),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Pilih Ruang',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSansMedium',
                    color: Colors.white),
              ),
            ),
          ),
          listRuanganResponseModel.data == null
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
                      itemCount: listRuanganResponseModel.data?.length,
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
                                      'Ruang ${listRuanganResponseModel.data[index].ruang}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'WorkSansMedium',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                Get.toNamed('/admin/menu/ruangan/detail');

                                SharedPreferences saveRuangan =
                                    await SharedPreferences.getInstance();

                                await saveRuangan.setString('ruang',
                                    listRuanganResponseModel.data[index].ruang);
                              },
                            ),
                          ),
                        );
                      }),
                )
        ],
      ),
      //     )
      //   ],
      // ),
    );
  }
}
