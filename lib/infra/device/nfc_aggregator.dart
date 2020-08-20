import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';
import './rcs380.dart';

String _toFormat(List<int> buffer) {
  String id = '';

  for (final byte in buffer) {
    final temp = byte.toRadixString(16).toUpperCase();

    if (temp.length == 1) {
      id += '0' + temp;
    } else {
      id += temp;
    }
  }

  return id;
}

final _noop = Future.value();

class NfcAggregator {
  Rcs380 _rcs380;

  NfcManager _nfcManager;

  Stream<String> get tag => _tagController.stream;

  Stream<bool> get isAvailable => _isAvailableController.stream;

  final _tagController = StreamController<String>.broadcast();

  final _isAvailableController = StreamController<bool>.broadcast();

  bool _listening = false;

  bool _running = false;

  NfcAggregator(Rcs380 rcs380, NfcManager nfcManager) {
    _rcs380 = rcs380;
    _nfcManager = nfcManager;
  }

  void listen() async {
    if (_listening) {
      return;
    }

    _listening = true;

    final isAvailable = await _nfcManager.isAvailable();

    if (isAvailable) {
      _nfcManager.startTagSession(onDiscovered: (NfcTag tag) {
        if (_running) {
          return _noop;
        }

        _running = true;

        final buffer = tag.data['id'] as List<int>;
        final id = _toFormat(buffer);
        _tagController.sink.add(id);

        _running = false;

        return _noop;
      });
    }

    _rcs380.tag.listen((id) {
      if (_running) {
        return;
      }

      _running = true;
      _tagController.sink.add(id);
      _running = false;
    });
  }

  void getAvailable() async {
    var isAvailable = await _nfcManager.isAvailable();

    if (isAvailable) {
      _isAvailableController.sink.add(isAvailable);
      return;
    }

    final status = await _rcs380.getStatus();
    isAvailable = status == Rcs380Status.FoundAndPermission;

    _isAvailableController.sink.add(isAvailable);
  }

  void stop() {
    if (!_listening) {
      return;
    }

    _nfcManager.stopSession();
    _rcs380.disconnect();

    _listening = false;
  }

  void dispose() {
    stop();
    _tagController.close();
    _isAvailableController.close();
  }
}
