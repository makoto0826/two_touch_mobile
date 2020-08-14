import 'dart:async';
import 'package:flutter/services.dart';
import 'rcs380_status.dart';

const METHOD_CHANNEL = 'com.makoto0826.two_touch_mobile/rcs380';
const EVENT_CHANNEL = 'com.makoto0826.two_touch_mobile/rcs380-stream';

class Rcs380 {
  static Rcs380 _instance;

  static Rcs380 get instance {
    if (_instance == null) {
      _instance = Rcs380._();
    }

    return _instance;
  }

  Stream<String> get card => _cardController.stream;

  Stream<Rcs380Status> get status => _statusController.stream;

  bool _cardListening = false;

  final _methodChannel = const MethodChannel(METHOD_CHANNEL);

  final _eventChannel = const EventChannel(EVENT_CHANNEL);

  // ignore: close_sinks
  final _cardController = StreamController<String>.broadcast();

  final _statusController = StreamController<Rcs380Status>.broadcast();

  Rcs380._() {
    _eventChannel.receiveBroadcastStream().listen((dynamic event) {
      if (!_cardListening) {
        return;
      }

      _cardController.sink.add(event.toString());
    }, onError: (dynamic error) {
      print('Received error: ${error.message}');
    }, cancelOnError: true);
  }

  final _statusList = [
    Rcs380Status.NotFoundAndPermission,
    Rcs380Status.NotFound,
    Rcs380Status.Found,
    Rcs380Status.FoundAndPermission,
  ];

  Future<void> getStatus() async {
    final hasDevice = await _checkDevice();
    final permission = await _hasPermission();

    int index = hasDevice ? 2 : 0;
    index += permission ? 1 : 0;

    _statusController.add(_statusList[index]);
  }

  Future<bool> requestPermission() =>
      _methodChannel.invokeMethod("requestPermission");

  Future<bool> connect() async {
    final result = await _methodChannel.invokeMethod("connect");
    _cardListening = true;

    return result;
  }

  Future<bool> disconnect() async {
    final result = await _methodChannel.invokeMethod("disconnect");
    _cardListening = false;

    return result;
  }

  Future<bool> _checkDevice() => _methodChannel.invokeMethod("checkDevice");

  Future<bool> _hasPermission() => _methodChannel.invokeMethod("hasPermission");
}
