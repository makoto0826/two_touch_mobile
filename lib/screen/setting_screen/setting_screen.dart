import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _menuItem("サーバー設定",
                () => Navigator.of(context).pushNamed('/setting/server')),
            _menuItem("デバイス設定",
                () => Navigator.of(context).pushNamed('/setting/rcs380')),
            _menuItem("社員一覧",
                () => Navigator.of(context).pushNamed('/setting/user_list')),
            _aboutItem()
          ],
        ),
      ),
    );
  }

  Widget _menuItem(String title, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
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
          bottom: BorderSide(color: Colors.grey),
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
