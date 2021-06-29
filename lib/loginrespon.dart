// To parse this JSON data, do
//
//     final loginrespon = loginresponFromJson(jsonString);

import 'dart:convert';

Loginrespon loginresponFromJson(String str) => Loginrespon.fromJson(json.decode(str));

String loginresponToJson(Loginrespon data) => json.encode(data.toJson());

class Loginrespon {
  Loginrespon({
    this.data,
    this.failed,
    this.message,
    this.succeeded,
  });

  Data data;
  bool failed;
  String message;
  bool succeeded;

  factory Loginrespon.fromJson(Map<String, dynamic> json) => Loginrespon(
    data: Data.fromJson(json["data"]),
    failed: json["failed"],
    message: json["message"],
    succeeded: json["succeeded"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "failed": failed,
    "message": message,
    "succeeded": succeeded,
  };
}

class Data {
  Data({
    this.id,
    this.companyCode,
    this.subCompanyCode,
    this.userName,
    this.email,
    this.roles,
    this.isVerified,
    this.jwToken,
    this.issuedOn,
    this.expiresOn,
  });

  String id;
  String companyCode;
  String subCompanyCode;
  String userName;
  String email;
  List<String> roles;
  bool isVerified;
  String jwToken;
  DateTime issuedOn;
  DateTime expiresOn;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    companyCode: json["companyCode"],
    subCompanyCode: json["subCompanyCode"],
    userName: json["userName"],
    email: json["email"],
    roles: List<String>.from(json["roles"].map((x) => x)),
    isVerified: json["isVerified"],
    jwToken: json["jwToken"],
    issuedOn: DateTime.parse(json["issuedOn"]),
    expiresOn: DateTime.parse(json["expiresOn"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "companyCode": companyCode,
    "subCompanyCode": subCompanyCode,
    "userName": userName,
    "email": email,
    "roles": List<dynamic>.from(roles.map((x) => x)),
    "isVerified": isVerified,
    "jwToken": jwToken,
    "issuedOn": issuedOn.toIso8601String(),
    "expiresOn": expiresOn.toIso8601String(),
  };
}
