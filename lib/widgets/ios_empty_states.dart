import 'package:flutter/material.dart';
import 'ios_style_button.dart';

/// iOS-style empty state widget
class IOSEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Color? iconColor;
  final double iconSize;
  final Widget? customIcon;

  const IOSEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onButtonPressed,
    this.iconColor,
    this.iconSize = 64,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            customIcon ?? Icon(
              icon,
              size: iconSize,
              color: iconColor ?? 
                  (isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93)),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1C1C1E),
              ),
              textAlign: TextAlign.center,
            ),
            
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 17,
                  color: isDark 
                      ? const Color(0xFF8E8E93) 
                      : const Color(0xFF8E8E93),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 32),
              IOSStyleButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                style: IOSButtonStyle.filled,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Predefined empty states for common scenarios
class IOSEmptyStates {
  
  /// Empty search results
  static Widget searchResults({
    String? searchQuery,
    VoidCallback? onClearSearch,
  }) {
    return IOSEmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      subtitle: searchQuery != null 
          ? 'No results found for "$searchQuery".\nTry adjusting your search terms.'
          : 'Try searching with different keywords.',
      buttonText: searchQuery != null ? 'Clear Search' : null,
      onButtonPressed: onClearSearch,
    );
  }
  
  /// Empty flat listings
  static Widget flatListings({
    bool isHost = false,
    VoidCallback? onCreateListing,
    VoidCallback? onAdjustFilters,
  }) {
    if (isHost) {
      return IOSEmptyState(
        icon: Icons.home_outlined,
        title: 'No Listings Yet',
        subtitle: 'Create your first flat listing to start finding flatmates.',
        buttonText: 'Create Listing',
        onButtonPressed: onCreateListing,
      );
    } else {
      return IOSEmptyState(
        icon: Icons.search_outlined,
        title: 'No Flats Found',
        subtitle: 'No flats match your current filters.\nTry adjusting your search criteria.',
        buttonText: 'Adjust Filters',
        onButtonPressed: onAdjustFilters,
      );
    }
  }
  
  /// Empty chat list
  static Widget chatList({
    bool isHost = false,
    VoidCallback? onStartBrowsing,
  }) {
    return IOSEmptyState(
      icon: Icons.chat_bubble_outline,
      title: 'No Conversations',
      subtitle: isHost 
          ? 'When people request your flats, conversations will appear here.'
          : 'Start browsing flats and send requests to begin conversations.',
      buttonText: isHost ? null : 'Browse Flats',
      onButtonPressed: onStartBrowsing,
    );
  }
  
  /// Empty favorites
  static Widget favorites({
    VoidCallback? onStartBrowsing,
  }) {
    return IOSEmptyState(
      icon: Icons.favorite_outline,
      title: 'No Favorites Yet',
      subtitle: 'Save flats you like by tapping the heart icon.\nThey\'ll appear here for easy access.',
      buttonText: 'Browse Flats',
      onButtonPressed: onStartBrowsing,
    );
  }
  
  /// Empty requests
  static Widget requests({
    bool isHost = false,
    VoidCallback? onAction,
  }) {
    if (isHost) {
      return IOSEmptyState(
        icon: Icons.inbox_outlined,
        title: 'No Requests Yet',
        subtitle: 'When people are interested in your flats, their requests will appear here.',
      );
    } else {
      return IOSEmptyState(
        icon: Icons.send_outlined,
        title: 'No Requests Sent',
        subtitle: 'Browse flats and send requests to hosts you\'re interested in.',
        buttonText: 'Browse Flats',
        onButtonPressed: onAction,
      );
    }
  }
  
  /// Empty notifications
  static Widget notifications() {
    return IOSEmptyState(
      icon: Icons.notifications_none_outlined,
      title: 'No Notifications',
      subtitle: 'You\'re all caught up!\nNotifications will appear here when you have updates.',
    );
  }
  
  /// Network error
  static Widget networkError({
    VoidCallback? onRetry,
  }) {
    return IOSEmptyState(
      icon: Icons.wifi_off_outlined,
      title: 'Connection Problem',
      subtitle: 'Please check your internet connection and try again.',
      buttonText: 'Try Again',
      onButtonPressed: onRetry,
    );
  }
  
  /// Server error
  static Widget serverError({
    VoidCallback? onRetry,
  }) {
    return IOSEmptyState(
      icon: Icons.error_outline,
      title: 'Something Went Wrong',
      subtitle: 'We\'re having trouble loading this content.\nPlease try again in a moment.',
      buttonText: 'Retry',
      onButtonPressed: onRetry,
    );
  }
  
  /// Permission denied
  static Widget permissionDenied({
    required String permission,
    VoidCallback? onOpenSettings,
  }) {
    return IOSEmptyState(
      icon: Icons.lock_outline,
      title: 'Permission Required',
      subtitle: 'This feature requires $permission permission.\nPlease enable it in Settings.',
      buttonText: 'Open Settings',
      onButtonPressed: onOpenSettings,
    );
  }
  
  /// Location disabled
  static Widget locationDisabled({
    VoidCallback? onEnableLocation,
  }) {
    return IOSEmptyState(
      icon: Icons.location_off_outlined,
      title: 'Location Services Disabled',
      subtitle: 'Enable location services to find flats near you.',
      buttonText: 'Enable Location',
      onButtonPressed: onEnableLocation,
    );
  }
  
  /// Coming soon
  static Widget comingSoon({
    String? feature,
  }) {
    return IOSEmptyState(
      icon: Icons.construction_outlined,
      title: 'Coming Soon',
      subtitle: feature != null 
          ? '$feature is coming soon!\nStay tuned for updates.'
          : 'This feature is coming soon!\nStay tuned for updates.',
    );
  }
  
  /// Maintenance mode
  static Widget maintenance({
    VoidCallback? onRetry,
  }) {
    return IOSEmptyState(
      icon: Icons.build_outlined,
      title: 'Under Maintenance',
      subtitle: 'We\'re making improvements to serve you better.\nPlease check back in a few minutes.',
      buttonText: 'Check Again',
      onButtonPressed: onRetry,
    );
  }
}

/// iOS-style empty state with animation
class IOSAnimatedEmptyState extends StatefulWidget {
  final IOSEmptyState emptyState;
  final Duration animationDuration;

  const IOSAnimatedEmptyState({
    super.key,
    required this.emptyState,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  State<IOSAnimatedEmptyState> createState() => _IOSAnimatedEmptyStateState();
}

class _IOSAnimatedEmptyStateState extends State<IOSAnimatedEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.emptyState,
          ),
        );
      },
    );
  }
}

/// iOS-style empty state container with proper spacing
class IOSEmptyStateContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool centerVertically;

  const IOSEmptyStateContainer({
    super.key,
    required this.child,
    this.padding,
    this.centerVertically = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: padding ?? const EdgeInsets.all(32),
      child: child,
    );

    if (centerVertically) {
      content = Center(child: content);
    }

    return content;
  }
}