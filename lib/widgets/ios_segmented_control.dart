import 'package:flutter/material.dart';
import '../services/haptic_service.dart';

/// iOS-style segmented control component
class IOSSegmentedControl<T> extends StatefulWidget {
  final Map<T, String> children;
  final T? selectedValue;
  final ValueChanged<T>? onValueChanged;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final EdgeInsetsGeometry? padding;

  const IOSSegmentedControl({
    super.key,
    required this.children,
    this.selectedValue,
    this.onValueChanged,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.padding,
  });

  @override
  State<IOSSegmentedControl<T>> createState() => _IOSSegmentedControlState<T>();
}

class _IOSSegmentedControlState<T> extends State<IOSSegmentedControl<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSelection(T value) {
    if (widget.selectedValue != value) {
      HapticService.selectionClick();
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      widget.onValueChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = widget.backgroundColor ?? 
        (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7));
    final selectedColor = widget.selectedColor ?? 
        (isDark ? const Color(0xFF1C1C1E) : Colors.white);
    final unselectedColor = widget.unselectedColor ?? Colors.transparent;

    return Container(
      padding: widget.padding ?? const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.children.entries.map((entry) {
          final isSelected = widget.selectedValue == entry.key;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => _handleSelection(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? selectedColor : unselectedColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ] : null,
                ),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isSelected && _animation.value > 0 
                          ? 1.0 + (_animation.value * 0.05) 
                          : 1.0,
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected 
                              ? (isDark ? Colors.white : Colors.black)
                              : (isDark ? const Color(0xFF8E8E93) : const Color(0xFF6D6D70)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}