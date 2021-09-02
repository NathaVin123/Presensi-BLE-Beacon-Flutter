import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Beacon/ListBeaconModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DosenUbahBeacon extends StatefulWidget {
  @override
  _DosenUbahBeaconState createState() => _DosenUbahBeaconState();
}

class _DosenUbahBeaconState extends State<DosenUbahBeacon>
    with WidgetsBindingObserver {
  ListBeaconResponseModel listBeaconResponseModel;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    listBeaconResponseModel = ListBeaconResponseModel();

    getListBeacon();
  }

  void getListBeacon() async {
    setState(() {
      print(listBeaconResponseModel.toJson());

      APIService apiService = new APIService();

      apiService.getListBeacon().then((value) async {
        listBeaconResponseModel = value;
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
          'Ubah Beacon',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'WorkSansMedium',
              fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: () => {_streamRanging?.resume(), getDataRuangBeacon()},
        onPressed: () => getListBeacon(),
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
            padding:
                const EdgeInsets.only(left: 20, right: 25, top: 10, bottom: 5),
            child: Align(
              alignment: Alignment.topLeft,
              // child: Center(
              //   child: Text(
              //     'Daftar Beacon',
              //     style: TextStyle(
              //         fontSize: 22,
              //         fontWeight: FontWeight.bold,
              //         fontFamily: 'WorkSansMedium',
              //         color: Colors.white),
              //   ),
              // ),
            ),
          ),
          listBeaconResponseModel.data == null
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
                      itemCount: listBeaconResponseModel.data?.length,
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
                                      listBeaconResponseModel
                                          .data[index].namadevice,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'WorkSansMedium',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    new Text(
                                      'UUID',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'WorkSansMedium',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    new Text(
                                      listBeaconResponseModel.data[index].uuid,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'WorkSansMedium',
                                      ),
                                    ),
                                    new Text(
                                      'Jarak Minimal',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'WorkSansMedium',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    new Text(
                                      '${listBeaconResponseModel.data[index].jarakmin} m',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'WorkSansMedium',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                Get.toNamed('/admin/menu/beacon/detail/Ubah');
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
