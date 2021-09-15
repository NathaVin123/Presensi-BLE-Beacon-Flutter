import 'dart:convert';

ListRuanganResponseModel responseModelFromJson(String str) =>
    ListRuanganResponseModel.fromJson(json.decode(str));

String responseModelToJson(ListRuanganResponseModel data) =>
    json.encode(data.toJson());

class ListRuanganResponseModel {
  final String error;
  List<Data> data;

  ListRuanganResponseModel({this.error, this.data});

  factory ListRuanganResponseModel.fromJson(Map<String, dynamic> json) =>
      ListRuanganResponseModel(
        error: json["error"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
        // data: json["data"]
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        // "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "data": data == null
      };
}

class Data {
  final String ruang;
  final String fakultas;
  final String prodi;

  Data({this.ruang, this.fakultas, this.prodi});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ruang: json["RUANG"],
        fakultas: json["FAKULTAS"],
        prodi: json["PRODI"],
      );

  Map<String, dynamic> toJson() => {
        "RUANG": ruang,
        "FAKULTAS": fakultas,
        "PRODI": prodi,
      };
}
