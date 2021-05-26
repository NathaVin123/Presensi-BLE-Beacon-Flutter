import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:presensiblebeacon/UI/Login/LoginPage.dart';
import 'package:system_setting/system_setting.dart';

class BluetoothOff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return LoginPage();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Container(
      color: Colors.blue,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.2),
                  offset: Offset(0, 10),
                  blurRadius: 20)
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.bluetooth_disabled,
                  size: 150.0,
                  color: Colors.red,
                ),
                // Text(
                //     'Bluetooth dalam keadaan ${state.toString().substring(15)}.',

                //     style: TextStyle(
                //         fontFamily: 'WorkSansSemiBold',
                //         fontSize: 16.0,
                //         color: Colors.grey)),
                SizedBox(
                  height: 25,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  onPressed: _jumpToSetting,
                  color: Colors.blue,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      // Icon(
                      //   Icons.bluetooth_connected_rounded,
                      //   color: Colors.white,
                      // ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Aktifkan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'WorkSansSemiBold',
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_jumpToSetting() {
  SystemSetting.goto(SettingTarget.BLUETOOTH);
}
