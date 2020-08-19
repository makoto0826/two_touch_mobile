import 'dart:async';
import 'package:flutter/services.dart';
import 'rcs380_status.dart';

export 'rcs380_status.dart';

const _METHOD_CHANNEL = 'com.makoto0826.two_touch_mobile/rcs380';
const _EVENT_CHANNEL = 'com.makoto0826.two_touch_mobile/rcs380-stream';

class Rcs380 {
  static Rcs380 _instance;

  static Rcs380 get instance {
    if (_instance == null) {
      _instance = Rcs380._();
    }

    return _instance;
  }

  Stream<String> get tag => _tagController.stream;

  bool _listening = false;

  final _methodChannel = const MethodChannel(_METHOD_CHANNEL);

  final _eventChannel = const EventChannel(_EVENT_CHANNEL);

  final _statusList = [
    Rcs380Status.NotFoundAndPermission,
    Rcs380Status.NotFound,
    Rcs380Status.Found,
    Rcs380Status.FoundAndPermission,
  ];

  // ignore: close_sinks
  final _tagController = StreamController<String>.broadcast();

  Rcs380._() {
    _eventChannel.receiveBroadcastStream().listen((dynamic event) {
      if (!_listening) {
        return;
      }

      _tagController.sink.add(event.toString());
    }, onError: (dynamic error) {
      print('Received error: ${error.message}');
    }, cancelOnError: true);
  }

  Future<Rcs380Status> getStatus() async {
    final hasDevice = await _checkDevice();
    final permission = await _hasPermission();

    int index = hasDevice ? 2 : 0;
    index += permission ? 1 : 0;

    return _statusList[index];
  }

  Future<bool> requestPermission() =>
      _methodChannel.invokeMethod("requestPermission");

  Future<bool> connect() async {
    final result = await _methodChannel.invokeMethod("connect");
    _listening = true;

    return result;
  }

  Future<bool> disconnect() async {
    final result = await _methodChannel.invokeMethod("disconnect");
    _listening = false;

    return result;
  }

  Future<bool> _checkDevice() => _methodChannel.invokeMethod("checkDevice");

  Future<bool> _hasPermission() => _methodChannel.invokeMethod("hasPermission");
}
