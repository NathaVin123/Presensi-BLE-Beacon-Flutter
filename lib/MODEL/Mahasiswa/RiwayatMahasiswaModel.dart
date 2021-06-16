import 'dart:convert';

RiwayatMahasiswaResponseModel responseModelFromJson(String str) =>
    RiwayatMahasiswaResponseModel.fromJson(json.decode(str));

String responseModelToJson(RiwayatMahasiswaResponseModel data) =>
    json.encode(data.toJson());

class RiwayatMahasiswaResponseModel {
  final String error;
  final Data data;

  RiwayatMahasiswaResponseModel({this.error, this.data});

  factory RiwayatMahasiswaResponseModel.fromJson(Map<String, dynamic> json) =>
      RiwayatMahasiswaResponseModel(
        error: json["error"] == null ? null : json["error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "data": data == null ? null : data.toJson(),
      };
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data(
      {this.npm,
      this.idkelas,
      this.namamk,
      this.pertemuan,
      this.status,
      this.tglin,
      this.tglout,
      this.tglverifikasi});

  final String npm;
  final String idkelas;
  final String namamk;
  final String pertemuan;
  final String status;
  final String tglin;
  final String tglout;
  final String tglverifikasi;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        npm: json["NPM"] == null ? null : json["NPM"],
        idkelas: json["ID_Kelas"] == null ? null : json["ID_Kelas"],
        namamk: json["NAMA_MK"] == null ? null : json["NAMA_MK"],
        pertemuan: json["PERTEMUAN_KE"] == null ? null : json["PERTEMUAN_KE"],
        status: json["STATUS"] == null ? null : json["STATUS"],
        tglin: json["TGL_IN"] == null ? null : json["TGL_IN"],
        tglout: json["TGL_OUT"] == null ? null : json["TGL_OUT"],
        tglverifikasi:
            json["TGL_VERIFIKASI"] == null ? null : json["TGL_VERIFIKASI"],
      );

  Map<String, dynamic> toJson() => {
        "NPM": npm == null ? null : npm,
        "ID_Kelas": idkelas == null ? null : idkelas,
        "NAMA_MK": namamk == null ? null : namamk,
        "PERTEMUAN_KE": pertemuan == null ? null : pertemuan,
        "STATUS": status == null ? null : status,
        "TGL_IN": tglin == null ? null : tglin,
        "TGL_OUT": tglout == null ? null : tglout,
        "TGL_VERIFIKASI": tglverifikasi == null ? null : tglverifikasi,
      };
}

RiwayatMahasiswaRequestModel requestModelFromJson(String str) =>
    RiwayatMahasiswaRequestModel.fromJson(json.decode(str));
String requestModelToJson(RiwayatMahasiswaRequestModel data) =>
    json.encode(data.toJson());

class RiwayatMahasiswaRequestModel {
  String npm;

  RiwayatMahasiswaRequestModel({
    this.npm,
  });

  factory RiwayatMahasiswaRequestModel.fromJson(Map<String, dynamic> json) =>
      RiwayatMahasiswaRequestModel(
        npm: json["NPM"] == null ? null : json["NPM"],
      );

  Map<String, dynamic> toJson() => {
        "NPM": npm == null ? null : npm.trim(),
      };
}
