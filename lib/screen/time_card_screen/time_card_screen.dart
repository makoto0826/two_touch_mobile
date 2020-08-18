import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:two_touch_mobile/app.dart';
import 'package:two_touch_mobile/infra/infra.dart';
import 'package:two_touch_mobile/screen/screen.dart';
import 'package:two_touch_mobile/widget/widget.dart';

class TimeCardScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final rcs380 = useProvider(rcs380Provider);
    final userRepository = useProvider(userRepositoryProvider);

    return _TimeCardScreenView(rcs380: rcs380, userRepository: userRepository);
  }
}

class _TimeCardScreenView extends StatefulWidget {
  final Rcs380 rcs380;
  final UserRepository userRepository;

  _TimeCardScreenView({this.rcs380, this.userRepository});

  @override
  _TimeCardScreenStateView createState() =>
      _TimeCardScreenStateView(this.rcs380, this.userRepository);
}

class _TimeCardScreenStateView extends State<_TimeCardScreenView>
    with RouteAware {
  final Rcs380 rcs380;
  final UserRepository userRepository;

  _TimeCardScreenStateView(this.rcs380, this.userRepository);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
    WidgetsBinding.instance.addPostFrameCallback((_) => _listenRcs380());
  }

  void _listenRcs380() {
    rcs380.card.listen((card) async {
      final user = await userRepository.findByCard(card);

      if (user == null) {
        _showError(context);
      } else {
        Navigator.of(context).pushNamed('/time_card/select',
            arguments: TimeCardSelectArguments(user: user, card: card));
      }
    });
  }

  void didPopNext() => rcs380
    ..connect()
    ..getStatus();

  void didPush() => rcs380
    ..connect()
    ..getStatus();

  void didPop() => rcs380..disconnect();

  void didPushNext() => rcs380..disconnect();

  @override
  Widget build(BuildContext context) {
    final resize = Resize.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => Navigator.of(context).pushNamed('/admin'),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Clock(
                  timeFontSize: resize.textBigSize2,
                  dateFontSize: resize.textSize2,
                ),
                StreamBuilder(
                  stream: rcs380.status,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<Rcs380Status> snapshot,
                  ) {
                    if (!snapshot.hasData ||
                        snapshot.data != Rcs380Status.FoundAndPermission) {
                      return Container();
                    }

                    return Padding(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 32),
                      child: Text(
                        '社員証をリーダーにタッチしてください',
                        style: TextStyle(
                          fontSize: resize.textSize2,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: RaisedButton(
                    child: Text(
                      "社員番号入力",
                      style: TextStyle(
                        fontSize: resize.textSize1,
                      ),
                    ),
                    color: Colors.white,
                    highlightElevation: 16.0,
                    highlightColor: Colors.blue,
                    padding: EdgeInsets.all(16),
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    onPressed: () => Navigator.of(context).pushNamed('/number'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showError(BuildContext context) {
    Flushbar(
      icon: Icon(Icons.error_outline, color: Colors.white),
      message: '社員証が登録されていません',
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    )..show(context);
  }
}
