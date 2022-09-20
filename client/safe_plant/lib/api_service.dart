import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:safe_plant/constants.dart';
import 'package:safe_plant/login_response_json.dart';

import 'package:safe_plant/measurements_respose_json.dart';

class ApiService {
  Future<LoginResponse?> getLoginResponse(
      String username, String password, String tenant) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint);
      var body = json.encode(
          {"username": username, "password": password, "tenant": tenant});

      // var body = json.encode({
      //   "username": "plant-manager-user-username",
      //   "password": "plant-manager-user-password",
      //   "tenant": "plant-manager-tenant"
      // });

      var response = await http.post(url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: body);
      if (response.statusCode == 200) {
        LoginResponse login = loginResponseFromJson(response.body);
        return login;
      }

      return LoginResponse(
          user: User(
            id: '',
            type: '',
            username: '',
          ),
          tokenExpirationTime: "error",
          token: "error");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<MeasurementsResponse?> getMeasurementsResponse(String token) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.measurementsEndpoint);
      var response = await http
          .get(url, headers: <String, String>{'Authorization': token});
      if (response.statusCode == 200) {
        MeasurementsResponse measurementsResponse =
            measurementsResponseFromJson(response.body);
        return measurementsResponse;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<MeasurementsResponse?> getMeasurementsResponseFilter(String token,
      int numberOfValues, String startDate, String endDate) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.getMeasurementFilterEndPoint(
              'B', numberOfValues, 1, startDate, endDate));
      var response = await http
          .get(url, headers: <String, String>{'Authorization': token});
      if (response.statusCode == 200) {
        MeasurementsResponse measurementsResponse =
            measurementsResponseFromJson(response.body);
        return measurementsResponse;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
