import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:two_touch_mobile/model/model.dart';

class UserListScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useProvider(userListControllerProvider).load();
    return _UserListScreenView();
  }
}

class _UserListScreenView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(userListControllerProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: Text('ユーザ一覧'),
      ),
      body: ListView(
        children: [
          for (final user in state.users) _userItem(user.userName),
        ],
      ),
    );
  }

  Widget _userItem(String userName) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: ListTile(
        title: Text(userName),
      ),
    );
  }
}
