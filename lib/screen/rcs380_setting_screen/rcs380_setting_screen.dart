import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:two_touch_mobile/model/model.dart';

class Rcs380SettingScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useProvider(rcs380SettingControllerProvider);
    return _Rcs380SettingScreenView(controller);
  }
}

class _Rcs380SettingScreenView extends HookWidget {
  final Rcs380SettingController controller;

  _Rcs380SettingScreenView(this.controller) {
    this.controller.getStatus();
  }

  @override
  Widget build(BuildContext context) {
    final state = useProvider(rcs380SettingControllerProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: Text('デバイス設定'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                    onPressed: state.isEnabled
                        ? () => controller.requestPermission()
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
