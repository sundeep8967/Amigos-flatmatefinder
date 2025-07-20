import 'package:flutter/material.dart';
import '../services/haptic_service.dart';

enum IOSButtonStyle {
  filled,    // Primary blue filled button
  tinted,    // Tinted background with colored text
  plain,     // Plain text button
  destructive, // Red destructive button
}

class IOSStyleButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IOSButtonStyle style;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const IOSStyleButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = IOSButtonStyle.filled,
    this.isLoading = false,
    this.icon,
    this.width,
    this.padding,
  });

  @override
  State<IOSStyleButton> createState() => _IOSStyleButtonState();
}

class _IOSStyleButtonState extends State<IOSStyleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown() {
    _animationController.forward();
  }

  void _handleTapUp() {
    _animationController.reverse();
    if (widget.onPressed != null) {
      HapticService.buttonPress();
      widget.onPressed!();
    }
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SizedBox(
      width: widget.width,
      child: GestureDetector(
        onTapDown: widget.isLoading ? null : (_) => _handleTapDown(),
        onTapUp: widget.isLoading ? null : (_) => _handleTapUp(),
        onTapCancel: widget.isLoading ? null : _handleTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: _getButtonDecoration(isDark),
                child: widget.isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getTextColor(isDark),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(widget.icon, size: 18, color: _getTextColor(isDark)),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: _getTextColor(isDark),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  BoxDecoration _getButtonDecoration(bool isDark) {
    switch (widget.style) {
      case IOSButtonStyle.filled:
        return BoxDecoration(
          color: const Color(0xFF007AFF),
          borderRadius: BorderRadius.circular(14),
        );
      
      case IOSButtonStyle.tinted:
        return BoxDecoration(
          color: isDark 
              ? const Color(0xFF1C1C1E) 
              : const Color(0xFF007AFF).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        );
      
      case IOSButtonStyle.plain:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        );
      
      case IOSButtonStyle.destructive:
        return BoxDecoration(
          color: isDark 
              ? const Color(0xFF1C1C1E) 
              : const Color(0xFFFF3B30).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        );
    }
  }

  Color _getTextColor(bool isDark) {
    switch (widget.style) {
      case IOSButtonStyle.filled:
        return Colors.white;
      
      case IOSButtonStyle.tinted:
        return const Color(0xFF007AFF);
      
      case IOSButtonStyle.plain:
        return const Color(0xFF007AFF);
      
      case IOSButtonStyle.destructive:
        return const Color(0xFFFF3B30);
    }
  }
}