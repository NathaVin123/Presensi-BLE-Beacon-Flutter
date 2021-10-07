import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/UTILS/LoginProgressHUD.dart';

class DosenGantiPasswordPage extends StatefulWidget {
  @override
  _DosenGantiPasswordPageState createState() => _DosenGantiPasswordPageState();
}

class _DosenGantiPasswordPageState extends State<DosenGantiPasswordPage> {
  var _passwordFieldController = TextEditingController();

  final FocusNode _passwordFieldFocus = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isApiCallProcess = false;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoginProgressHUD(
      child: buildGantiPassword(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0,
    );
  }

  @override
  Widget buildGantiPassword(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          centerTitle: true,
          title: Text(
            'Ubah Password Dosen',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'WorkSansMedium',
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 50, bottom: 50, left: 10, right: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: globalFormKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Password Baru',
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
                              controller: _passwordFieldController,
                              focusNode: _passwordFieldFocus,
                              // onFieldSubmitted: (term) {
                              //   _fieldFocusChange(context, _uuidFieldFocus,
                              //       _namaDeviceFieldFocus);
                              // },
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              keyboardType: TextInputType.text,
                              // onSaved: (input) =>
                              //     tambahBeaconRequestModel.uuid = input,
                              validator: (input) => input.length < 1
                                  ? "UUID minimal 1 karakter"
                                  : null,
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
                                    // print(tambahBeaconRequestModel.toJson());

                                    setState(() {
                                      isApiCallProcess = true;
                                    });

                                    APIService apiService = new APIService();
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
          ),
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

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
