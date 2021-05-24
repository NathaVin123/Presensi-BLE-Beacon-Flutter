import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Timer(Duration(seconds: 3), () => Get.off(() => BluetoothOff()));
    Timer(Duration(seconds: 3), () => Get.offNamed('/bluetooth'));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Color.fromRGBO(49, 119, 212, 100),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                // color: Color.fromRGBO(49, 119, 212, 100),
                color: Colors.blue),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text('Sistem Presensi UAJY',
                    style: const TextStyle(
                        fontFamily: 'WorkSansSemiBold',
                        fontSize: 25.0,
                        color: Colors.white)),
              ),
              SizedBox(
                height: 50,
              ),
              Image.asset('SplashPage_LogoAtmaJaya'.png, height: 125.0),
              SizedBox(
                height: 100,
              ),
              CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              SizedBox(
                height: 150,
              ),
              Text('Ver 0.0',
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
