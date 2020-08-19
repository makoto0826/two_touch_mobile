import 'package:flutter/material.dart';

const _borderColor = Color(0xFFEFEFF4);

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('管理'),
      ),
      body: ListView(
        children: [
          _headerItem(context, '設定'),
          _menuItem(
              'サーバー設定', () => Navigator.of(context).pushNamed('/admin/server')),
          _menuItem(
              'デバイス設定', () => Navigator.of(context).pushNamed('/admin/device')),
          _divider(),
          _headerItem(context, '管理'),
          _menuItem('ユーザ一覧',
              () => Navigator.of(context).pushNamed('/admin/user_list')),
          _divider(),
          _headerItem(context, '情報'),
          _aboutItem()
        ],
      ),
    );
  }

  Widget _headerItem(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _borderColor),
        ),
      ),
    );
  }

  Widget _menuItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _aboutItem() {
    return AboutListTile(
      applicationName: 'TwoTouch',
      applicationVersion: '1.0.0',
      applicationLegalese: '2020 makoto0826',
    );
  }
}
