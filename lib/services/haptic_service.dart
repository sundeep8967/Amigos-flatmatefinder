import 'package:flutter/services.dart';

class HapticService {
  static const HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  const HapticService._internal();

  /// Light haptic feedback - for subtle interactions like button taps
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium haptic feedback - for standard interactions like selections
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy haptic feedback - for important actions like confirmations
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection haptic feedback - for picker wheels and toggles
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Success haptic feedback - for successful operations
  static Future<void> success() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  /// Error haptic feedback - for errors and failures
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Warning haptic feedback - for warnings and alerts
  static Future<void> warning() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  /// Notification haptic feedback - for incoming messages/notifications
  static Future<void> notification() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 30));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 30));
    await HapticFeedback.lightImpact();
  }

  /// Button press haptic feedback - for button interactions
  static Future<void> buttonPress() async {
    await HapticFeedback.lightImpact();
  }

  /// Toggle haptic feedback - for switches and toggles
  static Future<void> toggle() async {
    await HapticFeedback.selectionClick();
  }

  /// Swipe haptic feedback - for swipe gestures
  static Future<void> swipe() async {
    await HapticFeedback.lightImpact();
  }

  /// Long press haptic feedback - for long press interactions
  static Future<void> longPress() async {
    await HapticFeedback.mediumImpact();
  }

  /// Refresh haptic feedback - for pull-to-refresh
  static Future<void> refresh() async {
    await HapticFeedback.mediumImpact();
  }
}