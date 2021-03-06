import 'dart:math';

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
    final resize = Resize.of(context);

    final numberState = useProvider(numberProvider.state);
    final width = min(360.0, MediaQuery.of(context).size.width * 0.8);

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
                        fontSize: resize.textSize2,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '社員番号を入力',
                        contentPadding: EdgeInsets.all(0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                      child: _buildNumberButtons(context, resize, numberState),
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

  Widget _buildNumberButtons(
    BuildContext context,
    ResizeData resize,
    NumberState numberState,
  ) {
    final userRepository = useProvider(userRepositoryProvider);
    final numberController = useProvider(numberProvider);

    return NumberButtons(
      buttonSize: resize.buttonSize1,
      padding: resize.padding1,
      onNumberPressed: numberController.add,
      onOkPressed: () {
        userRepository.findByUserId(numberState.text).then(
          (user) {
            if (user == null) {
              _showError(context);
            } else {
              Navigator.of(context).pushNamed('/time_card/select',
                  arguments: TimeCardSelectArguments(user: user));
            }
          },
        );
      },
      onDeletePressed: numberController.removeLast,
    );
  }

  void _showError(BuildContext context) {
    Flushbar(
      icon: Icon(Icons.error_outline, color: Colors.white),
      message: '社員番号が登録さていません',
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    )..show(context);
  }
}
