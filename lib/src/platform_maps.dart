part of platform_maps_flutter;

typedef void MapCreatedCallback(PlatformMapController controller);

typedef void CameraPositionCallback(CameraPosition position);

/// Callback function taking a single argument.
typedef void ArgumentCallback<T>(T argument);

class PlatformMap extends StatefulWidget {
  const PlatformMap({
    Key? key,
    required this.initialCameraPosition,
    this.onMapCreated,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.compassEnabled = true,
    this.mapType = MapType.normal,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
    this.padding = const EdgeInsets.all(0),
    this.trafficEnabled = false,
    this.markers = const <Marker>{},
    this.polygons = const <Polygon>{},
    this.polylines = const <Polyline>{},
    this.circles = const <Circle>{},
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [GoogleMapController] for this [GoogleMap].
  final MapCreatedCallback? onMapCreated;

  /// The initial position of the map's camera.
  final CameraPosition initialCameraPosition;

  /// True if the map should show a compass when rotated.
  final bool compassEnabled;

  /// Type of map tiles to be rendered.
  final MapType mapType;

  /// Preferred bounds for the camera zoom level.
  ///
  /// Actual bounds depend on map data and device.
  final MinMaxZoomPreference minMaxZoomPreference;

  /// True if the map view should respond to rotate gestures.
  final bool rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  final bool scrollGesturesEnabled;

  /// True if the map view should show zoom controls. This includes two buttons
  /// to zoom in and zoom out. The default value is to show zoom controls.
  ///
  /// This is only supported on Android. And this field is silently ignored on iOS.
  final bool zoomControlsEnabled;

  /// True if the map view should respond to zoom gestures.
  final bool zoomGesturesEnabled;

  /// True if the map view should respond to tilt gestures.
  final bool tiltGesturesEnabled;

  /// Padding to be set on map. See https://developers.google.com/maps/documentation/android-sdk/map#map_padding for more details.
  final EdgeInsets padding;

  /// Markers to be placed on the map.
  final Set<Marker> markers;

  /// Polygons to be placed on the map.
  final Set<Polygon> polygons;

  /// Polylines to be placed on the map.
  final Set<Polyline> polylines;

  /// Circles to be placed on the map.
  final Set<Circle> circles;

  /// Called when the camera starts moving.
  ///
  /// This can be initiated by the following:
  /// 1. Non-gesture animation initiated in response to user actions.
  ///    For example: zoom buttons, my location button, or marker clicks.
  /// 2. Programmatically initiated animation.
  /// 3. Camera motion initiated in response to user gestures on the map.
  ///    For example: pan, tilt, pinch to zoom, or rotate.
  final VoidCallback? onCameraMoveStarted;

  /// Called repeatedly as the camera continues to move after an
  /// onCameraMoveStarted call.
  ///
  /// This may be called as often as once every frame and should
  /// not perform expensive operations.
  final CameraPositionCallback? onCameraMove;

  /// Called when camera movement has ended, there are no pending
  /// animations and the user has stopped interacting with the map.
  final VoidCallback? onCameraIdle;

  /// Called every time a [GoogleMap] is tapped.
  final ArgumentCallback<LatLng>? onTap;

  /// Called every time a [GoogleMap] is long pressed.
  final ArgumentCallback<LatLng>? onLongPress;

  /// True if a "My Location" layer should be shown on the map.
  ///
  /// This layer includes a location indicator at the current device location,
  /// as well as a My Location button.
  /// * The indicator is a small blue dot if the device is stationary, or a
  /// chevron if the device is moving.
  /// * The My Location button animates to focus on the user's current location
  /// if the user's location is currently known.
  ///
  /// Enabling this feature requires adding location permissions to both native
  /// platforms of your app.
  /// * On Android add either
  /// `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />`
  /// or `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />`
  /// to your `AndroidManifest.xml` file. `ACCESS_COARSE_LOCATION` returns a
  /// location with an accuracy approximately equivalent to a city block, while
  /// `ACCESS_FINE_LOCATION` returns as precise a location as possible, although
  /// it consumes more battery power. You will also need to request these
  /// permissions during run-time. If they are not granted, the My Location
  /// feature will fail silently.
  /// * On iOS add a `NSLocationWhenInUseUsageDescription` key to your
  /// `Info.plist` file. This will automatically prompt the user for permissions
  /// when the map tries to turn on the My Location layer.
  final bool myLocationEnabled;

  /// Enables or disables the my-location button.
  ///
  /// The my-location button causes the camera to move such that the user's
  /// location is in the center of the map. If the button is enabled, it is
  /// only shown when the my-location layer is enabled.
  ///
  /// By default, the my-location button is enabled (and hence shown when the
  /// my-location layer is enabled).
  ///
  /// See also:
  ///   * [myLocationEnabled] parameter.
  final bool myLocationButtonEnabled;

  /// Enables or disables the traffic layer of the map
  final bool trafficEnabled;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  @override
  _PlatformMapState createState() => _PlatformMapState();
}

class _PlatformMapState extends State<PlatformMap> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb || Platform.isAndroid) {
      return googleMaps.GoogleMap(
        initialCameraPosition:
            widget.initialCameraPosition.googleMapsCameraPosition,
        compassEnabled: widget.compassEnabled,
        mapType: _getGoogleMapType(),
        padding: widget.padding,
        markers: Marker.toGoogleMapsMarkerSet(widget.markers),
        polylines: Polyline.toGoogleMapsPolylines(widget.polylines),
        polygons: Polygon.toGoogleMapsPolygonSet(widget.polygons),
        circles: Circle.toGoogleMapsCircleSet(widget.circles),
        gestureRecognizers: widget.gestureRecognizers,
        onCameraIdle: widget.onCameraIdle,
        myLocationButtonEnabled: widget.myLocationButtonEnabled,
        myLocationEnabled: widget.myLocationEnabled,
        onCameraMoveStarted: widget.onCameraMoveStarted,
        tiltGesturesEnabled: widget.tiltGesturesEnabled,
        rotateGesturesEnabled: widget.rotateGesturesEnabled,
        zoomControlsEnabled: widget.zoomControlsEnabled,
        zoomGesturesEnabled: widget.zoomGesturesEnabled,
        scrollGesturesEnabled: widget.scrollGesturesEnabled,
        onMapCreated: _onMapCreated,
        onCameraMove: _onCameraMove,
        onTap: _onTap,
        onLongPress: _onLongPress,
        trafficEnabled: widget.trafficEnabled,
        minMaxZoomPreference:
            widget.minMaxZoomPreference.googleMapsZoomPreference,
      );
    } else if (Platform.isIOS) {
      return appleMaps.AppleMap(
        initialCameraPosition:
            widget.initialCameraPosition.appleMapsCameraPosition,
        compassEnabled: widget.compassEnabled,
        mapType: _getAppleMapType(),
        padding: widget.padding,
        annotations: Marker.toAppleMapsAnnotationSet(widget.markers),
        polylines: Polyline.toAppleMapsPolylines(widget.polylines),
        polygons: Polygon.toAppleMapsPolygonSet(widget.polygons),
        circles: Circle.toAppleMapsCircleSet(widget.circles),
        gestureRecognizers: widget.gestureRecognizers,
        onCameraIdle: widget.onCameraIdle,
        myLocationButtonEnabled: widget.myLocationButtonEnabled,
        myLocationEnabled: widget.myLocationEnabled,
        onCameraMoveStarted: widget.onCameraMoveStarted,
        pitchGesturesEnabled: widget.tiltGesturesEnabled,
        rotateGesturesEnabled: widget.rotateGesturesEnabled,
        zoomGesturesEnabled: widget.zoomGesturesEnabled,
        scrollGesturesEnabled: widget.scrollGesturesEnabled,
        onMapCreated: _onMapCreated,
        onCameraMove: _onCameraMove,
        onTap: _onTap,
        onLongPress: _onLongPress,
        trafficEnabled: widget.trafficEnabled,
        minMaxZoomPreference:
            widget.minMaxZoomPreference.appleMapsZoomPreference,
      );
    } else {
      return Text("Platform not yet implemented");
    }
  }

  void _onMapCreated(dynamic controller) {
    widget.onMapCreated?.call(getController(controller));
  }

  void _onCameraMove(dynamic cameraPosition) {
    if (kIsWeb || Platform.isAndroid) {
      widget.onCameraMove?.call(
        CameraPosition.fromGoogleMapCameraPosition(
          cameraPosition as googleMapsInterface.CameraPosition,
        ),
      );
    } else if (Platform.isIOS) {
      widget.onCameraMove?.call(
        CameraPosition.fromAppleMapCameraPosition(
          cameraPosition as appleMaps.CameraPosition,
        ),
      );
    }
  }

  void _onTap(dynamic position) {
    if (kIsWeb || Platform.isAndroid) {
      widget.onTap?.call(
          LatLng.fromGoogleLatLng(position as googleMapsInterface.LatLng));
    } else if (Platform.isIOS) {
      widget.onTap?.call(LatLng.fromAppleLatLng(position as appleMaps.LatLng));
    }
  }

  void _onLongPress(dynamic position) {
    if (kIsWeb || Platform.isAndroid) {
      widget.onLongPress?.call(
          LatLng.fromGoogleLatLng(position as googleMapsInterface.LatLng));
    } else if (Platform.isIOS) {
      widget.onLongPress
          ?.call(LatLng.fromAppleLatLng(position as appleMaps.LatLng));
    }
  }

  appleMaps.MapType _getAppleMapType() {
    if (widget.mapType == MapType.normal) {
      return appleMaps.MapType.standard;
    } else if (widget.mapType == MapType.satellite) {
      return appleMaps.MapType.satellite;
    } else if (widget.mapType == MapType.hybrid) {
      return appleMaps.MapType.hybrid;
    }
    return appleMaps.MapType.standard;
  }

  googleMapsInterface.MapType _getGoogleMapType() {
    if (widget.mapType == MapType.normal) {
      return googleMapsInterface.MapType.normal;
    } else if (widget.mapType == MapType.satellite) {
      return googleMapsInterface.MapType.satellite;
    } else if (widget.mapType == MapType.hybrid) {
      return googleMapsInterface.MapType.hybrid;
    }
    return googleMapsInterface.MapType.normal;
  }
}
