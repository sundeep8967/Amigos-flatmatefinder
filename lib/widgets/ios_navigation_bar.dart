import 'package:flutter/material.dart';
import '../services/haptic_service.dart';

/// iOS-style navigation bar component
class IOSNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool centerTitle;
  final double elevation;
  final Widget? titleWidget;

  const IOSNavigationBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = true,
    this.elevation = 0,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ?? 
        (isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7));
    final fgColor = foregroundColor ?? 
        (isDark ? Colors.white : Colors.black);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: isDark 
                ? const Color(0xFF38383A) 
                : const Color(0xFFE5E5EA),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Leading
              if (leading != null)
                leading!
              else if (automaticallyImplyLeading && Navigator.canPop(context))
                IOSBackButton(color: fgColor),
              
              // Title
              Expanded(
                child: titleWidget ?? (title != null 
                    ? Text(
                        title!,
                        textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: fgColor,
                        ),
                      )
                    : const SizedBox.shrink()),
              ),
              
              // Actions
              if (actions != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44 + 44); // 44 for status bar + 44 for nav bar
}

/// iOS-style back button
class IOSBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const IOSBackButton({
    super.key,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.lightImpact();
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: color ?? const Color(0xFF007AFF),
            ),
            Text(
              'Back',
              style: TextStyle(
                fontSize: 17,
                color: color ?? const Color(0xFF007AFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// iOS-style navigation action button
class IOSNavigationAction extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final FontWeight fontWeight;

  const IOSNavigationAction({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.lightImpact();
        onPressed?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17,
            fontWeight: fontWeight,
            color: color ?? const Color(0xFF007AFF),
          ),
        ),
      ),
    );
  }
}