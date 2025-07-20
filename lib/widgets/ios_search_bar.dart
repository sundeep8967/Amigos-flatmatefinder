import 'package:flutter/material.dart';
import '../services/haptic_service.dart';

/// iOS-style search bar
class IOSSearchBar extends StatefulWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final bool autofocus;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showCancelButton;
  final VoidCallback? onCancel;

  const IOSSearchBar({
    super.key,
    this.placeholder,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.autofocus = false,
    this.leading,
    this.actions,
    this.showCancelButton = false,
    this.onCancel,
  });

  @override
  State<IOSSearchBar> createState() => _IOSSearchBarState();
}

class _IOSSearchBarState extends State<IOSSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _cancelButtonAnimation;
  bool _showCancelButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _cancelButtonAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _focusNode.addListener(_onFocusChange);
    _showCancelButton = widget.showCancelButton;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && !_showCancelButton) {
      setState(() {
        _showCancelButton = true;
      });
      _animationController.forward();
    } else if (!_focusNode.hasFocus && _showCancelButton && !widget.showCancelButton) {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showCancelButton = false;
          });
        }
      });
    }
  }

  void _onCancel() {
    HapticService.lightImpact();
    _controller.clear();
    _focusNode.unfocus();
    widget.onCancel?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: isDark 
                    ? const Color(0xFF1C1C1E) 
                    : const Color(0xFFE5E5EA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(
                    Icons.search,
                    size: 18,
                    color: isDark 
                        ? const Color(0xFF8E8E93) 
                        : const Color(0xFF8E8E93),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      enabled: widget.enabled,
                      autofocus: widget.autofocus,
                      onChanged: widget.onChanged,
                      onSubmitted: widget.onSubmitted,
                      onTap: () {
                        HapticService.lightImpact();
                        widget.onTap?.call();
                      },
                      style: TextStyle(
                        fontSize: 17,
                        color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                      ),
                      decoration: InputDecoration(
                        hintText: widget.placeholder ?? 'Search',
                        hintStyle: TextStyle(
                          fontSize: 17,
                          color: isDark 
                              ? const Color(0xFF8E8E93) 
                              : const Color(0xFF8E8E93),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        HapticService.lightImpact();
                        _controller.clear();
                        widget.onChanged?.call('');
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isDark 
                              ? const Color(0xFF8E8E93) 
                              : const Color(0xFF8E8E93),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget.actions != null) ...[
            const SizedBox(width: 8),
            ...widget.actions!,
          ],
          if (_showCancelButton)
            AnimatedBuilder(
              animation: _cancelButtonAnimation,
              builder: (context, child) {
                return SizeTransition(
                  sizeFactor: _cancelButtonAnimation,
                  axis: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: _onCancel,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 17,
                          color: const Color(0xFF007AFF),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// iOS-style search results list
class IOSSearchResults extends StatelessWidget {
  final List<IOSSearchResult> results;
  final ValueChanged<IOSSearchResult>? onResultTap;
  final Widget? emptyState;
  final String? emptyMessage;

  const IOSSearchResults({
    super.key,
    required this.results,
    this.onResultTap,
    this.emptyState,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (results.isEmpty) {
      return emptyState ?? 
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: isDark 
                        ? const Color(0xFF8E8E93) 
                        : const Color(0xFF8E8E93),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    emptyMessage ?? 'No results found',
                    style: TextStyle(
                      fontSize: 17,
                      color: isDark 
                          ? const Color(0xFF8E8E93) 
                          : const Color(0xFF8E8E93),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return _buildResultItem(context, result);
      },
    );
  }

  Widget _buildResultItem(BuildContext context, IOSSearchResult result) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.lightImpact();
          onResultTap?.call(result);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (result.leading != null) ...[
                result.leading!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                      ),
                    ),
                    if (result.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        result.subtitle!,
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark 
                              ? const Color(0xFF8E8E93) 
                              : const Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (result.trailing != null) ...[
                const SizedBox(width: 12),
                result.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class IOSSearchResult {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final dynamic data;

  const IOSSearchResult({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.data,
  });
}

/// iOS-style search delegate for full-screen search
class IOSSearchDelegate extends SearchDelegate<String> {
  final String searchHint;
  final List<String> suggestions;
  final Future<List<IOSSearchResult>> Function(String query) onSearch;
  final ValueChanged<IOSSearchResult>? onResultSelected;

  IOSSearchDelegate({
    this.searchHint = 'Search',
    this.suggestions = const [],
    required this.onSearch,
    this.onResultSelected,
  });

  @override
  String get searchFieldLabel => searchHint;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
        foregroundColor: isDark ? Colors.white : const Color(0xFF1C1C1E),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: isDark 
              ? const Color(0xFF8E8E93) 
              : const Color(0xFF8E8E93),
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            HapticService.lightImpact();
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.chevron_left, size: 28),
      onPressed: () {
        HapticService.lightImpact();
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const SizedBox();
    }

    return FutureBuilder<List<IOSSearchResult>>(
      future: onSearch(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final results = snapshot.data ?? [];
        return IOSSearchResults(
          results: results,
          onResultTap: (result) {
            HapticService.lightImpact();
            close(context, result.title);
            onResultSelected?.call(result);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredSuggestions = suggestions
        .where((suggestion) => 
            suggestion.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredSuggestions.length,
      itemBuilder: (context, index) {
        final suggestion = filteredSuggestions[index];
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(suggestion),
          onTap: () {
            HapticService.lightImpact();
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}