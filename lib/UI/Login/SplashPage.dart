import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () => navigateUser());
  }

  void navigateUser() async {
    SharedPreferences autoLogin = await SharedPreferences.getInstance();

    var statusMahasiswa = autoLogin.getBool('isLoggedMahasiswa') ?? false;
    var statusDosen = autoLogin.getBool('isLoggedDosen') ?? false;

    print(statusMahasiswa);
    print(statusDosen);

    if (statusMahasiswa) {
      return Get.offNamed('/mahasiswa/dashboard');
    } else if (statusDosen) {
      return Get.offNamed('/dosen/dashboard');
    } else {
      return Get.offNamed('/bluetooth');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      // backgroundColor: Color.fromRGBO(49, 119, 212, 100),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(color: Color.fromRGBO(23, 75, 137, 1)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('SplashPage_LogoAtmaJaya'.png, height: 150.0),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text('Universitas Atma Jaya Yogyakarta',
                    style: const TextStyle(
                        fontFamily: 'WorkSansSemiBold',
                        fontSize: 22.0,
                        color: Colors.white)),
              ),
              SizedBox(
                height: 100,
              ),
              CircularProgressIndicator(
                  backgroundColor: Color.fromRGBO(23, 75, 137, 1),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              SizedBox(
                height: 150,
              ),
              Text('Version 1.0',
                  style: const TextStyle(
                      fontFamily: 'WorkSansSemiBold',
                      fontSize: 18.0,
                      color: Colors.white))
            ],
          )
        ],
      ),
    );
  }
}
