part of platform_maps_flutter;

PlatformMapController getController(dynamic controller) =>
    PlatformMapController(controller);

class PlatformMapController {
  appleMaps.AppleMapController? appleController;
  googleMaps.GoogleMapController? googleController;

  PlatformMapController(dynamic controller) {
    if (controller.runtimeType == googleMaps.GoogleMapController) {
      this.googleController = controller;
    } else if (controller.runtimeType == appleMaps.AppleMapController) {
      this.appleController = controller;
    }
  }

  /// Programmatically show the Info Window for a [Marker].
  ///
  /// The `markerId` must match one of the markers on the map.
  /// An invalid `markerId` triggers an "Invalid markerId" error.
  ///
  /// * See also:
  ///   * [hideMarkerInfoWindow] to hide the Info Window.
  ///   * [isMarkerInfoWindowShown] to check if the Info Window is showing.
  Future<void> showMarkerInfoWindow(MarkerId markerId) async {
    if (kIsWeb || Platform.isAndroid) {
      return googleController!
          .showMarkerInfoWindow(markerId.googleMapsMarkerId);
    }

    if (Platform.isIOS) {
      return appleController!
          .showMarkerInfoWindow(markerId.appleMapsAnnoationId);
    }
    throw Exception('Platform not supported.');
  }

  /// Programmatically hide the Info Window for a [Marker].
  ///
  /// The `markerId` must match one of the markers on the map.
  /// An invalid `markerId` triggers an "Invalid markerId" error.
  ///
  /// * See also:
  ///   * [showMarkerInfoWindow] to show the Info Window.
  ///   * [isMarkerInfoWindowShown] to check if the Info Window is showing.
  Future<void> hideMarkerInfoWindow(MarkerId markerId) async {
    if (kIsWeb || Platform.isAndroid) {
      return googleController!
          .hideMarkerInfoWindow(markerId.googleMapsMarkerId);
    }

    if (Platform.isIOS) {
      return appleController!
          .hideMarkerInfoWindow(markerId.appleMapsAnnoationId);
    }
    throw Exception('Platform not supported.');
  }

  /// Returns `true` when the [InfoWindow] is showing, `false` otherwise.
  ///
  /// The `markerId` must match one of the markers on the map.
  /// An invalid `markerId` triggers an "Invalid markerId" error.
  ///
  /// * See also:
  ///   * [showMarkerInfoWindow] to show the Info Window.
  ///   * [hideMarkerInfoWindow] to hide the Info Window.
  Future<bool> isMarkerInfoWindowShown(MarkerId markerId) async {
    if (kIsWeb || Platform.isAndroid) {
      return googleController!
          .isMarkerInfoWindowShown(markerId.googleMapsMarkerId);
    }

    if (Platform.isIOS) {
      return await appleController!
              .isMarkerInfoWindowShown(markerId.appleMapsAnnoationId) ??
          false;
    }

    throw Exception('Platform not supported.');
  }

  Future<double> getZoomLevel() async {
    if (kIsWeb || Platform.isAndroid) {
      return googleController!.getZoomLevel();
    }

    if (Platform.isIOS) {
      return await appleController!.getZoomLevel() ?? 0;
    }

    throw Exception('Platform not supported.');
  }

  /// Starts an animated change of the map camera position.
  ///
  /// The returned [Future] completes after the change has been started on the
  /// platform side.
  Future<void> animateCamera(cameraUpdate) async {
    if (kIsWeb || Platform.isAndroid) {
      return this.googleController!.animateCamera(cameraUpdate);
    }
    if (Platform.isIOS) {
      return this.appleController!.animateCamera(cameraUpdate);
    }
    throw Exception('Platform not supported.');
  }

  /// Changes the map camera position.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  Future<void> moveCamera(cameraUpdate) async {
    if (kIsWeb || Platform.isAndroid) {
      return this.googleController!.moveCamera(cameraUpdate);
    }
    if (Platform.isIOS) {
      return this.appleController!.moveCamera(cameraUpdate);
    }
    throw Exception('Platform not supported.');
  }

  /// Return [LatLngBounds] defining the region that is visible in a map.
  Future<LatLngBounds> getVisibleRegion() async {
    late LatLngBounds _bounds;
    if (kIsWeb || Platform.isAndroid) {
      googleMapsInterface.LatLngBounds googleBounds =
          await this.googleController!.getVisibleRegion();
      _bounds = LatLngBounds.fromGoogleLatLngBounds(googleBounds);
    } else if (Platform.isIOS) {
      appleMaps.LatLngBounds appleBounds =
          await this.appleController!.getVisibleRegion();
      _bounds = LatLngBounds.fromAppleLatLngBounds(appleBounds);
    }
    return _bounds;
  }

  /// Returns the image bytes of the map
  Future<Uint8List?> takeSnapshot() async {
    if (Platform.isAndroid) {
      return this.googleController!.takeSnapshot();
    }
    if (Platform.isIOS) {
      return this.appleController!.takeSnapshot();
    }

    throw Exception('Platform not supported.');
  }
}
