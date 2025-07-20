import 'package:flutter/material.dart';
import '../services/haptic_service.dart';

/// iOS-style list tile component
class IOSListTile extends StatefulWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final bool showChevron;
  final Color? backgroundColor;
  final bool isFirst;
  final bool isLast;

  const IOSListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.showChevron = false,
    this.backgroundColor,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  State<IOSListTile> createState() => _IOSListTileState();
}

class _IOSListTileState extends State<IOSListTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = widget.backgroundColor ?? 
        (isDark ? const Color(0xFF1C1C1E) : Colors.white);
    
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) {
        setState(() => _isPressed = true);
      } : null,
      onTapUp: widget.onTap != null ? (_) {
        setState(() => _isPressed = false);
        HapticService.lightImpact();
        widget.onTap!();
      } : null,
      onTapCancel: widget.onTap != null ? () {
        setState(() => _isPressed = false);
      } : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isPressed 
              ? (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7))
              : backgroundColor,
          border: Border(
            top: widget.isFirst ? BorderSide.none : BorderSide(
              color: isDark ? const Color(0xFF38383A) : const Color(0xFFE5E5EA),
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: widget.contentPadding ?? 
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Leading
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 12),
              ],
              
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.title != null)
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        child: widget.title!,
                      ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 2),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF6D6D70),
                        ),
                        child: widget.subtitle!,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Trailing
              if (widget.trailing != null) ...[
                const SizedBox(width: 12),
                widget.trailing!,
              ],
              
              // Chevron
              if (widget.showChevron) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF6D6D70),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// iOS-style grouped list section
class IOSListSection extends StatelessWidget {
  final String? header;
  final String? footer;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;

  const IOSListSection({
    super.key,
    this.header,
    this.footer,
    required this.children,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          if (header != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                header!.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF6D6D70),
                ),
              ),
            ),
          
          // List items
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: children.asMap().entries.map((entry) {
                final index = entry.key;
                final child = entry.value;
                
                if (child is IOSListTile) {
                  return IOSListTile(
                    leading: child.leading,
                    title: child.title,
                    subtitle: child.subtitle,
                    trailing: child.trailing,
                    onTap: child.onTap,
                    contentPadding: child.contentPadding,
                    showChevron: child.showChevron,
                    backgroundColor: child.backgroundColor,
                    isFirst: index == 0,
                    isLast: index == children.length - 1,
                  );
                }
                return child;
              }).toList(),
            ),
          ),
          
          // Footer
          if (footer != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                footer!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF6D6D70),
                ),
              ),
            ),
        ],
      ),
    );
  }
}