import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Beacon/TambahBeaconModel.dart';
import 'package:presensiblebeacon/UTILS/LoginProgressHUD.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DosenTambahBeacon extends StatefulWidget {
  @override
  _DosenTambahBeaconState createState() => _DosenTambahBeaconState();
}

class _DosenTambahBeaconState extends State<DosenTambahBeacon> {
  var _uuidFieldController = TextEditingController();
  var _namaDeviceFieldController = TextEditingController();
  var _jarakMinFieldController = TextEditingController();

  final FocusNode _uuidFieldFocus = FocusNode();
  final FocusNode _namaDeviceFieldFocus = FocusNode();
  final FocusNode _jarakMinFieldFocus = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isApiCallProcess = false;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  TambahBeaconRequestModel tambahBeaconRequestModel;

  @override
  void initState() {
    super.initState();
    tambahBeaconRequestModel = new TambahBeaconRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return LoginProgressHUD(
      child: buildTambahBeacon(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0,
    );
  }

  Widget buildTambahBeacon(BuildContext context) {
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
                'Tambah Beacon',
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
                              controller: _uuidFieldController,
                              focusNode: _uuidFieldFocus,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(context, _uuidFieldFocus,
                                    _namaDeviceFieldFocus);
                              },
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              keyboardType: TextInputType.text,
                              onSaved: (input) =>
                                  tambahBeaconRequestModel.uuid = input,
                              validator: (input) => input.length < 1
                                  ? "Tidak boleh kosong"
                                  : null,
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
                              controller: _namaDeviceFieldController,
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
                                  tambahBeaconRequestModel.namadevice = input,
                              validator: (input) => input.length < 1
                                  ? "Tidak boleh kosong"
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
                              controller: _jarakMinFieldController,
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
                                  tambahBeaconRequestModel.jarakmin = input,
                              validator: (input) => input.length < 1
                                  ? "Tidak boleh kosong"
                                  : null,
                              decoration:
                                  new InputDecoration(hintText: "Dalam Meter"),
                            )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                              color: Colors.blue,
                              shape: StadiumBorder(),
                              padding: EdgeInsets.all(15),
                              child: Text(
                                "Pindai Beacon",
                                style: const TextStyle(
                                    fontFamily: 'WorkSansSemiBold',
                                    fontSize: 18.0,
                                    color: Colors.white),
                              ),
                              onPressed: () =>
                                  Get.toNamed('/admin/menu/beacon/pindai')),
                          SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                              color: Color.fromRGBO(247, 180, 7, 1),
                              shape: StadiumBorder(),
                              padding: EdgeInsets.all(15),
                              child: Text(
                                "SIMPAN",
                                style: const TextStyle(
                                    fontFamily: 'WorkSansSemiBold',
                                    fontSize: 18.0,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                try {
                                  if (validateAndSave()) {
                                    print(tambahBeaconRequestModel.toJson());

                                    setState(() {
                                      isApiCallProcess = true;
                                    });

                                    APIService apiService = new APIService();
                                    apiService
                                        .postTambahBeacon(
                                            tambahBeaconRequestModel)
                                        .then((value) async {
                                      if (value != null) {
                                        setState(() {
                                          isApiCallProcess = false;
                                        });
                                      }
                                      Get.back();

                                      await Fluttertoast.showToast(
                                          msg: 'Berhasil Menambahkan Beacon',
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