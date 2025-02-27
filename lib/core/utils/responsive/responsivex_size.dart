import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A utility class that handles responsive sizing and scaling for Flutter applications.
/// This class provides methods to calculate sizes based on screen dimensions and
/// reference design specifications.
class SizeConfig {
  // Singleton pattern implementation
  static final SizeConfig _instance = SizeConfig._internal();
  factory SizeConfig() => _instance;
  SizeConfig._internal();

  // Media Query Data
  static late MediaQueryData _mediaQueryData;

  // Screen dimensions
  static late double screenWidth;
  static late double screenHeight;
  static late double devicePixelRatio;

  // Block sizes for responsive calculations
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  // Safe area dimensions
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  // Reference design dimensions
  static late double refHeight;
  static late double refWidth;

  // Orientation
  static late Orientation orientation;

  // Status bar height
  static late double statusBarHeight;

  // Bottom padding (for devices with notch)
  static late double bottomPadding;

  // Screen type
  static late ScreenType screenType;

  /// Initialize the configuration with BuildContext
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    devicePixelRatio = _mediaQueryData.devicePixelRatio;
    orientation = _mediaQueryData.orientation;
    statusBarHeight = _mediaQueryData.padding.top;
    bottomPadding = _mediaQueryData.padding.bottom;

    // Default reference dimensions (iPhone X dimensions)
    refHeight = 812;
    refWidth = 375;

    // Set screen type
    screenType = _getScreenType(screenWidth);

    // Calculate block sizes based on screen size
    if (screenHeight < 1200) {
      blockSizeHorizontal = screenWidth / 100;
      blockSizeVertical = screenHeight / 100;
    } else {
      blockSizeHorizontal = screenWidth / 120;
      blockSizeVertical = screenHeight / 120;
    }

    // Calculate safe area dimensions
    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    // Calculate safe block sizes
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  /// Set custom reference dimensions
  void setReferenceSize({double? width, double? height}) {
    if (width != null) refWidth = width;
    if (height != null) refHeight = height;
  }

  /// Get width ratio based on reference width
  static double getWidthRatio(double val) {
    double res = (val / refWidth) * 100;
    return res * blockSizeHorizontal;
  }

  /// Get height ratio based on reference height
  static double getHeightRatio(double val) {
    double res = (val / refHeight) * 100;
    return res * blockSizeVertical;
  }

  /// Get adaptive text size that scales with screen size
  static double getAdaptiveTextSize(double value) {
    double scaleFactor = math.min(screenWidth / refWidth, screenHeight / refHeight);
    return value * scaleFactor;
  }

  /// Check if device is in landscape mode
  static bool isLandscape() => orientation == Orientation.landscape;

  /// Get screen type based on width
  static ScreenType _getScreenType(double width) {
    if (width >= 1200) return ScreenType.desktop;
    if (width >= 600) return ScreenType.tablet;
    return ScreenType.mobile;
  }

  /// Get responsive value based on screen type
  static T getResponsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (screenType) {
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.mobile:
        return mobile;
    }
  }
}

/// Screen types for responsive design
enum ScreenType {
  mobile,
  tablet,
  desktop,
}

/// Extension for width calculations
class W {
  static double get(double val) => SizeConfig.getWidthRatio(val);
}

/// Extension for height calculations
class H {
  static double get(double val) => SizeConfig.getHeightRatio(val);
}

/// Extension for text size calculations
class SP {
  static double get(double val) => SizeConfig.getAdaptiveTextSize(val);
}

/// Extension methods for easy access to responsive sizes
extension SizeExtension on num {
  /// Get responsive width
  double get w => W.get(toDouble());

  /// Get responsive height
  double get h => H.get(toDouble());

  /// Get responsive text size
  double get sp => SP.get(toDouble());

  /// Get responsive size based on smallest screen dimension
  double get r => math.min(w, h);
}

/// Widget extension for responsive builder
extension ResponsiveWidgetExtension on Widget {
  /// Wrap widget with responsive builder
  Widget responsive({
    Widget Function(BuildContext, Widget?)? mobile,
    Widget Function(BuildContext, Widget?)? tablet,
    Widget Function(BuildContext, Widget?)? desktop,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final screenType = SizeConfig._getScreenType(width);

        switch (screenType) {
          case ScreenType.desktop:
            return desktop?.call(context, this) ??
                tablet?.call(context, this) ??
                mobile?.call(context, this) ??
                this;
          case ScreenType.tablet:
            return tablet?.call(context, this) ??
                mobile?.call(context, this) ??
                this;
          case ScreenType.mobile:
            return mobile?.call(context, this) ?? this;
        }
      },
    );
  }
}

/// Mixin for responsive state management
mixin ResponsiveStateMixin<T extends StatefulWidget> on State<T> {
  @override
  void didChangeDependencies() {
    SizeConfig().init(context);
    super.didChangeDependencies();
  }
}



//-----------------------  USAGE EXAMPLE  ------------------------------------------------


// Initialize in your main app widget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ResponsiveStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Using the responsive extensions
        body: Container(
          width: 100.w,    // Responsive width
          height: 50.h,    // Responsive height
          padding: EdgeInsets.all(10.r),  // Responsive padding
          child: Text(
            'Hello',
            style: TextStyle(fontSize: 16.sp),  // Responsive text size
          ),
        ).responsive(  // Using responsive builder
          mobile: (context, child) => child!,
          tablet: (context, child) => Center(child: child),
          desktop: (context, child) => Align(child: child),
        ),
      ),
    );
  }
}