import 'package:two_touch_mobile/model/model.dart';
import 'database.dart';

class UserRepository {
  Database _db;

  UserRepository({Database db}) {
    _db = db;
  }

  Future<List<User>> findAll() async {
    final box = await _db.getUserBox();
    return box.values.toList();
  }

  Future<User> findByUserId(String userId) async {
    final box = await _db.getUserBox();
    final user = box.values
        .firstWhere((user) => user.userId == userId, orElse: () => null);

    return user;
  }

  Future<User> findByCard(String card) async {
    final box = await _db.getUserBox();
    final user = box.values
        .firstWhere((user) => user.cards.contains(card), orElse: () => null);

    return user;
  }

  Future<void> deleteAll() async {
    final box = await _db.getUserBox();
    await box.deleteFromDisk();
  }

  Future<void> saveAll(List<User> users) async {
    final box = await _db.getUserBox();

    Map<dynamic, User> entries =
        Map.fromIterable(users, key: (e) => e.userId, value: (e) => e);

    box.putAll(entries);
  }
}
