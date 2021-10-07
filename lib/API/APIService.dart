import 'dart:convert';
import 'package:presensiblebeacon/MODEL/Beacon/HapusBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Beacon/ListBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Beacon/RuangBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Beacon/TambahBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Beacon/UbahBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Login/LoginAdminModel.dart';
import 'package:presensiblebeacon/MODEL/Mahasiswa/JadwalMahasiswaModel.dart';
import 'package:presensiblebeacon/MODEL/Mahasiswa/RiwayatMahasiswaModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/ListKelasDosenModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/ListKelasMahasiswa.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINDosenBukaPresensiModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToFBEModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToFHModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToFISIPModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToFTBModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToFTIModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToFTModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToKSIModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINOUTOUTPresensiDosen.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINOUTPresensiDosen.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToFBEModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToFHModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToFISIPModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToFTBModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToFTIModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToFTModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToKSIModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/TampilPesertaKelasModel.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/ListDetailRuanganModel.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/ListDetailRuanganNamaDeviceModel.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/ListRuanganModel.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/UbahRuangBeaconModel.dart';

import '../MODEL/Login/LoginMahasiswaModel.dart';
import '../MODEL/Login/LoginDosenModel.dart';
import 'package:http/http.dart' as http;

class APIService {
  String address = 'https://192.168.100.249:5000/api/';
  // Login Mahasiswa API
  Future<LoginMahasiswaResponseModel> loginMahasiswa(
      LoginMahasiswaRequestModel requestModel) async {
    String url = address + "auth/loginmhs";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return LoginMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return LoginMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  // Login Dosen API
  Future<LoginDosenResponseModel> loginDosen(
      LoginDosenRequestModel requestModel) async {
    String url = address + "auth/logindsn";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return LoginDosenResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return LoginDosenResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<LoginAdminResponseModel> loginAdmin(
      LoginAdminRequestModel requestModel) async {
    String url = address + "auth/loginadm";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return LoginAdminResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return LoginAdminResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  // Post Get Data Jadwal Mahasiswa
  Future<JadwalMahasiswaResponseModel> postJadwalMahasiswa(
      JadwalMahasiswaRequestModel requestModel) async {
    String url = address + "jadwalmhs/postgetall";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return JadwalMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return JadwalMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  // Post Get Data Jadwal Dosen
  Future<RiwayatMahasiswaResponseModel> postRiwayatMahasiswa(
      RiwayatMahasiswaRequestModel requestModel) async {
    String url = address + "riwayatmhs/postgetall/";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return RiwayatMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return RiwayatMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  // Get Jadwal Beacon
  Future<RuangBeaconResponseModel> getKelasBeacon() async {
    String url = address + "ruangbeacon";
    print(url);
    http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return RuangBeaconResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return RuangBeaconResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future postTambahBeacon(TambahBeaconRequestModel requestModel) async {
    String url = address + "ruangbeacon/tambah";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<ListBeaconResponseModel> getListBeacon() async {
    String url = address + "ruangbeacon/tampil";
    print(url);
    http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return ListBeaconResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return ListBeaconResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putUbahBeacon(UbahBeaconRequestModel requestModel) async {
    String url = address + "ruangbeacon/ubah";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future hapusBeacon(HapusBeaconRequestModel requestModel) async {
    String url = address + "ruangbeacon/softhapus";
    print(url);
    http.Response response = await http.put(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return HapusBeaconRequestModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return HapusBeaconRequestModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<ListDetailRuanganNamaDeviceResponseModel> postRuanganNamaDevice(
      ListDetailRuanganNamaDeviceRequestModel requestModel) async {
    String url = address + "ruangbeacon/namadevice";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return ListDetailRuanganNamaDeviceResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return ListDetailRuanganNamaDeviceResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<ListRuanganResponseModel> getListRuangan() async {
    String url = address + "ruangbeacon/tampilruangan";
    print(url);
    http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return ListRuanganResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return ListRuanganResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<ListDetailRuanganResponseModel> getListDetailRuangan() async {
    String url = address + "ruangbeacon/tampildetailruangan";
    print(url);
    http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return ListDetailRuanganResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return ListDetailRuanganResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putUbahRuangBeacon(UbahRuangBeaconRequestModel requestModel) async {
    String url = address + "ruangbeacon/ubahruangbeacon";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<ListKelasDosenResponseModel> postListKelasDosen(
      ListKelasDosenRequestModel requestModel) async {
    String url = address + "presensi/postgetlistkelas";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return ListKelasDosenResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return ListKelasDosenResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<ListKelasMahasiswaResponseModel> postListKelasMahasiswa(
      ListKelasMahasiswaRequestModel requestModel) async {
    String url = address + "presensi/postgetlistkelasmhs";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return ListKelasMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return ListKelasMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putBukaPresensiDosen(
      PresensiINDosenBukaPresensiRequestModel requestModel) async {
    String url = address + "presensi/bukapresensidosen";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putPresensiINDosen(
      PresensiINOUTDosenBukaPresensiRequestModel requestModel) async {
    String url = address + "presensi/putinpresensidosen";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putPresensiOUTDosen(
      PresensiINOUTOUTDosenBukaPresensiRequestModel requestModel) async {
    String url = address + "presensi/putoutpresensidosen";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<TampilPesertaKelasResponseModel> postListPesertaKelas(
      TampilPesertaKelasRequestModel requestModel) async {
    String url = address + "presensi/postgetlistpesertakelas";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return TampilPesertaKelasResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return TampilPesertaKelasResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future postInsertPresensiMhsToKSI(
      PresensiINMahasiswaToKSIRequestModel requestModel) async {
    String url = address + "presensi/postinmhstoksi";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putUpdatePresensiMhsToKSI(
      PresensiOUTMahasiswaToKSIRequestModel requestModel) async {
    String url = address + "presensi/putoutmhstoksi";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future postInsertPresensiMhsToFBE(
      PresensiINMahasiswaToFBERequestModel requestModel) async {
    String url = address + "presensi/postinmhstofbe";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putUpdatePresensiMhsToFBE(
      PresensiOUTMahasiswaToFBERequestModel requestModel) async {
    String url = address + "presensi/putoutmhstofbe";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future postInsertPresensiMhsToFH(
      PresensiINMahasiswaToFHRequestModel requestModel) async {
    String url = address + "presensi/postinmhstofh";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putUpdatePresensiMhsToFH(
      PresensiOUTMahasiswaToFHRequestModel requestModel) async {
    String url = address + "presensi/putoutmhstofh";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future postInsertPresensiMhsToFISIP(
      PresensiINMahasiswaToFISIPRequestModel requestModel) async {
    String url = address + "presensi/postinmhstofisip";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putUpdatePresensiMhsToFISIP(
      PresensiOUTMahasiswaToFISIPRequestModel requestModel) async {
    String url = address + "presensi/putoutmhstofisip";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future postInsertPresensiMhsToFT(
      PresensiINMahasiswaToFTRequestModel requestModel) async {
    String url = address + "presensi/postinmhstoft";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putUpdatePresensiMhsToFT(
      PresensiOUTMahasiswaToFTRequestModel requestModel) async {
    String url = address + "presensi/putoutmhstoft";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future postInsertPresensiMhsToFTB(
      PresensiINMahasiswaToFTBRequestModel requestModel) async {
    String url = address + "presensi/postinmhstoftb";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putUpdatePresensiMhsToFTB(
      PresensiOUTMahasiswaToFTBRequestModel requestModel) async {
    String url = address + "presensi/putoutmhstoftb";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future postInsertPresensiMhsToFTI(
      PresensiINMahasiswaToFTIRequestModel requestModel) async {
    String url = address + "presensi/postinmhstofti";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putUpdatePresensiMhsToFTI(
      PresensiOUTMahasiswaToFTIRequestModel requestModel) async {
    String url = address + "presensi/putoutmhstokfti";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }
}
