import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/UTILS/LoginProgressHUD.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDetailHapusBeacon extends StatefulWidget {
  AdminDetailHapusBeacon({Key key}) : super(key: key);

  @override
  _AdminDetailHapusBeaconState createState() => _AdminDetailHapusBeaconState();
}

class _AdminDetailHapusBeaconState extends State<AdminDetailHapusBeacon> {
  String uuid = "";
  String namadevice = "";

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isApiCallProcess = false;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    getDataHapusBeacon();
  }

  void getDataHapusBeacon() async {
    SharedPreferences adminHapusBeacon = await SharedPreferences.getInstance();
    setState(() {
      uuid = adminHapusBeacon.getString('uuid');
      namadevice = adminHapusBeacon.getString('namadevice');
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginProgressHUD(
      child: buildHapusBeacon(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0,
    );
  }

  Widget buildHapusBeacon(BuildContext context) {
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
                  'Hapus Beacon',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'WorkSansMedium',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: globalFormKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'UUID : \n$uuid',
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
                                child: Text(
                                  'Nama Perangkat : \n$namadevice',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'WorkSansMedium',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                                color: Colors.red,
                                shape: StadiumBorder(),
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Hapus",
                                  style: const TextStyle(
                                      fontFamily: 'WorkSansSemiBold',
                                      fontSize: 18.0,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  Get.back();

                                  Fluttertoast.showToast(
                                      msg: 'Berhasil Menghapus Beacon',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 14.0);

                                  // try {
                                  //   if (validateAndSave()) {
                                  //     print(tambahBeaconRequestModel.toJson());

                                  //     setState(() {
                                  //       isApiCallProcess = true;
                                  //     });

                                  //     APIService apiService = new APIService();
                                  //     apiService
                                  //         .postTambahBeacon(
                                  //             tambahBeaconRequestModel)
                                  //         .then((value) async {
                                  //       if (value != null) {
                                  //         setState(() {
                                  //           isApiCallProcess = false;
                                  //         });

                                  //         Get.back();

                                  //         Fluttertoast.showToast(
                                  //             msg:
                                  //                 'Berhasil Menambahkan Beacon',
                                  //             toastLength: Toast.LENGTH_SHORT,
                                  //             gravity: ToastGravity.BOTTOM,
                                  //             timeInSecForIosWeb: 1,
                                  //             backgroundColor: Colors.green,
                                  //             textColor: Colors.white,
                                  //             fontSize: 14.0);
                                  //       }
                                  //     });
                                  //   }
                                  // } catch (error) {
                                  //   Fluttertoast.showToast(
                                  //       msg:
                                  //           'Terjadi kesalahan, silahkan coba lagi',
                                  //       toastLength: Toast.LENGTH_SHORT,
                                  //       gravity: ToastGravity.BOTTOM,
                                  //       timeInSecForIosWeb: 1,
                                  //       backgroundColor: Colors.red,
                                  //       textColor: Colors.white,
                                  //       fontSize: 14.0);
                                  // }
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ))
          ],
        ));
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // _fieldFocusChange(
  //     BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  //   currentFocus.unfocus();
  //   FocusScope.of(context).requestFocus(nextFocus);
  // }
}
