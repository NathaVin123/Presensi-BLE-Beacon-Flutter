import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Beacon/ListBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/UbahRuangBeaconModel.dart';
import 'package:presensiblebeacon/UTILS/LoginProgressHUD.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDetailRuanganPage extends StatefulWidget {
  AdminDetailRuanganPage({Key key}) : super(key: key);

  @override
  _AdminDetailRuanganPageState createState() => _AdminDetailRuanganPageState();
}

class _AdminDetailRuanganPageState extends State<AdminDetailRuanganPage> {
  bool isApiCallProcess = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  String ruang = "";
  String fakultas = "";
  String prodi = "";
  String namadevice = "";

  String selectedNamaDevice = "";

  int selectedKolomDevice;

  UbahRuangBeaconRequestModel ubahRuangBeaconRequestModel;

  ListBeaconResponseModel listBeaconResponseModel;

  @override
  void initState() {
    super.initState();

    ubahRuangBeaconRequestModel = UbahRuangBeaconRequestModel();

    listBeaconResponseModel = ListBeaconResponseModel();

    getRuang();
    getFakultas();
    getProdi();
    getDevice();

    getListBeacon();
  }

  Future<void> getRuang() async {
    SharedPreferences saveRuang = await SharedPreferences.getInstance();
    setState(() {
      ruang = saveRuang.getString('ruang');
    });
  }

  Future<void> getFakultas() async {
    SharedPreferences saveFakultas = await SharedPreferences.getInstance();
    setState(() {
      fakultas = saveFakultas.getString('fakultas');
    });
  }

  Future<void> getProdi() async {
    SharedPreferences saveProdi = await SharedPreferences.getInstance();
    setState(() {
      prodi = saveProdi.getString('prodi');
    });
  }

  Future<void> getDevice() async {
    SharedPreferences saveDevice = await SharedPreferences.getInstance();
    setState(() {
      namadevice = saveDevice.getString('namadevice');
    });
  }

  Future<void> getListBeacon() async {
    setState(() {
      APIService apiService = new APIService();
      apiService.getListBeacon().then((value) async {
        listBeaconResponseModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginProgressHUD(
      child: buildUbahIDBeacon(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0,
    );
  }

  Future<bool> _onBackPressed() async {
    SharedPreferences saveRuangan = await SharedPreferences.getInstance();
    await saveRuangan.setString('ruang', "");
    SharedPreferences saveFakultas = await SharedPreferences.getInstance();
    await saveFakultas.setString('fakultas', "");
    SharedPreferences saveProdi = await SharedPreferences.getInstance();
    await saveProdi.setString('prodi', "");
    SharedPreferences saveDevice = await SharedPreferences.getInstance();
    await saveDevice.setString('namadevice', "");

    Get.back();
  }

  Widget buildUbahIDBeacon(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          centerTitle: true,
          title: Text(
            'Ubah Perangkat Ruang',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'WorkSansMedium',
                fontWeight: FontWeight.bold),
          ),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   // onPressed: () => {_streamRanging?.resume(), getDataRuangBeacon()},
        //   onPressed: () => getListBeacon(),
        //   label: Text(
        //     'Segarkan',
        //     style: TextStyle(
        //         fontWeight: FontWeight.bold, fontFamily: 'WorkSansMedium'),
        //   ),
        //   icon: Icon(Icons.search_rounded),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
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
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Ruang : ${ruang ?? "-"}',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'WorkSansMedium',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Fakultas : ${fakultas ?? "-"}',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'WorkSansMedium',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Program Studi : ${prodi ?? "-"}',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'WorkSansMedium',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Nama Device : ${namadevice ?? "-"}',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'WorkSansMedium',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Pilih Perangkat',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'WorkSansMedium',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 25, top: 10, bottom: 5),
              child: Align(
                alignment: Alignment.topLeft,
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
                    child: Scrollbar(
                      child: ListView.builder(
                          itemCount: listBeaconResponseModel.data?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 8, bottom: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: selectedKolomDevice == index
                                        ? Colors.yellow
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(25)),
                                child: new ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          '${listBeaconResponseModel.data[index].jarakmin} m',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'WorkSansMedium',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedKolomDevice = index;
                                    });

                                    selectedNamaDevice = listBeaconResponseModel
                                        .data[index].namadevice;

                                    print(selectedNamaDevice);
                                  },
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MaterialButton(
                      color: Color.fromRGBO(247, 180, 7, 1),
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Ubah",
                        style: const TextStyle(
                            fontFamily: 'WorkSansSemiBold',
                            fontSize: 18.0,
                            color: Colors.white),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        try {
                          print(ubahRuangBeaconRequestModel.toJson());

                          print(ruang);
                          print(selectedNamaDevice);

                          setState(() {
                            isApiCallProcess = true;

                            ubahRuangBeaconRequestModel.ruang = ruang;

                            ubahRuangBeaconRequestModel.namadevice =
                                selectedNamaDevice;
                          });

                          APIService apiService = new APIService();

                          apiService
                              .putUbahRuangBeacon(ubahRuangBeaconRequestModel)
                              .then((value) async {
                            if (value != null) {
                              setState(() {
                                isApiCallProcess = false;
                              });
                            }
                            Get.back();

                            await Fluttertoast.showToast(
                                msg:
                                    'Berhasil Mengubah Perangkat Beacon di Ruangan',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 14.0);
                          });
                        } catch (error) {
                          Fluttertoast.showToast(
                              msg: 'Terjadi kesalahan, silahkan coba lagi',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 14.0);
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MaterialButton(
                      color: Colors.blue,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Segarkan",
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 18.0,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () => getListBeacon()),
                ),
              ],
            ),
          ],
        ),
        //     )
        //   ],
        // ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
