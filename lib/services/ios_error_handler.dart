import 'package:flutter/material.dart';
import '../widgets/ios_modals.dart';
import '../widgets/ios_empty_states.dart';
import 'haptic_service.dart';

/// iOS-style error handling service
class IOSErrorHandler {
  static const IOSErrorHandler _instance = IOSErrorHandler._internal();
  factory IOSErrorHandler() => _instance;
  const IOSErrorHandler._internal();

  /// Show iOS-style error alert
  static Future<void> showErrorAlert({
    required BuildContext context,
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
  }) async {
    HapticService.error();
    
    await IOSAlert.show(
      context: context,
      title: title,
      message: message,
      actions: [
        if (actionText != null && onAction != null)
          IOSAlertAction(
            text: actionText,
            onPressed: onAction,
            isDefault: true,
          ),
        IOSAlertAction(
          text: 'OK',
          onPressed: () {},
          isDefault: actionText == null,
        ),
      ],
    );
  }

  /// Show iOS-style network error
  static Future<void> showNetworkError({
    required BuildContext context,
    VoidCallback? onRetry,
  }) async {
    await showErrorAlert(
      context: context,
      title: 'Connection Problem',
      message: 'Please check your internet connection and try again.',
      actionText: onRetry != null ? 'Try Again' : null,
      onAction: onRetry,
    );
  }

  /// Show iOS-style server error
  static Future<void> showServerError({
    required BuildContext context,
    VoidCallback? onRetry,
  }) async {
    await showErrorAlert(
      context: context,
      title: 'Server Error',
      message: 'We\'re having trouble connecting to our servers. Please try again in a moment.',
      actionText: onRetry != null ? 'Retry' : null,
      onAction: onRetry,
    );
  }

  /// Show iOS-style validation error
  static Future<void> showValidationError({
    required BuildContext context,
    required String message,
  }) async {
    HapticService.warning();
    
    await IOSAlert.show(
      context: context,
      title: 'Invalid Input',
      message: message,
      actions: [
        IOSAlertAction(
          text: 'OK',
          onPressed: () {},
          isDefault: true,
        ),
      ],
    );
  }

  /// Show iOS-style permission error
  static Future<void> showPermissionError({
    required BuildContext context,
    required String permission,
    VoidCallback? onOpenSettings,
  }) async {
    await showErrorAlert(
      context: context,
      title: 'Permission Required',
      message: 'This feature requires $permission permission. Please enable it in Settings to continue.',
      actionText: onOpenSettings != null ? 'Open Settings' : null,
      onAction: onOpenSettings,
    );
  }

  /// Show iOS-style confirmation dialog
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    HapticService.warning();
    
    bool? result = await IOSAlert.show<bool>(
      context: context,
      title: title,
      message: message,
      actions: [
        IOSAlertAction(
          text: cancelText,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        IOSAlertAction(
          text: confirmText,
          onPressed: () => Navigator.of(context).pop(true),
          isDestructive: isDestructive,
          isDefault: !isDestructive,
        ),
      ],
    );
    
    return result ?? false;
  }

  /// Show iOS-style action sheet for multiple options
  static Future<T?> showActionSheet<T>({
    required BuildContext context,
    String? title,
    String? message,
    required List<IOSActionSheetOption<T>> options,
    String cancelText = 'Cancel',
  }) async {
    return await IOSActionSheet.show<T>(
      context: context,
      title: title,
      message: message,
      actions: options.map((option) => IOSActionSheetAction(
        text: option.text,
        onPressed: () => Navigator.of(context).pop(option.value),
        isDestructive: option.isDestructive,
        isDefault: option.isDefault,
      )).toList(),
      cancelAction: IOSActionSheetAction(
        text: cancelText,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Handle common errors with appropriate UI
  static Widget handleError({
    required Object error,
    VoidCallback? onRetry,
  }) {
    if (error is NetworkException) {
      return IOSEmptyStates.networkError(onRetry: onRetry);
    } else if (error is ServerException) {
      return IOSEmptyStates.serverError(onRetry: onRetry);
    } else if (error is PermissionException) {
      return IOSEmptyStates.permissionDenied(
        permission: error.permission,
        onOpenSettings: error.onOpenSettings,
      );
    } else {
      return IOSEmptyStates.serverError(onRetry: onRetry);
    }
  }

  /// Show success message
  static void showSuccessMessage({
    required BuildContext context,
    required String message,
  }) {
    HapticService.success();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(0xFF34C759),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1C1C1E)
            : Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show warning message
  static void showWarningMessage({
    required BuildContext context,
    required String message,
  }) {
    HapticService.warning();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_rounded,
              color: Color(0xFFFF9500),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1C1C1E)
            : Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show error message
  static void showErrorMessage({
    required BuildContext context,
    required String message,
  }) {
    HapticService.error();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_rounded,
              color: Color(0xFFFF3B30),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1C1C1E)
            : Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

/// Action sheet option model
class IOSActionSheetOption<T> {
  final String text;
  final T value;
  final bool isDestructive;
  final bool isDefault;

  const IOSActionSheetOption({
    required this.text,
    required this.value,
    this.isDestructive = false,
    this.isDefault = false,
  });
}

/// Custom exception classes for better error handling
class NetworkException implements Exception {
  final String message;
  
  const NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  
  const ServerException(this.message, {this.statusCode});
  
  @override
  String toString() => 'ServerException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;
  
  const ValidationException(this.message, {this.fieldErrors});
  
  @override
  String toString() => 'ValidationException: $message';
}

class PermissionException implements Exception {
  final String permission;
  final VoidCallback? onOpenSettings;
  
  const PermissionException(this.permission, {this.onOpenSettings});
  
  @override
  String toString() => 'PermissionException: $permission permission required';
}

class AuthException implements Exception {
  final String message;
  
  const AuthException(this.message);
  
  @override
  String toString() => 'AuthException: $message';
}

/// iOS-style error boundary widget
class IOSErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, VoidCallback retry)? errorBuilder;
  final void Function(Object error, StackTrace stackTrace)? onError;

  const IOSErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<IOSErrorBoundary> createState() => _IOSErrorBoundaryState();
}

class _IOSErrorBoundaryState extends State<IOSErrorBoundary> {
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!, _retry) ??
          IOSErrorHandler.handleError(
            error: _error!,
            onRetry: _retry,
          );
    }

    return widget.child;
  }

  void _retry() {
    setState(() {
      _error = null;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ErrorWidget.builder = (FlutterErrorDetails details) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _error = details.exception;
          });
          widget.onError?.call(details.exception, details.stack ?? StackTrace.empty);
        }
      });
      return const SizedBox.shrink();
    };
  }
}