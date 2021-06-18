class JadwalMahasiswaModel {
  final String error;
  final Data data;

  JadwalMahasiswaModel({this.error, this.data});

  factory JadwalMahasiswaModel.fromJson(Map<String, dynamic> json) =>
      JadwalMahasiswaModel(
        error: json["error"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "data": data,
      };
}

class Data {
  Data(
    this.kodemk,
    this.namamk,
    this.kelas,
    this.sks,
    this.namadosen,
    this.hari,
    this.sesi,
    this.semester,
    this.ruang,
  );

  final String kodemk;
  final String namamk;
  final String kelas;
  final String sks;
  final String namadosen;
  final String hari;
  final String sesi;
  final String semester;
  final String ruang;
}
