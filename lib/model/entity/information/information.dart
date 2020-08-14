import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'version.dart';

part 'information.g.dart';

@HiveType(typeId: 6)
@JsonSerializable()
class Information {
  @HiveField(0)
  final Version version;

  Information(this.version);

  factory Information.fromJson(Map<String, dynamic> json) =>
      _$InformationFromJson(json);
}
