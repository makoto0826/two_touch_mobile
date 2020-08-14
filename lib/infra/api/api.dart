import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:two_touch_mobile/model/model.dart';

import 'api_error.dart';
import 'api_option.dart';
import 'api_result.dart';
import 'api_result_status.dart';

export 'api_error.dart';
export 'api_option.dart';
export 'api_result.dart';
export 'api_result_status.dart';

ApiResult<T> _parseErrorResponse<T>(http.Response response) {
  final error = ApiError.fromJson(
    json.decode(response.body),
  );

  if (response.statusCode == 400) {
    return ApiResult<T>(status: ApiResultStatus.BadRequest, error: error);
  }

  if (response.statusCode == 401) {
    return ApiResult<T>(status: ApiResultStatus.Unauthorized, error: error);
  }

  return ApiResult<T>(status: ApiResultStatus.ServerError, error: error);
}

class Api {
  ApiOption _option;

  Api({ApiOption option}) {
    _option = option;
  }

  Future<ApiResult<Information>> getInformation() async {
    try {
      final response = await http.get(
        '${_option.baseUrl}getInformation',
        headers: _createHeader(),
      );

      if (response.statusCode == 200) {
        return ApiResult<Information>(
          status: ApiResultStatus.Ok,
          value: Information.fromJson(json.decode(response.body)),
        );
      }

      return _parseErrorResponse<Information>(response);
    } catch (e) {
      print(e);
      return ApiResult<Information>(status: ApiResultStatus.Unknown);
    }
  }

  Future<ApiResult<List<User>>> getUsers() async {
    try {
      final response = await http.get(
        '${_option.baseUrl}getUsers',
        headers: _createHeader(),
      );

      if (response.statusCode == 200) {
        final jsonArray = jsonDecode(response.body);
        List<User> users = [];

        for (Map json in jsonArray) {
          users.add(User.fromJson(json));
        }

        return ApiResult<List<User>>(
          status: ApiResultStatus.Ok,
          value: users,
        );
      }

      return _parseErrorResponse<List<User>>(response);
    } catch (e) {
      print(e);
      return ApiResult<List<User>>(status: ApiResultStatus.Unknown);
    }
  }

  Future<ApiResult<dynamic>> addTimeRecord(TimeRecord timeRecord) async {
    try {
      final response = await http.post(
        '${_option.baseUrl}addTimeRecord',
        body: json.encode(timeRecord.toJson()),
        headers: _createHeader(),
      );

      if (response.statusCode == 200) {
        return ApiResult<dynamic>(status: ApiResultStatus.Ok);
      }

      return _parseErrorResponse<dynamic>(response);
    } catch (e) {
      print(e);
      return ApiResult<dynamic>(status: ApiResultStatus.Unknown);
    }
  }

  Map<String, String> _createHeader() {
    return {
      'Content-Type': 'application/json',
      'X-API-KEY': _option.apiKey,
    };
  }
}
