import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/config.dart';
import '../../utils/utils.dart';

class WidgetBuilderViewModel extends BaseViewModel {
  double _progression = 0.0;
  double get progression => _progression;
  void setProgression(value) {
    _progression = value;
    notifyListeners();
  }

  bool _onLoading = true;
  bool get onLoading => _onLoading;
  void loadingStart() {
    _onLoading = true;
    notifyListeners();
  }

  void loadingFinish() {
    _onLoading = false;
    notifyListeners();
  }

  String _lastEvent = "";
  String get lastEvent => _lastEvent;
  void setLastEvent(value) {
    _lastEvent = value;
    notifyListeners();
  }

  Map<String, dynamic> _data = {};
  Map<String, dynamic> get data => _data;
  void setData(Map<String, dynamic> data) {
    _data = data;
    notifyListeners();
  }

  FutureOr<NavigationDecision> onUrlChange(UrlChange urlChange, context) async {
    if (urlChange.url == null) {
      return NavigationDecision.prevent;
    } else {
      if (urlChange.url!.startsWith(WaveRedirectURI) ||
          urlChange.url!.startsWith(PlayStoreRedirectURI)) {
        Utils.launchWave(urlChange.url!);
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    }
  }
}
