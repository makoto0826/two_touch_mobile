import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:two_touch_mobile/infra/infra.dart';
import 'package:two_touch_mobile/model/model.dart';
import 'package:two_touch_mobile/screen/screen.dart';
import 'package:two_touch_mobile/widget/widget.dart';

class NumberScreen extends HookWidget {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final numberState = useProvider(numberProvider.state);
    final width = MediaQuery.of(context).size.width * 0.5;

    if (controller.text != numberState.text) {
      controller.text = numberState.text ?? '';
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop()),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: controller,
                      readOnly: true,
                      obscureText: true,
                      style: TextStyle(
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '社員番号を入力',
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                      child: _buildNumberButtons(context, numberState),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButtons(BuildContext context, NumberState numberState) {
    final userRepository = useProvider(userRepositoryProvider);
    final numberController = useProvider(numberProvider);

    return NumberButtons(
      onNumberPressed: numberController.add,
      onOkPressed: () {
        userRepository.findByUserId(numberState.text).then(
          (user) {
            if (user == null) {
              _showError(context);
            } else {
              Navigator.of(context)
                  .pushNamed('/select', arguments: TimeCardSelectArguments(user: user));
            }
          },
        );
      },
      onDeletePressed: numberController.removeLast,
    );
  }

  void _showError(BuildContext context) {
    Flushbar(
      message: '社員が見つかりません',
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    )..show(context);
  }
}
