import 'dart:convert';

ListBeaconResponseModel responseModelFromJson(String str) =>
    ListBeaconResponseModel.fromJson(json.decode(str));

String responseModelToJson(ListBeaconResponseModel data) =>
    json.encode(data.toJson());

class ListBeaconResponseModel {
  final String error;
  List<Data> data;

  ListBeaconResponseModel({this.error, this.data});

  factory ListBeaconResponseModel.fromJson(Map<String, dynamic> json) =>
      ListBeaconResponseModel(
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
  final String uuid;
  final String namadevice;
  final double jarakmin;

  Data({
    this.uuid,
    this.namadevice,
    this.jarakmin,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        uuid: json["PROXIMITY_UUID"],
        namadevice: json["NAMA_DEVICE"],
        jarakmin: ((json["JARAK_MIN_DEC"] as num ) ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "PROXIMITY_UUID": uuid,
        "NAMA_DEVICE": namadevice,
        "JARAK_MIN_DEC": jarakmin,
      };
}
