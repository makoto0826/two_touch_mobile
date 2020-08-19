import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';
import './rcs380.dart';

class NfcAggregator {
  Rcs380 _rcs380;

  NfcManager _nfcManager;

  Stream<String> get tag => _tagController.stream;

  Stream<bool> get isAvailable => _isAvailableController.stream;

  final _tagController = StreamController<String>.broadcast();

  final _isAvailableController = StreamController<bool>.broadcast();

  bool _listening = false;

  NfcAggregator(Rcs380 rcs380, NfcManager nfcManager) {
    _rcs380 = rcs380;
    _nfcManager = nfcManager;
  }

  void listen() async {
    final isAvailable = await _nfcManager.isAvailable();

    if (isAvailable) {
      _nfcManager.startTagSession(onDiscovered: (NfcTag tag) {
        if (_listening) {
          return Future.value();
        }

        _listening = true;

        final buffer = tag.data['id'] as List<int>;
        String id = '';

        for(final byte in buffer) {
          id += byte.toRadixString(16).toUpperCase();
        }

        _tagController.sink.add(id);
        _listening = false;

        return Future.value();
      });
    }

    _rcs380.tag.listen((id) {
      if (_listening) {
        return;
      }

      _listening = true;
      _tagController.sink.add(id);
      _listening = false;
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
    _nfcManager.stopSession();
    _rcs380.disconnect();
  }

  void dispose() {
    stop();
    _tagController.close();
    _isAvailableController.close();
  }
}
