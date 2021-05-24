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
      color: Colors.lightBlue,
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
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth dalam keadaan ${state.toString().substring(15)}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  .copyWith(color: Colors.white),
            ),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(19.0)),
              onPressed: _jumpToSetting,
              color: Colors.blue,
              padding: EdgeInsets.all(10.0),
              child: Column(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(
                    Icons.bluetooth_connected_rounded,
                    color: Colors.white,
                  ),
                  Text("Hidupkan", style: TextStyle(color: Colors.white))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

_jumpToSetting() {
  SystemSetting.goto(SettingTarget.BLUETOOTH);
}
