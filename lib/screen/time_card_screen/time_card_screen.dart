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
    final nfcAggregator = useProvider(nfcAggregatorProvider);
    final userRepository = useProvider(userRepositoryProvider);

    return _TimeCardScreenView(
      nfcAggregator,
      userRepository,
    );
  }
}

class _TimeCardScreenView extends StatefulWidget {
  final NfcAggregator nfcAggregator;
  final UserRepository userRepository;

  _TimeCardScreenView(this.nfcAggregator, this.userRepository);

  @override
  _TimeCardScreenStateView createState() =>
      _TimeCardScreenStateView(this.nfcAggregator, this.userRepository);
}

class _TimeCardScreenStateView extends State<_TimeCardScreenView>
    with RouteAware {
  NfcAggregator nfcAggregator;

  UserRepository userRepository;

  _TimeCardScreenStateView(this.nfcAggregator, this.userRepository);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
    WidgetsBinding.instance.addPostFrameCallback((_) => _listen());
  }

  void _listen() {
    nfcAggregator.tag.listen((card) async {
      final user = await userRepository.findByCard(card);

      if (user == null) {
        _showError(context);
      } else {
        Navigator.of(context).pushNamed('/time_card/select',
            arguments: TimeCardSelectArguments(user: user, card: card));
      }
    });
  }

  void didPopNext() => nfcAggregator
    ..listen()
    ..getAvailable();

  void didPush() => nfcAggregator
    ..listen()
    ..getAvailable();

  void didPop() => nfcAggregator..stop();

  void didPushNext() => nfcAggregator..stop();

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

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
                  stream: nfcAggregator.isAvailable,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<bool> snapshot,
                  ) {
                    if (!snapshot.hasData) {
                      return Container();
                    }

                    if (!snapshot.data) {
                      return Container();
                    }

                    return Padding(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 32),
                      child: Text(
                        '社員証をタッチしてください',
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
