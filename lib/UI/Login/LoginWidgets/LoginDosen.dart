import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/LoginDosenModel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginDosen extends StatefulWidget {
  const LoginDosen({Key key}) : super(key: key);

  @override
  _LoginDosenState createState() => _LoginDosenState();
}

class _LoginDosenState extends State<LoginDosen> {
  int _state = 0;
  var _nppFieldController = TextEditingController();
  var _passwordFieldController = TextEditingController();
  final FocusNode _nppFieldFocus = FocusNode();
  final FocusNode _passwordFieldFocus = FocusNode();
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  LoginDosenRequestModel loginDosenRequestModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    loginDosenRequestModel = new LoginDosenRequestModel();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return LoginProgressHUD(
  //     child: _uiSetup(context),
  //     inAsyncCall: isApiCallProcess,
  //     opacity: 0.5,
  //   );
  // }

  Widget build(BuildContext context) {
    return Container(
      key: scaffoldKey,

      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).hintColor.withOpacity(0.2),
                    offset: Offset(0, 10),
                    blurRadius: 20)
              ],
            ),
            child: Form(
              key: globalFormKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _nppFieldController,
                      focusNode: _nppFieldFocus,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(
                            context, _nppFieldFocus, _passwordFieldFocus);
                      },
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(
                          fontFamily: 'WorkSansSemiBold',
                          fontSize: 18.0,
                          color: Colors.black),
                      keyboardType: TextInputType.number,
                      onSaved: (input) => loginDosenRequestModel.npp = input,
                      validator: (input) =>
                          input.length < 8 ? "NPP minimal 9 karakter" : null,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        hintText: "NPP",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        prefixIcon: Icon(
                          Icons.person_rounded,
                          color: Colors.black,
                          size: 22.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 10, right: 10),
                    child: TextFormField(
                      controller: _passwordFieldController,
                      focusNode: _passwordFieldFocus,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {
                        _passwordFieldFocus.unfocus();
                      },
                      style: const TextStyle(
                          fontFamily: 'WorkSansSemiBold',
                          fontSize: 18.0,
                          color: Colors.black),
                      keyboardType: TextInputType.text,
                      onSaved: (input) =>
                          loginDosenRequestModel.password = input,
                      validator: (input) => input.length < 5
                          ? "PASSWORD minimal 5 karakter"
                          : null,
                      obscureText: hidePassword,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        hintText: "PASSWORD",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          color: Colors.black,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          color: Colors.black,
                          icon: Icon(hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Center(
                  //     child: CheckboxListTile(
                  //   title: Text("Ingat Saya",
                  //       style: const TextStyle(
                  //           fontFamily: 'WorkSansSemiBold',
                  //           fontSize: 14.0,
                  //           color: Colors.black)),
                  //   value: timeDilation != 0.5,
                  //   onChanged: (bool value) {
                  //     setState(() {
                  //       timeDilation = value ? 2.0 : 0.5;
                  //     });
                  //   },
                  //   activeColor: Colors.white,
                  //   checkColor: Colors.blue,
                  //   controlAffinity: ListTileControlAffinity.leading,
                  // )),
                  MaterialButton(
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    onPressed: () {
                      setState(() {
                        if (_state == 0) {
                          animateButton();
                        }
                      });
                      try {
                        if (validateAndSave()) {
                          print(loginDosenRequestModel.toJson());

                          setState(() {
                            isApiCallProcess = true;
                          });

                          APIService apiService = new APIService();
                          apiService
                              .loginDosen(loginDosenRequestModel)
                              .then((value) async {
                            if (value != null) {
                              setState(() {
                                isApiCallProcess = false;
                              });

                              if (value?.data?.token?.isNotEmpty ?? false) {
                                // Get.to(() => DosenDashboardPage());
                                Get.offNamed('/dosen/dashboard');

                                // Get.snackbar('Berhasil Login',
                                //     'Selamat Datang ${value.data.namadsn}',
                                //     snackPosition: SnackPosition.TOP,
                                //     colorText: Colors.white,
                                //     backgroundColor: Colors.blue);
                                Fluttertoast.showToast(
                                    msg: 'Selamat datang ${value.data.namadsn}',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 14.0);

                                SharedPreferences loginMahasiswa =
                                    await SharedPreferences.getInstance();
                                await loginMahasiswa.setString(
                                    'npm', value.data.npp);
                                await loginMahasiswa.setString(
                                    'namamhs', value.data.namadsn);
                              } else {
                                // Get.snackbar('Gagal Login',
                                //     'Silahkan masukan NPP dan Password yang terdaftar',
                                //     snackPosition: SnackPosition.BOTTOM,
                                //     colorText: Colors.white,
                                //     backgroundColor: Colors.red);
                                Fluttertoast.showToast(
                                    // msg: '${value.error}',
                                    msg:
                                        'Silahkan Masukan NPP/Password dengan benar',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              }
                            }
                          });
                        }
                      } catch (error) {}
                    },
                    // child: Text(
                    //   "MASUK",
                    //   style: const TextStyle(
                    //       fontFamily: 'WorkSansSemiBold',
                    //       fontSize: 18.0,
                    //       color: Colors.white),
                    // ),
                    child: setUpButtonChild(),
                    color: Colors.blue,
                    shape: StadiumBorder(),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
      // ),
    );
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "MASUK",
        style: const TextStyle(
            fontFamily: 'WorkSansSemiBold',
            fontSize: 18.0,
            color: Colors.white),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return new Text(
        "MASUK",
        style: const TextStyle(
            fontFamily: 'WorkSansSemiBold',
            fontSize: 18.0,
            color: Colors.white),
      );
    }
    //  else {
    //   return Icon(Icons.cancel_rounded, color: Colors.red);
    // }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        _state = 2;
      });
    });
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
