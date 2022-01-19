part of platform_maps_flutter;

/// A pair of latitude and longitude coordinates, stored as degrees.
class LatLng {
  /// Creates a geographical location specified in degrees [latitude] and
  /// [longitude].
  ///
  /// The latitude is clamped to the inclusive interval from -90.0 to +90.0.
  ///
  /// The longitude is normalized to the half-open interval from -180.0
  /// (inclusive) to +180.0 (exclusive)
  const LatLng(double latitude, double longitude)
      : latitude =
            (latitude < -90.0 ? -90.0 : (90.0 < latitude ? 90.0 : latitude)),
        longitude = (longitude + 180.0) % 360.0 - 180.0;

  /// The latitude in degrees between -90.0 and 90.0, both inclusive.
  final double latitude;

  /// The longitude in degrees between -180.0 (inclusive) and 180.0 (exclusive).
  final double longitude;

  @override
  String toString() => '$runtimeType($latitude, $longitude)';

  static LatLng fromAppleLatLng(appleMaps.LatLng latLng) =>
      LatLng(latLng.latitude, latLng.longitude);

  static LatLng fromGoogleLatLng(googleMapsInterface.LatLng latLng) =>
      LatLng(latLng.latitude, latLng.longitude);

  appleMaps.LatLng get appleLatLng => appleMaps.LatLng(
        this.latitude,
        this.longitude,
      );

  googleMapsInterface.LatLng get googleLatLng => googleMapsInterface.LatLng(
        this.latitude,
        this.longitude,
      );

  static List<googleMapsInterface.LatLng> googleMapsLatLngsFromList(
      List<LatLng> latlngs) {
    List<googleMapsInterface.LatLng> googleMapsLatLngs = [];
    latlngs.forEach((LatLng latlng) {
      googleMapsLatLngs.add(latlng.googleLatLng);
    });
    return googleMapsLatLngs;
  }

  static List<appleMaps.LatLng> appleMapsLatLngsFromList(List<LatLng> latlngs) {
    List<appleMaps.LatLng> appleMapsLatLngs = [];
    latlngs.forEach((LatLng latlng) {
      appleMapsLatLngs.add(latlng.appleLatLng);
    });
    return appleMapsLatLngs;
  }
}

class LatLngBounds {
  /// Creates geographical bounding box with the specified corners.
  ///
  /// The latitude of the southwest corner cannot be larger than the
  /// latitude of the northeast corner.
  LatLngBounds({required this.southwest, required this.northeast})
      : assert(southwest.latitude <= northeast.latitude);

  static LatLngBounds fromAppleLatLngBounds(appleMaps.LatLngBounds bounds) =>
      LatLngBounds(
        southwest: LatLng.fromAppleLatLng(bounds.southwest),
        northeast: LatLng.fromAppleLatLng(bounds.northeast),
      );

  static LatLngBounds fromGoogleLatLngBounds(
          googleMapsInterface.LatLngBounds bounds) =>
      LatLngBounds(
        southwest: LatLng.fromGoogleLatLng(bounds.southwest),
        northeast: LatLng.fromGoogleLatLng(bounds.northeast),
      );

  /// The southwest corner of the rectangle.
  final LatLng southwest;

  /// The northeast corner of the rectangle.
  final LatLng northeast;

  appleMaps.LatLngBounds get appleLatLngBounds => appleMaps.LatLngBounds(
        southwest: this.southwest.appleLatLng,
        northeast: this.northeast.appleLatLng,
      );

  googleMapsInterface.LatLngBounds get googleLatLngBounds =>
      googleMapsInterface.LatLngBounds(
        southwest: this.southwest.googleLatLng,
        northeast: this.northeast.googleLatLng,
      );

  bool contains(LatLng point) {
    return _containsLatitude(point.latitude) &&
        _containsLongitude(point.longitude);
  }

  bool _containsLatitude(double lat) {
    return (southwest.latitude <= lat) && (lat <= northeast.latitude);
  }

  bool _containsLongitude(double lng) {
    if (southwest.longitude <= northeast.longitude) {
      return southwest.longitude <= lng && lng <= northeast.longitude;
    } else {
      return southwest.longitude <= lng || lng <= northeast.longitude;
    }
  }
}
