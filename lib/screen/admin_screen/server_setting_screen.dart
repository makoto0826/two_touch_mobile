import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:two_touch_mobile/model/model.dart';

class ServerSettingScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useProvider(serverSettingControllerProvider);
    return _ServerSettingScreenView(controller);
  }
}

class _ServerSettingScreenView extends HookWidget {
  final baseUrlController = TextEditingController();

  final apiKeyController = TextEditingController();

  final ServerSettingController controller;

  _ServerSettingScreenView(this.controller) {
    this.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final state = useProvider(serverSettingControllerProvider.state);

    if (baseUrlController.text != state.baseUrl) {
      baseUrlController.text = state.baseUrl ?? '';
    }

    if (apiKeyController.text != state.apiKey) {
      apiKeyController.text = state.apiKey ?? '';
    }

    return WillPopScope(
      onWillPop: () => Future.value(!state.isLoading),
      child: LoadingOverlay(
        isLoading: state.isLoading,
        progressIndicator: const CircularProgressIndicator(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('サーバー設定'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      controller: baseUrlController,
                      onChanged: controller.changeBaseUrl,
                      decoration: InputDecoration(
                        labelText: 'URL',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      controller: apiKeyController,
                      onChanged: controller.changeApiKey,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'APIキー',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        '保存',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        controller.save().then(
                          (result) {
                            switch (result.status) {
                              case SaveResultStatus.Ok:
                                _showOk(context, result);
                                break;
                              case SaveResultStatus.Error:
                                _showError(context, result);
                                break;
                              case SaveResultStatus.None:
                                break;
                            }
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOk(BuildContext context, SaveResult result) {
    Flushbar(
      message: result.text,
      duration: Duration(seconds: 2),
    )..show(context);
  }

  void _showError(BuildContext context, SaveResult result) {
    Flushbar(
      message: result.text,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    )..show(context);
  }
}
