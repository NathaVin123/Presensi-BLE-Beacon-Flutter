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

  Data({
    this.ruang,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ruang: json["RUANG"],
      );

  Map<String, dynamic> toJson() => {
        "RUANG": ruang,
      };
}
