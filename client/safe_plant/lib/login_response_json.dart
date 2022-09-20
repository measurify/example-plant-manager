// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.user,
    required this.tokenExpirationTime,
    required this.token,
  });

  User user;
  String tokenExpirationTime;
  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        user: User.fromJson(json["user"]),
        tokenExpirationTime: json["token_expiration_time"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token_expiration_time": tokenExpirationTime,
        "token": token,
      };
}

class User {
  User({
    required this.id,
    required this.username,
    required this.type,
  });

  String id;
  String username;
  String type;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        username: json["username"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "type": type,
      };
}
