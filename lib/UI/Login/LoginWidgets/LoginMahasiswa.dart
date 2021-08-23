import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Login/LoginMahasiswaModel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensiblebeacon/UTILS/LoginProgressHUD.dart';

class LoginMahasiswa extends StatefulWidget {
  const LoginMahasiswa({Key key}) : super(key: key);

  @override
  _LoginMahasiswaState createState() => _LoginMahasiswaState();
}

class _LoginMahasiswaState extends State<LoginMahasiswa> {
  var _npmFieldController = TextEditingController();
  var _passwordFieldController = TextEditingController();

  final FocusNode _npmFieldFocus = FocusNode();
  final FocusNode _passwordFieldFocus = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool hidePassword = true;
  bool isApiCallProcess = false;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  LoginMahasiswaRequestModel loginMahasiswaRequestModel;

  @override
  void initState() {
    super.initState();
    loginMahasiswaRequestModel = new LoginMahasiswaRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return LoginProgressHUD(
      child: buildLoginMahasiswa(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0,
    );
  }

  Widget buildLoginMahasiswa(BuildContext context) {
    return Container(
      key: scaffoldKey,
      child: SingleChildScrollView(
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
                        controller: _npmFieldController,
                        focusNode: _npmFieldFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _npmFieldFocus, _passwordFieldFocus);
                        },
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                            fontFamily: 'WorkSansSemiBold',
                            fontSize: 18.0,
                            color: Colors.black),
                        keyboardType: TextInputType.number,
                        onSaved: (input) =>
                            loginMahasiswaRequestModel.npm = input,
                        validator: (input) =>
                            input.length < 8 ? "NPM minimal 9 karakter" : null,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          hintText: "NPM MAHASISWA",
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
                      padding: const EdgeInsets.only(left: 10, right: 10),
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
                            loginMahasiswaRequestModel.password = input,
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
                    MaterialButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 130),
                      child: Text(
                        "MASUK",
                        style: const TextStyle(
                            fontFamily: 'WorkSansSemiBold',
                            fontSize: 18.0,
                            color: Colors.white),
                      ),
                      color: Color.fromRGBO(247, 180, 7, 1),
                      shape: StadiumBorder(),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        // try {
                        if (validateAndSave()) {
                          print(loginMahasiswaRequestModel.toJson());

                          setState(() {
                            isApiCallProcess = true;
                          });

                          APIService apiService = new APIService();
                          apiService
                              .loginMahasiswa(loginMahasiswaRequestModel)
                              .then((value) async {
                            if (value != null) {
                              setState(() {
                                isApiCallProcess = false;
                              });

                              if (value?.data?.token?.isNotEmpty ?? false) {
                                Get.offNamed('/mahasiswa/dashboard');

                                Fluttertoast.showToast(
                                    msg:
                                        'Selamat datang,\n${value.data.namamhs}',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 14.0);

                                SharedPreferences loginMahasiswa =
                                    await SharedPreferences.getInstance();
                                await loginMahasiswa.setString(
                                    'npm', value.data.npm);
                                await loginMahasiswa.setString(
                                    'namamhs', value.data.namamhs);
                                await loginMahasiswa.setString(
                                    'alamat', value.data.alamat);
                                await loginMahasiswa.setString(
                                    'fakultas', value.data.fakultas);
                                await loginMahasiswa.setString(
                                    'prodi', value.data.prodi);
                                await loginMahasiswa.setString(
                                    'pembimbingakademik',
                                    value.data.pembimbingakademik);

                                SharedPreferences autoLogin =
                                    await SharedPreferences.getInstance();
                                autoLogin?.setBool("isLoggedMahasiswa", true);

                                print(isApiCallProcess);
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Silahkan Masukan NPM/Password dengan benar',
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
                      },
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: Text(
                'Silahkan login dengan akun siatma.',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'WorkSansMedium'),
              )),
            ),
          ],
        ),
      ),
      // ),
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
