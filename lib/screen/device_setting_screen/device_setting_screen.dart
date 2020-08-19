import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:two_touch_mobile/infra/infra.dart';
import 'package:two_touch_mobile/model/model.dart';

const _borderColor = Color(0xFFEFEFF4);

class DeviceSettingScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final rcs380Controller = useProvider(rcs380SettingControllerProvider);
    rcs380Controller.getStatus();

    return Scaffold(
      appBar: AppBar(
        title: Text('デバイス設定'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _Rcs380SettingItem(rcs380Controller),
            _divider(),
            _NfcSettingItem()
          ],
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
}

class _Rcs380SettingItem extends HookWidget {
  final Rcs380SettingController controller;

  _Rcs380SettingItem(this.controller) {
    controller.getStatus();
  }

  @override
  Widget build(BuildContext context) {
    final state = useProvider(rcs380SettingControllerProvider.state);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(state.text),
          RaisedButton(
            color: Theme.of(context).accentColor,
            child: Text(
              '有効にする',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed:
                state.isEnabled ? () => controller.requestPermission() : null,
          ),
        ],
      ),
    );
  }
}

class _NfcSettingItem extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final nfcManager = useProvider(nfcManagerProvider);

    return FutureBuilder(
      initialData: false,
      future: nfcManager.isAvailable(),
      builder: (context, snapshot) {
        if (snapshot.data) {
          return ListTile(
            title: Text('NFCサポート'),
            subtitle: Text('サポートしています'),
          );
        }

        return ListTile(
          title: Text('NFCサポート'),
          subtitle: Text('サポートしていません'),
        );
      },
    );
  }
}
