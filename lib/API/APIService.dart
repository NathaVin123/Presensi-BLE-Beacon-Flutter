import 'package:http/http.dart' as http;
import 'dart:convert';
import '../MODEL/LoginMahasiswaModel.dart';
import '../MODEL/LoginDosenModel.dart';

class APIService {
  Future<LoginMahasiswaResponseModel> loginMahasiswa(
      LoginMahasiswaRequestModel requestModel) async {
    // String url = "https://192.168.100.2:5000/api/auth/loginmhs";
    String url = "https://192.168.100.131:5000/api/auth/loginmhs";
    // String url = "https://10.54.7.241:5000/api/auth/loginmhs";
    // String url = "https://192.168.43.229:5000/api/auth/loginmhs/";
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

  Future<LoginDosenResponseModel> loginDosen(
      LoginDosenRequestModel requestModel) async {
    // String url = "https://192.168.100.2:5000/api/auth/logindsn";
    String url = "https://192.168.100.131:5000/api/auth/logindsn";
    // String url = "https://10.54.7.241:5000/api/auth/logindsn";
    // String url = "https://192.168.43.229:5000/api/auth/loginmhs/";
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
}
