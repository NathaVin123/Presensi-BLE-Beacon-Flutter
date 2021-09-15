import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Beacon/UbahBeaconModel.dart';
import 'package:presensiblebeacon/UTILS/LoginProgressHUD.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDetailUbahBeacon extends StatefulWidget {
  AdminDetailUbahBeacon({Key key}) : super(key: key);

  @override
  _AdminDetailUbahBeaconState createState() =>
      _AdminDetailUbahBeaconState();
}

class _AdminDetailUbahBeaconState extends State<AdminDetailUbahBeacon> {
  // var _namaDeviceFieldController = new TextEditingController();
  // var _jarakMinFieldController = new TextEditingController();

  final FocusNode _namaDeviceFieldFocus = FocusNode();
  final FocusNode _jarakMinFieldFocus = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isApiCallProcess = false;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  UbahBeaconRequestModel ubahBeaconRequestModel;

  String uuid = "";
  String namadevice = "";
  double jarakmin = 0;

  @override
  void initState() {
    super.initState();
    getDataUbahBeacon();
    ubahBeaconRequestModel = new UbahBeaconRequestModel();
  }

  getDataUbahBeacon() async {
    SharedPreferences ubahBeacon = await SharedPreferences.getInstance();
    setState(() {
      uuid = ubahBeacon.getString('uuid');
      namadevice = ubahBeacon.getString('namadevice');
      jarakmin = ubahBeacon.getDouble('jarakmin');
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginProgressHUD(
      child: buildUbahBeacon(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0,
    );
  }

  Widget buildUbahBeacon(BuildContext context) {
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
                'Ubah Beacon',
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
                                'UUID',
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
                                child: TextFormField(
                              controller: TextEditingController(text: uuid),
                              enabled: false,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.grey),
                              decoration: new InputDecoration(hintText: uuid),
                              onSaved: (input) =>
                                  ubahBeaconRequestModel.uuid = input,
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Nama Perangkat',
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
                                child: TextFormField(
                              controller:
                                  TextEditingController(text: namadevice),
                              // controller: _namaDeviceFieldController,
                              focusNode: _namaDeviceFieldFocus,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(context,
                                    _namaDeviceFieldFocus, _jarakMinFieldFocus);
                              },
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              keyboardType: TextInputType.text,
                              onSaved: (input) =>
                                  ubahBeaconRequestModel.namadevice = input,
                              validator: (input) => input.length < 10
                                  ? " minimal 10 karakter"
                                  : null,
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Jarak Minimal',
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
                                child: TextFormField(
                              controller: TextEditingController(
                                  text: jarakmin.toString()),
                              // controller: _jarakMinFieldController,
                              focusNode: _jarakMinFieldFocus,
                              onFieldSubmitted: (value) {
                                _jarakMinFieldFocus.unfocus();
                              },
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              keyboardType: TextInputType.number,
                              onSaved: (input) =>
                                  ubahBeaconRequestModel.jarakmin = input,
                              validator: (input) =>
                                  input.length < 1 ? " minimal 1 digit" : null,
                              decoration:
                                  new InputDecoration(hintText: "Meter"),
                            )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
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
                                  if (validateAndSave()) {
                                    print(ubahBeaconRequestModel.toJson());

                                    setState(() {
                                      isApiCallProcess = true;
                                    });

                                    APIService apiService = new APIService();

                                    apiService
                                        .putUbahBeacon(ubahBeaconRequestModel)
                                        .then((value) async {
                                      if (value != null) {
                                        setState(() {
                                          isApiCallProcess = false;
                                        });
                                      }
                                      Get.back();

                                      await Fluttertoast.showToast(
                                          msg: 'Berhasil Mengubah Beacon',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                    });
                                  }
                                } catch (error) {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Terjadi kesalahan, silahkan coba lagi',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 14.0);
                                }
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

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
