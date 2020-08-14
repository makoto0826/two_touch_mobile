import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'setting.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Setting {
  @HiveField(0)
  final String baseUrl;

  @HiveField(1)
  final String apiKey;

  @HiveField(2)
  final String password;

  Setting({this.baseUrl, this.apiKey, this.password});

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);

  Map<String, dynamic> toJson() => _$SettingToJson(this);
}
