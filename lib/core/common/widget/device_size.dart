class DeviceSize {
  static double? _width;
  static double? _height;

  DeviceSize({required double width, required double height}) {
    _width = width;
    _height = height;
  }

  // getter methods for widht and height
  static double get height => _height!;
  static double get width => _width!;
}
