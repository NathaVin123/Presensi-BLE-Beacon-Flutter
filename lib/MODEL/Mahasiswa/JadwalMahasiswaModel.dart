import 'dart:convert';

JadwalMahasiswaResponseModel responseModelFromJson(String str) =>
    JadwalMahasiswaResponseModel.fromJson(json.decode(str));

String responseModelToJson(JadwalMahasiswaResponseModel data) =>
    json.encode(data.toJson());

class JadwalMahasiswaResponseModel {
  final String error;
  List<Data> data;

  JadwalMahasiswaResponseModel({this.error, this.data});

  factory JadwalMahasiswaResponseModel.fromJson(Map<String, dynamic> json) =>
      JadwalMahasiswaResponseModel(
        error: json["error"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "error": error,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

// Data dataFromJson(String str) => Data.fromJson(json.decode(str));
// String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  final String kodemk;
  final String namamk;
  final String kelas;
  // final int sks;
  final String namadosen;
  final String hari;
  final String sesi;
  // final int semester;
  final String ruang;

  Data({
    this.kodemk,
    this.namamk,
    this.kelas,
    // this.sks,
    this.namadosen,
    this.hari,
    this.sesi,
    // this.semester,
    this.ruang,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        kodemk: json["KODE_MK"] as String,
        namamk: json["NAMA_MK"] as String,
        kelas: json["KELAS"] as String,
        // sks: json["SKS"] as int,
        namadosen: json["NAMA_DOSEN_LENGKAP"] as String,
        hari: json["HARI"] as String,
        sesi: json["SESI"] as String,
        // semester: json["SEMESTER"] as int,
        ruang: json["RUANG1"] as String,
      );

  Map<String, dynamic> toJson() => {
        "KODE_MK": kodemk,
        "NAMA_MK": namamk,
        "KELAS": kelas,
        // "SKS": sks,
        "NAMA_DOSEN_LENGKAP": namadosen,
        "HARI": hari,
        "SESI": sesi,
        // "SEMESTER": semester,
        "RUANG1": ruang
      };
}

class JadwalMahasiswaRequestModel {
  String npm;
  String semester;

  JadwalMahasiswaRequestModel({this.npm, this.semester});

  factory JadwalMahasiswaRequestModel.fromJson(Map<String, dynamic> json) =>
      JadwalMahasiswaRequestModel(
        npm: json["NPM"] as String,
        semester: json["SEMESTER"] as String,
      );

  Map<String, dynamic> toJson() => {
        "NPM": npm,
        "SEMESTER": semester,
      };
}
