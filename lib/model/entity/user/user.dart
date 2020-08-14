import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@JsonSerializable()
@HiveType(typeId: 5)
class User {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final List<String> cards;

  @HiveField(3)
  final DateTime createdAt;

  User({this.userId, this.userName, this.cards, this.createdAt});

  factory User.create({String userId, String userName, List<String> cards}) =>
      User(
        userId: userId,
        userName: userName,
        cards: cards,
        createdAt: DateTime.now(),
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
