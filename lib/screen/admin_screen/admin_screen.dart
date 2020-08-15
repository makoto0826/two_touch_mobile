import 'package:flutter/material.dart';

const _borderColor = Color(0xFFEFEFF4);

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('管理'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _headerItem(context, '設定'),
            _menuItem('サーバー設定',
                () => Navigator.of(context).pushNamed('/admin/server')),
            _menuItem('デバイス設定',
                () => Navigator.of(context).pushNamed('/admin/rcs380')),
            _headerItem(context, '一覧'),
            _menuItem('社員一覧',
                () => Navigator.of(context).pushNamed('/admin/user_list')),
            _headerItem(context, 'その他'),
            _aboutItem()
          ],
        ),
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

  Widget _menuItem(String title, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _borderColor),
        ),
      ),
      child: ListTile(
        title: Text(title),
        onTap: onTap,
      ),
    );
  }

  Widget _aboutItem() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _borderColor),
        ),
      ),
      child: AboutListTile(
        applicationName: 'TwoTouch',
        applicationVersion: '1.0.0',
        applicationLegalese: '2020 makoto0826',
      ),
    );
  }
}
