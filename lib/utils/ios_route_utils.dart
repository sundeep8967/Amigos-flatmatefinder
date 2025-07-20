import 'package:flutter/material.dart';
import '../widgets/ios_spring_animation.dart';

/// Utility class for iOS-style navigation
class IOSRouteUtils {
  /// Push a new screen with iOS-style animation
  static Future<T?> push<T>(BuildContext context, Widget screen) {
    return Navigator.of(context).push<T>(
      IOSSpringPageRoute<T>(child: screen),
    );
  }

  /// Present a modal with iOS-style animation
  static Future<T?> presentModal<T>(BuildContext context, Widget screen) {
    return Navigator.of(context).push<T>(
      IOSModalRoute<T>(child: screen),
    );
  }

  /// Pop with haptic feedback
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop<T>(result);
  }

  /// Replace current screen with iOS-style animation
  static Future<T?> pushReplacement<T, TO>(
    BuildContext context, 
    Widget screen,
  ) {
    return Navigator.of(context).pushReplacement<T, TO>(
      IOSSpringPageRoute<T>(child: screen),
    );
  }

  /// Push and remove all previous routes
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget screen,
    bool Function(Route<dynamic>) predicate,
  ) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      IOSSpringPageRoute<T>(child: screen),
      predicate,
    );
  }
}