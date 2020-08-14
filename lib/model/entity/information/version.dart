import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'version.g.dart';

@HiveType(typeId: 7)
@JsonSerializable()
class Version {
  @HiveField(0)
  final int usersVersion;

  Version(this.usersVersion);

  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);
}
