import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'time_record.g.dart';

final _uuid = Uuid();

@HiveType(typeId: 2)
enum TimeRecordType {
  @HiveField(0)
  In,

  @HiveField(1)
  Out,
}

@HiveType(typeId: 3)
enum TimeRecordStatus {
  @HiveField(0)
  None,

  @HiveField(1)
  Synced,

  @HiveField(2)
  AuthError,

  @HiveField(3)
  SyncError,

  @HiveField(4)
  ServerError
}

@JsonSerializable()
@HiveType(typeId: 4)
class TimeRecord {
  @HiveField(0)
  final String localTimeRecordId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String userName;

  @HiveField(3)
  final String card;

  @HiveField(4)
  @JsonKey(ignore: true)
  final TimeRecordStatus status;

  @HiveField(5)
  @JsonKey(toJson: _typeToJson)
  final TimeRecordType type;

  @HiveField(6)
  final DateTime registeredAt;

  @HiveField(7)
  final DateTime updatedAt;

  TimeRecord(
      {this.localTimeRecordId,
      this.userId,
      this.userName,
      this.card,
      this.status = TimeRecordStatus.None,
      this.type,
      this.registeredAt,
      this.updatedAt});

  TimeRecord changeStatus(TimeRecordStatus status) => TimeRecord(
        localTimeRecordId: this.localTimeRecordId,
        userId: this.userId,
        userName: this.userName,
        card: this.card,
        type: this.type,
        status: status,
        registeredAt: this.registeredAt,
        updatedAt: DateTime.now(),
      );

  factory TimeRecord.create({
    String userId,
    String userName,
    String card,
    TimeRecordType type,
  }) =>
      TimeRecord(
        localTimeRecordId: _uuid.v4().toString(),
        userId: userId,
        userName: userName,
        card: card,
        type: type,
        registeredAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  static String _typeToJson(TimeRecordType type) =>
      type == TimeRecordType.In ? '1' : '2';

  Map<String, dynamic> toJson() => _$TimeRecordToJson(this);
}
