import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/ios_style_button.dart';
import 'profile_setup_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  final String gender;
  
  const RoleSelectionScreen({
    super.key,
    required this.gender,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Step 2 of 3'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator - iOS style
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.66,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Title with animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Text(
                        'What are you looking for?',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Subtitle with animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Text(
                        'Choose your role to get started with the right experience.',
                        style: TextStyle(
                          fontSize: 17,
                          color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF6D6D70),
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 60),
              
              // Role options with staggered animation
              Expanded(
                child: Column(
                  children: [
                    ..._buildAnimatedRoleOptions(),
                  ],
                ),
              ),
              
              // Continue button with animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1300),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return IOSStyleButton(
                            text: 'Continue',
                            onPressed: selectedRole != null && !authProvider.isLoading
                                ? () => _handleContinue(authProvider)
                                : null,
                            isLoading: authProvider.isLoading,
                            style: selectedRole != null ? IOSButtonStyle.filled : IOSButtonStyle.tinted,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnimatedRoleOptions() {
    final options = [
      {
        'role': 'host',
        'title': 'I have a flat',
        'subtitle': 'I need flatmates to join my place',
        'icon': Icons.home_rounded,
        'color': const Color(0xFF34C759),
        'delay': 1000,
      },
      {
        'role': 'seeker',
        'title': 'I\'m looking for a flat',
        'subtitle': 'I want to join someone else\'s place',
        'icon': Icons.search_rounded,
        'color': const Color(0xFFFF9500),
        'delay': 1100,
      },
    ];

    return options.map((option) {
      return TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: option['delay'] as int),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildRoleOption(
                  role: option['role'] as String,
                  title: option['title'] as String,
                  subtitle: option['subtitle'] as String,
                  icon: option['icon'] as IconData,
                  color: option['color'] as Color,
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildRoleOption({
    required String role,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = selectedRole == role;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withValues(alpha: 0.1) 
              : (isDark ? const Color(0xFF1C1C1E) : Colors.white),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : (isDark ? const Color(0xFF38383A) : const Color(0xFFE5E5EA)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isDark ? null : [
            if (isSelected)
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 25,
                offset: const Offset(0, 10),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isSelected ? color : (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 36,
                color: isSelected ? Colors.white : (isDark ? const Color(0xFF8E8E93) : const Color(0xFF6D6D70)),
              ),
            ),
            
            const SizedBox(width: 24),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : (isDark ? Colors.white : Colors.black),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF6D6D70),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: isSelected ? 1.0 : 0.0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleContinue(AuthProvider authProvider) async {
    if (selectedRole != null) {
      final success = await authProvider.createUserDocument(
        gender: widget.gender,
        role: selectedRole!,
      );
      
      if (success && mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile created successfully!'),
            backgroundColor: const Color(0xFF34C759),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        
        // Navigate to profile setup
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ProfileSetupScreen(),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Failed to create profile'),
            backgroundColor: const Color(0xFFFF3B30),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }
}