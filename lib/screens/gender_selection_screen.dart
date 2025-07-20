import 'package:flutter/material.dart';
import '../widgets/ios_style_button.dart';
import '../widgets/ios_navigation_bar.dart';
import 'role_selection_screen.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: const IOSNavigationBar(
        title: 'Select Gender',
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
                  widthFactor: 0.33,
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
                        'What\'s your gender?',
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
                        'This helps us show you relevant matches and preferences.',
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
              
              // Gender options with staggered animation
              Expanded(
                child: Column(
                  children: [
                    ..._buildAnimatedGenderOptions(),
                  ],
                ),
              ),
              
              // Continue button with animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1400),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: IOSStyleButton(
                        text: 'Continue',
                        onPressed: selectedGender != null ? _handleContinue : null,
                        style: selectedGender != null ? IOSButtonStyle.filled : IOSButtonStyle.tinted,
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

  List<Widget> _buildAnimatedGenderOptions() {
    final options = [
      {'gender': 'Male', 'icon': Icons.male, 'color': const Color(0xFF007AFF), 'delay': 1000},
      {'gender': 'Female', 'icon': Icons.female, 'color': const Color(0xFFFF2D92), 'delay': 1100},
      {'gender': 'Other', 'icon': Icons.person, 'color': const Color(0xFF5856D6), 'delay': 1200},
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
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildGenderOption(
                  gender: option['gender'] as String,
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

  Widget _buildGenderOption({
    required String gender,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = selectedGender == gender;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withValues(alpha: 0.1) 
              : (isDark ? const Color(0xFF1C1C1E) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : (isDark ? const Color(0xFF38383A) : const Color(0xFFE5E5EA)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isDark ? null : [
            if (isSelected)
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected ? color : (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7)),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.white : (isDark ? const Color(0xFF8E8E93) : const Color(0xFF6D6D70)),
              ),
            ),
            
            const SizedBox(width: 24),
            
            Expanded(
              child: Text(
                gender,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? color : (isDark ? Colors.white : Colors.black),
                ),
              ),
            ),
            
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: isSelected ? 1.0 : 0.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    if (selectedGender != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RoleSelectionScreen(gender: selectedGender!),
        ),
      );
    }
  }
}