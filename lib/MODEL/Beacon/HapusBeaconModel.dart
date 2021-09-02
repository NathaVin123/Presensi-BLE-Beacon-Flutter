class HapusBeaconRequestModel {
  String uuid;

  HapusBeaconRequestModel({this.uuid});

  factory HapusBeaconRequestModel.fromJson(Map<String, dynamic> json) =>
      HapusBeaconRequestModel(
        uuid: json["UUID"] as String,
      );

  Map<String, dynamic> toJson() => {"UUID": uuid};
}
