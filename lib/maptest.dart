import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void MaptestCreatedCallback(MaptestController controller);

class MaptestController {
  MethodChannel _channel;
  MaptestController.init(int id) {
    _channel = new MethodChannel("maptest_$id");
  }

  Future<void> loadMap() async {
    return await _channel.invokeMethod("loadMap");
  }

  Future<String> get getPlatform async {
    return await _channel.invokeMethod<String>("loadMap");
  }

  Future<void> setZoomLevel() async {
    await _channel.invokeMethod("setZoomLevel");
  }
}

class KakaoMapView extends StatefulWidget {
  final MaptestCreatedCallback onMapCreated;
  final double width;
  final double height;
  const KakaoMapView({Key key, this.onMapCreated, this.width, this.height})
      : super(key: key);

  @override
  _KakaoMapViewState createState() => _KakaoMapViewState();
}

class _KakaoMapViewState extends State<KakaoMapView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
        child: UiKitView(
          viewType: "KakaoMapPlugin",
          onPlatformViewCreated: onPlatformViewCreated,
          creationParamsCodec: const StandardMessageCodec(),
        ),
        width: widget.width,
        height: widget.height,
      );
    } else {
      return Container();
    }
  }

  Future<void> onPlatformViewCreated(id) async {
    if (widget.onMapCreated == null) {
      return;
    }
    widget.onMapCreated(new MaptestController.init(id));
  }
}
