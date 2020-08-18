import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:two_touch_mobile/model/model.dart';
import 'package:two_touch_mobile/screen/screen.dart';
import 'package:two_touch_mobile/widget/widget.dart';

export 'time_card_select_arguments.dart';

// ignore: must_be_immutable
class TimeCardSelectScreen extends HookWidget {
  TimeCardSelectArguments _arguments;

  TimeCardSelectScreen({arguments: TimeCardSelectArguments}) {
    _arguments = arguments;
  }

  @override
  Widget build(BuildContext context) {
    final controller = useProvider(timeCardSelectProvider);
    final resize = Resize.of(context);

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
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Clock(
                        timeFontSize: resize.textBigSize2,
                        dateFontSize: resize.textSize2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleButton(
                            text: "出勤",
                            size: resize.buttonSize2,
                            fontSize: resize.textSize1,
                            color: Colors.blue,
                            onPressed: () {
                              controller
                                  .save(
                                      user: _arguments.user,
                                      card: _arguments.card,
                                      type: TimeRecordType.In)
                                  .then((_) => Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                          '/time_card', (r) => false));
                            },
                          ),
                          CircleButton(
                            text: "退勤",
                            size: resize.buttonSize2,
                            fontSize: resize.textSize1,
                            color: Colors.blue,
                            onPressed: () {
                              controller
                                  .save(
                                      user: _arguments.user,
                                      card: _arguments.card,
                                      type: TimeRecordType.Out)
                                  .then((_) => Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                          '/time_card', (r) => false));
                            },
                          ),
                        ],
                      ),
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
}
