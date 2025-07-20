import 'package:flutter/material.dart';

/// iOS-style loading spinner
class IOSLoadingSpinner extends StatefulWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const IOSLoadingSpinner({
    super.key,
    this.size = 20,
    this.color,
    this.strokeWidth = 2,
  });

  @override
  State<IOSLoadingSpinner> createState() => _IOSLoadingSpinnerState();
}

class _IOSLoadingSpinnerState extends State<IOSLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CircularProgressIndicator(
            value: null,
            strokeWidth: widget.strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.color ?? 
              (isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93)),
            ),
          );
        },
      ),
    );
  }
}

/// iOS-style skeleton loader
class IOSSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const IOSSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<IOSSkeleton> createState() => _IOSSkeletonState();
}

class _IOSSkeletonState extends State<IOSSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final baseColor = widget.baseColor ?? 
        (isDark ? const Color(0xFF1C1C1E) : const Color(0xFFE5E5EA));
    final highlightColor = widget.highlightColor ?? 
        (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7));

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  baseColor,
                  highlightColor,
                  baseColor,
                ],
                stops: [
                  _animation.value - 0.3,
                  _animation.value,
                  _animation.value + 0.3,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// iOS-style skeleton for text lines
class IOSTextSkeleton extends StatelessWidget {
  final int lines;
  final double lineHeight;
  final double spacing;
  final double? lastLineWidth;

  const IOSTextSkeleton({
    super.key,
    this.lines = 3,
    this.lineHeight = 16,
    this.spacing = 8,
    this.lastLineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLastLine = index == lines - 1;
        final width = isLastLine && lastLineWidth != null 
            ? lastLineWidth! 
            : double.infinity;
            
        return Padding(
          padding: EdgeInsets.only(bottom: index < lines - 1 ? spacing : 0),
          child: IOSSkeleton(
            width: width,
            height: lineHeight,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// iOS-style skeleton for list items
class IOSListItemSkeleton extends StatelessWidget {
  final bool hasAvatar;
  final bool hasTrailing;
  final double avatarSize;

  const IOSListItemSkeleton({
    super.key,
    this.hasAvatar = true,
    this.hasTrailing = false,
    this.avatarSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (hasAvatar) ...[
            IOSSkeleton(
              width: avatarSize,
              height: avatarSize,
              borderRadius: BorderRadius.circular(avatarSize / 2),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IOSSkeleton(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 6),
                IOSSkeleton(
                  width: 200,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          if (hasTrailing) ...[
            const SizedBox(width: 12),
            IOSSkeleton(
              width: 24,
              height: 24,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ],
      ),
    );
  }
}

/// iOS-style skeleton for cards
class IOSCardSkeleton extends StatelessWidget {
  final double height;
  final bool hasImage;
  final double imageHeight;

  const IOSCardSkeleton({
    super.key,
    this.height = 200,
    this.hasImage = true,
    this.imageHeight = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage)
            IOSSkeleton(
              width: double.infinity,
              height: imageHeight,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IOSSkeleton(
                  width: double.infinity,
                  height: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                IOSSkeleton(
                  width: 150,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 12),
                IOSTextSkeleton(
                  lines: 2,
                  lineHeight: 14,
                  lastLineWidth: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// iOS-style loading overlay
class IOSLoadingOverlay extends StatelessWidget {
  final String? message;
  final bool isVisible;

  const IOSLoadingOverlay({
    super.key,
    this.message,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1C1C1E)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const IOSLoadingSpinner(size: 32),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// iOS-style pull-to-refresh indicator
class IOSPullToRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const IOSPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: const Color(0xFF007AFF),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1C1C1E)
          : Colors.white,
      child: child,
    );
  }
}

/// iOS-style skeleton list
class IOSSkeletonList extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index)? itemBuilder;
  final bool hasAvatar;
  final bool hasTrailing;

  const IOSSkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemBuilder,
    this.hasAvatar = true,
    this.hasTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return itemBuilder?.call(index) ?? 
            IOSListItemSkeleton(
              hasAvatar: hasAvatar,
              hasTrailing: hasTrailing,
            );
      },
    );
  }
}