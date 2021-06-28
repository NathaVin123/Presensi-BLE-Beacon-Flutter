import 'dart:convert';

RiwayatMahasiswaResponseModel responseModelFromJson(String str) =>
    RiwayatMahasiswaResponseModel.fromJson(json.decode(str));

String responseModelToJson(RiwayatMahasiswaResponseModel data) =>
    json.encode(data.toJson());

class RiwayatMahasiswaResponseModel {
  final String error;
  List<Data> data;

  RiwayatMahasiswaResponseModel({this.error, this.data});

  factory RiwayatMahasiswaResponseModel.fromJson(Map<String, dynamic> json) =>
      RiwayatMahasiswaResponseModel(
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
  // final int idkelas;
  final String namamk;
  final String kelas;
  // final String pertemuan;
  final String status;
  // final String tglin;
  // final String tglout;
  final String tglverifikasi;
  // final int semester;

  Data({
    // this.idkelas,
    this.namamk,
    this.kelas,
    // this.pertemuan,
    this.status,
    // this.tglin,
    // this.tglout,
    this.tglverifikasi,
    // this.semester
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        // idkelas: json["ID_Kelas"],
        namamk: json["NAMA_MK"],
        kelas: json["KELAS"],
        // pertemuan: json["PERTEMUAN_KE"],
        status: json["STATUS"],
        // tglin: json["TGL_IN"],
        // tglout: json["TGL_OUT"],
        tglverifikasi: json["TGL_VERIFIKASI"],
        // semester: json["SEMESTER"],
      );

  Map<String, dynamic> toJson() => {
        // "ID_Kelas": idkelas,
        "NAMA_MK": namamk,
        "KELAS": kelas,
        // "PERTEMUAN_KE": pertemuan,
        "STATUS": status,
        // "TGL_IN": tglin,
        // "TGL_OUT": tglout,
        "TGL_VERIFIKASI": tglverifikasi,
        // "SEMESTER": semester,
      };
}

class RiwayatMahasiswaRequestModel {
  String npm;
  String semester;

  RiwayatMahasiswaRequestModel({this.npm, this.semester});

  factory RiwayatMahasiswaRequestModel.fromJson(Map<String, dynamic> json) =>
      RiwayatMahasiswaRequestModel(
        npm: json["NPM"] as String,
        semester: json["SEMESTER"] as String,
      );

  Map<String, dynamic> toJson() => {
        "NPM": npm,
        "SEMESTER": semester,
      };
}
