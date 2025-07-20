import 'package:flutter/material.dart';
import '../services/haptic_service.dart';

/// iOS-style action sheet
class IOSActionSheet extends StatelessWidget {
  final String? title;
  final String? message;
  final List<IOSActionSheetAction> actions;
  final IOSActionSheetAction? cancelAction;

  const IOSActionSheet({
    super.key,
    this.title,
    this.message,
    required this.actions,
    this.cancelAction,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    required List<IOSActionSheetAction> actions,
    IOSActionSheetAction? cancelAction,
  }) {
    HapticService.mediumImpact();
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => IOSActionSheet(
        title: title,
        message: message,
        actions: actions,
        cancelAction: cancelAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main action sheet
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                if (title != null || message != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark 
                                  ? const Color(0xFF8E8E93) 
                                  : const Color(0xFF8E8E93),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        if (title != null && message != null)
                          const SizedBox(height: 4),
                        if (message != null)
                          Text(
                            message!,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark 
                                  ? const Color(0xFF8E8E93) 
                                  : const Color(0xFF8E8E93),
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: isDark 
                        ? const Color(0xFF38383A) 
                        : const Color(0xFFE5E5EA),
                  ),
                ],
                ...actions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final action = entry.value;
                  return Column(
                    children: [
                      _buildActionButton(context, action),
                      if (index < actions.length - 1)
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: isDark 
                              ? const Color(0xFF38383A) 
                              : const Color(0xFFE5E5EA),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
          
          if (cancelAction != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _buildActionButton(context, cancelAction!),
            ),
          ],
          
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IOSActionSheetAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.lightImpact();
          Navigator.of(context).pop();
          action.onPressed?.call();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            action.text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: action.isDestructive 
                  ? FontWeight.w400 
                  : action.isDefault 
                      ? FontWeight.w600 
                      : FontWeight.w400,
              color: action.isDestructive 
                  ? const Color(0xFFFF3B30)
                  : action.isDefault
                      ? const Color(0xFF007AFF)
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF1C1C1E),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class IOSActionSheetAction {
  final String text;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isDefault;

  const IOSActionSheetAction({
    required this.text,
    this.onPressed,
    this.isDestructive = false,
    this.isDefault = false,
  });
}

/// iOS-style alert dialog
class IOSAlert extends StatelessWidget {
  final String title;
  final String? message;
  final List<IOSAlertAction> actions;

  const IOSAlert({
    super.key,
    required this.title,
    this.message,
    required this.actions,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? message,
    required List<IOSAlertAction> actions,
  }) {
    HapticService.warning();
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => IOSAlert(
        title: title,
        message: message,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 270,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      message!,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark 
                            ? const Color(0xFF8E8E93) 
                            : const Color(0xFF8E8E93),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: isDark 
                  ? const Color(0xFF38383A) 
                  : const Color(0xFFE5E5EA),
            ),
            if (actions.length == 1)
              _buildSingleAction(context, actions.first)
            else
              _buildMultipleActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleAction(BuildContext context, IOSAlertAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.lightImpact();
          Navigator.of(context).pop();
          action.onPressed?.call();
        },
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            action.text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: action.isDefault ? FontWeight.w600 : FontWeight.w400,
              color: action.isDestructive 
                  ? const Color(0xFFFF3B30)
                  : const Color(0xFF007AFF),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleActions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (actions.length == 2) {
      return Row(
        children: [
          Expanded(child: _buildActionButton(context, actions[0])),
          Container(
            width: 0.5,
            height: 44,
            color: isDark 
                ? const Color(0xFF38383A) 
                : const Color(0xFFE5E5EA),
          ),
          Expanded(child: _buildActionButton(context, actions[1])),
        ],
      );
    } else {
      return Column(
        children: actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          return Column(
            children: [
              _buildActionButton(context, action),
              if (index < actions.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: isDark 
                      ? const Color(0xFF38383A) 
                      : const Color(0xFFE5E5EA),
                ),
            ],
          );
        }).toList(),
      );
    }
  }

  Widget _buildActionButton(BuildContext context, IOSAlertAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.lightImpact();
          Navigator.of(context).pop();
          action.onPressed?.call();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            action.text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: action.isDefault ? FontWeight.w600 : FontWeight.w400,
              color: action.isDestructive 
                  ? const Color(0xFFFF3B30)
                  : const Color(0xFF007AFF),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class IOSAlertAction {
  final String text;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isDefault;

  const IOSAlertAction({
    required this.text,
    this.onPressed,
    this.isDestructive = false,
    this.isDefault = false,
  });
}

/// iOS-style modal presentation
class IOSModal extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const IOSModal({
    super.key,
    required this.child,
    this.title,
    this.showCloseButton = true,
    this.onClose,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool showCloseButton = true,
    VoidCallback? onClose,
  }) {
    HapticService.mediumImpact();
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => IOSModal(
        title: title,
        showCloseButton: showCloseButton,
        onClose: onClose,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 36,
            height: 5,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: isDark 
                  ? const Color(0xFF8E8E93) 
                  : const Color(0xFFE5E5EA),
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          
          // Header
          if (title != null || showCloseButton)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                      ),
                    )
                  else
                    const SizedBox(),
                  if (showCloseButton)
                    GestureDetector(
                      onTap: () {
                        HapticService.lightImpact();
                        Navigator.of(context).pop();
                        onClose?.call();
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isDark 
                              ? const Color(0xFF1C1C1E) 
                              : const Color(0xFFE5E5EA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: isDark 
                              ? const Color(0xFF8E8E93) 
                              : const Color(0xFF8E8E93),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          
          // Content
          Expanded(child: child),
        ],
      ),
    );
  }
}