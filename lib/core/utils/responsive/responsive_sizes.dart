import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Enterprise-grade responsive sizing package with multiple scaling strategies,
/// orientation handling, and platform-specific adaptations
class SizeConfig with WidgetsBindingObserver {
  static final SizeConfig _instance = SizeConfig._internal();
  factory SizeConfig() => _instance;
  SizeConfig._internal();

  static late MediaQueryData _mediaQueryData;
  static late Orientation _orientation;
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _refHeight;
  static late double _refWidth;
  static late bool _initialized;
  static late DeviceType _deviceType;

  // Define standard aspect ratio constraints
  static const double _maxAspectRatio = 2.1;  // Maximum height:width ratio
  static const double _minAspectRatio = 0.5;  // Minimum height:width ratio

  // Define base size constraints
  static const double _maxWidthScale = 1.5;   // Maximum width scaling factor
  static const double _maxHeightScale = 1.5;  // Maximum height scaling factor
  static const double _minWidthScale = 0.5;   // Minimum width scaling factor
  static const double _minHeightScale = 0.5;  // Minimum height scaling factor

  static final Map<DeviceType, Breakpoint> _breakpoints = {
    DeviceType.handset: const Breakpoint(minWidth: 0, maxWidth: 599),
    DeviceType.tablet: const Breakpoint(minWidth: 600, maxWidth: 1249),
    DeviceType.desktop: const Breakpoint(minWidth: 1250, maxWidth: double.infinity),
  };

  /// Initialize with context and optional reference resolution
  void init(
      BuildContext context, {
        double referenceHeight = 812,
        double referenceWidth = 375,
      }) {
    _mediaQueryData = MediaQuery.of(context);
    _orientation = _mediaQueryData.orientation;
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
    _refHeight = referenceHeight;
    _refWidth = referenceWidth;
    _initialized = true;
    _deviceType = _determineDeviceType();

    // Apply aspect ratio constraints
    _adjustScreenDimensions();

    // Register for orientation changes
    WidgetsBinding.instance.addObserver(this);
  }


  static void _adjustScreenDimensions() {
    final currentAspectRatio = _screenHeight / _screenWidth;

    if (currentAspectRatio > _maxAspectRatio) {
      // Screen is too tall, adjust height
      _screenHeight = _screenWidth * _maxAspectRatio;
    } else if (currentAspectRatio < _minAspectRatio) {
      // Screen is too wide, adjust height
      _screenHeight = _screenWidth * _minAspectRatio;
    }
  }

  /// Responsive width calculation with scaling constraints
  static double responsiveWidth(
      double value, {
        ScalingStrategy strategy = ScalingStrategy.fluid,
        double? maxWidth,
        double? minWidth,
      }) {
    _checkInitialization();

    final baseScale = _screenWidth / _refWidth;
    final constrainedScale = baseScale.clamp(_minWidthScale, _maxWidthScale);

    final calculatedWidth = _calculateWidth(value, strategy, constrainedScale);
    return calculatedWidth.clamp(
        minWidth ?? (value * _minWidthScale),
        maxWidth ?? (value * _maxWidthScale)
    );
  }

  static double _calculateWidth(double value, ScalingStrategy strategy, double constrainedScale) {
    switch (strategy) {
      case ScalingStrategy.fluid:
        return value * constrainedScale;
      case ScalingStrategy.verticalScale:
        final verticalScale = (_screenHeight / _refHeight).clamp(_minHeightScale, _maxHeightScale);
        return value * verticalScale;
      case ScalingStrategy.diagonalScale:
        final diagonal = math.sqrt(math.pow(_screenWidth, 2) + math.pow(_screenHeight, 2));
        final refDiagonal = math.sqrt(math.pow(_refWidth, 2) + math.pow(_refHeight, 2));
        final diagonalScale = (diagonal / refDiagonal).clamp(_minWidthScale, _maxWidthScale);
        return value * diagonalScale;
      default:
        return value;
    }
  }
  @override
  void didChangeMetrics() {
    final newWidth = WidgetsBinding.instance.window.physicalSize.width;
    final newHeight = WidgetsBinding.instance.window.physicalSize.height;
    final newOrientation = newWidth > newHeight ? Orientation.landscape : Orientation.portrait;

    if (newOrientation != _orientation) {
      _orientation = newOrientation;
      _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
      _screenHeight = WidgetsBinding.instance.window.physicalSize.height;
      _deviceType = _determineDeviceType();
    }
  }

  void _orientationListener() {
    if (_mediaQueryData.orientation != _orientation) {
      _orientation = _mediaQueryData.orientation;
      // Recalculate device type on orientation change
      _deviceType = _determineDeviceType();
    }
  }

  static DeviceType get deviceType => _deviceType;

  static DeviceType _determineDeviceType() {
    final width = math.max(_screenWidth, _screenHeight);
    return _breakpoints.entries
        .firstWhere((entry) => width >= entry.value.minWidth && width <= entry.value.maxWidth)
        .key;
  }


  /// Responsive height calculation with aspect ratio constraints
  static double responsiveHeight(
      double value, {
        double? maxHeight,
        double? minHeight,
      }) {
    _checkInitialization();

    final baseScale = _screenHeight / _refHeight;
    final constrainedScale = baseScale.clamp(_minHeightScale, _maxHeightScale);

    final calculatedHeight = value * constrainedScale;
    return calculatedHeight.clamp(
        minHeight ?? (value * _minHeightScale),
        maxHeight ?? (value * _maxHeightScale)
    );
  }

  /// Platform-aware safe area dimensions
  static EdgeInsets get safeAreaPadding {
    _checkInitialization();

    return EdgeInsets.only(
      top: _mediaQueryData.padding.top,
      bottom: _mediaQueryData.padding.bottom,
      left: _mediaQueryData.padding.left,
      right: _mediaQueryData.padding.right,
    );
  }

  /// Breakpoint system for responsive layouts
  static bool isBreakpointActive(Breakpoint breakpoint) {
    _checkInitialization();

    final width = math.max(_screenWidth, _screenHeight);
    return width >= breakpoint.minWidth && width <= breakpoint.maxWidth;
  }

  /// Percentage-based dimensions
  static double widthPercent(double percentage) => (_screenWidth * percentage) / 100;
  static double heightPercent(double percentage) => (_screenHeight * percentage) / 100;

  /// Diagnostic information
  static void debugPrintConfig() {
    _checkInitialization();

    debugPrint('''
      Responsive Configuration:
      - Screen Size: ${_screenWidth}x$_screenHeight
      - Effective Aspect Ratio: ${effectiveAspectRatio.toStringAsFixed(2)}
      - Orientation: $_orientation
      - Device Type: $_deviceType
      - Safe Area: ${safeAreaPadding.toString()}
      - Text Scale Factor: ${_mediaQueryData.textScaleFactor}
      - Width Scale: ${(_screenWidth / _refWidth).toStringAsFixed(2)}
      - Height Scale: ${(_screenHeight / _refHeight).toStringAsFixed(2)}
    ''');
  }
  static void _checkInitialization() {
    assert(_initialized, 'SizeConfig must be initialized with init() method');
  }

  /// Testing utility method
  static void mockValues({
    double width = 375,
    double height = 812,
    Orientation orientation = Orientation.portrait,
  }) {
    _screenWidth = width;
    _screenHeight = height;
    _orientation = orientation;
  }
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  static double adaptiveTextSize(
      double value, {
        double minScaleFactor = 0.8,
        double maxScaleFactor = 1.2,
      }) {
    _checkInitialization();

    // Use the geometric mean of width and height scales for balanced text scaling
    final widthScale = (_screenWidth / _refWidth).clamp(_minWidthScale, _maxWidthScale);
    final heightScale = (_screenHeight / _refHeight).clamp(_minHeightScale, _maxHeightScale);
    final balancedScale = math.sqrt(widthScale * heightScale);

    final scaleFactor = balancedScale.clamp(minScaleFactor, maxScaleFactor);
    return value * scaleFactor * _mediaQueryData.textScaleFactor;
  }

  static double maintainAspectRatio(double originalWidth, double originalHeight) {
    _checkInitialization();

    final aspectRatio = (originalWidth / originalHeight)
        .clamp(_minAspectRatio, _maxAspectRatio);
    return _screenWidth / aspectRatio;
  }

  // ... (rest of the existing methods remain the same)

  /// Helper method to get the effective aspect ratio
  static double get effectiveAspectRatio => _screenHeight / _screenWidth;

}

/// Extension methods for direct widget property assignment
extension ResponsiveExtensions on num {
  // Width-related extensions with constraints
  double get w => SizeConfig.responsiveWidth(toDouble());
  double get wp => SizeConfig.widthPercent(toDouble()).clamp(0, 100);
  double get cw => SizeConfig.maintainAspectRatio(toDouble(), 1);

  // Height-related extensions with constraints
  double get h => SizeConfig.responsiveHeight(toDouble());
  double get hp => SizeConfig.heightPercent(toDouble()).clamp(0, 100);
  double get ch => SizeConfig.maintainAspectRatio(1, toDouble());

  // Balanced text scaling
  double get sp => SizeConfig.adaptiveTextSize(toDouble());
  double get minSp => SizeConfig.adaptiveTextSize(toDouble(), minScaleFactor: 1);
  double get maxSp => SizeConfig.adaptiveTextSize(toDouble(), maxScaleFactor: 1.5);
}

/// Helper class for breakpoint definitions
class Breakpoint {
  final double minWidth;
  final double maxWidth;

  const Breakpoint({
    required this.minWidth,
    required this.maxWidth,
  });
}

enum DeviceType { handset, tablet, desktop }
enum ScalingStrategy { fluid, verticalScale, diagonalScale }
