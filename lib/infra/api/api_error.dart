import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable()
class ApiError {
  final String code;

  final String message;

  ApiError(this.code,this.message);

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
}