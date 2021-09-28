import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Beacon/ListBeaconModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminTampilListBeacon extends StatefulWidget {
  AdminTampilListBeacon({Key key}) : super(key: key);

  @override
  _AdminTampilListBeaconState createState() => _AdminTampilListBeaconState();
}

class _AdminTampilListBeaconState extends State<AdminTampilListBeacon> {
  ListBeaconResponseModel listBeaconResponseModel;

  List<Data> beaconListSearch = List<Data>();

  @override
  void initState() {
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

        beaconListSearch = value.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        centerTitle: true,
        title: Text(
          'Tampil Beacon',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'WorkSansMedium',
              fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
      body: listBeaconResponseModel.data == null
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
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Cari Beacon',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontFamily: 'WorkSansSemiBold',
                            fontSize: 16.0,
                            color: Colors.black),
                        onChanged: (text) {
                          text = text.toLowerCase();
                          setState(() {
                            beaconListSearch =
                                listBeaconResponseModel.data.where((beacon) {
                              var namabeacon = beacon.namadevice.toLowerCase();
                              return namabeacon.contains(text);
                            }).toList();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                        itemCount: beaconListSearch.length,
                        itemBuilder: (context, index) {
                          if (beaconListSearch[index].status == 1 ||
                              beaconListSearch[index].status == null) {
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
                                        new Text(
                                          beaconListSearch[index].namadevice,
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
                                          beaconListSearch[index].uuid,
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
                                          '${beaconListSearch[index].jarakmin} m',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'WorkSansMedium',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox(
                              height: 0,
                            );
                          }
                        }),
                  ),
                ),
              ],
            ),
      //     )
      //   ],
      // ),
    );
  }
}
