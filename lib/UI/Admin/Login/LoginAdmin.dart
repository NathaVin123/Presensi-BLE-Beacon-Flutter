import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/UTILS/LoginProgressHUD.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAdmin extends StatefulWidget {
  @override
  _LoginAdminState createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  var _nppFieldController = TextEditingController();
  var _passwordFieldController = TextEditingController();

  final FocusNode _nppFieldFocus = FocusNode();
  final FocusNode _passwordFieldFocus = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool hidePassword = true;
  bool isApiCallProcess = false;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  // LoginDosenRequestModel loginDosenRequestModel;

  @override
  void initState() {
    super.initState();
    // loginDosenRequestModel = new LoginDosenRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return LoginProgressHUD(
      child: buildLoginAdmin(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0,
    );
  }

  Widget buildLoginAdmin(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ADMIN',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'WorkSansMedium'),
          ),
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          elevation: 0,
        ),
        body: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(23, 75, 137, 1)),
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Image(
                        height: MediaQuery.of(context).size.height > 800
                            ? 150.0
                            : 110,
                        fit: BoxFit.fill,
                        image: const AssetImage(
                            'assets/png/SplashPage_LogoAtmaJaya.png')),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 5),
                  //   child: Center(
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(bottom: 5),
                  //       child: Text('ADMIN',
                  //           style: const TextStyle(
                  //               fontFamily: 'WorkSansMedium',
                  //               fontSize: 30.0,
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.white)),
                  //     ),
                  //   ),
                  // ),
                  Container(
                      key: scaffoldKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context)
                                          .hintColor
                                          .withOpacity(0.2),
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
                                              context,
                                              _nppFieldFocus,
                                              _passwordFieldFocus);
                                        },
                                        textInputAction: TextInputAction.next,
                                        style: const TextStyle(
                                            fontFamily: 'WorkSansSemiBold',
                                            fontSize: 18.0,
                                            color: Colors.black),
                                        keyboardType: TextInputType.number,
                                        // onSaved: (input) => loginDosenRequestModel.npp = input,
                                        validator: (input) => input.length < 8
                                            ? "NPP minimal 9 karakter"
                                            : null,
                                        decoration: new InputDecoration(
                                          contentPadding: EdgeInsets.all(20.0),
                                          hintText: "NPP KARYAWAN",
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
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
                                          left: 10, right: 10),
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
                                        // onSaved: (input) =>
                                        //     loginDosenRequestModel.password = input,
                                        validator: (input) => input.length < 5
                                            ? "PASSWORD minimal 5 karakter"
                                            : null,
                                        obscureText: hidePassword,
                                        decoration: new InputDecoration(
                                          contentPadding: EdgeInsets.all(20.0),
                                          hintText: "PASSWORD",
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
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
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 130),
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
                                        try {
                                          if (validateAndSave()) {
                                            // print(loginDosenRequestModel.toJson());

                                            setState(() {
                                              isApiCallProcess = true;
                                            });

                                            APIService apiService =
                                                new APIService();
                                            // apiService
                                            //     .loginDosen(loginDosenRequestModel)
                                            //     .then((value) async {
                                            //   if (value != null) {
                                            //     setState(() {
                                            //       isApiCallProcess = false;
                                            //     });

                                            //     if (value?.data?.token?.isNotEmpty ?? false) {
                                            //       Get.offNamed('/dosen/dashboard');

                                            //       Fluttertoast.showToast(
                                            //           msg:
                                            //               'Selamat datang,\n${value.data.namadsn}',
                                            //           toastLength: Toast.LENGTH_SHORT,
                                            //           gravity: ToastGravity.BOTTOM,
                                            //           timeInSecForIosWeb: 1,
                                            //           backgroundColor: Colors.green,
                                            //           textColor: Colors.white,
                                            //           fontSize: 14.0);

                                            //       SharedPreferences loginDosen =
                                            //           await SharedPreferences.getInstance();
                                            //       await loginDosen.setString(
                                            //           'npp', value.data.npp);
                                            //       await loginDosen.setString(
                                            //           'namadsn', value.data.namadsn);
                                            //       await loginDosen.setString(
                                            //           'prodi', value.data.prodi);
                                            //       await loginDosen.setString(
                                            //           'fakultas', value.data.fakultas);

                                            //       SharedPreferences autoLogin =
                                            //           await SharedPreferences.getInstance();
                                            //       autoLogin?.setBool("isLoggedDosen", true);
                                            //     } else {
                                            //       Fluttertoast.showToast(
                                            //           msg:
                                            //               'Silahkan Masukan NPP/Password dengan benar',
                                            //           toastLength: Toast.LENGTH_SHORT,
                                            //           gravity: ToastGravity.BOTTOM,
                                            //           timeInSecForIosWeb: 1,
                                            //           backgroundColor: Colors.red,
                                            //           textColor: Colors.white,
                                            //           fontSize: 14.0);
                                            //     }
                                            //   }
                                            // }
                                            // );
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
                                'Silahkan login dengan akun simka.',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'WorkSansMedium'),
                              )),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            )));
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
