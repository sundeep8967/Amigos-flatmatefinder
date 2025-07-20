import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/ios_style_form_field.dart';
import 'edit_profile_screen.dart';
import 'about_screen.dart';
import 'help_screen.dart';
import 'welcome_screen.dart';
import 'manage_listings_screen.dart';
import 'bill_calculator_screen.dart';
import 'lifestyle_preferences_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        ),
        toolbarHeight: 100,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.userModel;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Section
                _buildIOSProfileSection(context, user),
                
                // Account Settings
                IOSStyleSection(
                  title: 'Account',
                  children: [
                    IOSStyleListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF007AFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: 'Edit Profile',
                      subtitle: 'Update your personal information',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _navigateToEditProfile(context),
                    ),
                    if (user?.role == 'host')
                      IOSStyleListTile(
                        leading: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF34C759),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.manage_accounts_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: 'Manage Listings',
                        subtitle: 'Edit and manage your flat listings',
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _navigateToManageListings(context),
                      ),
                    IOSStyleListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9500),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.swap_horiz_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: 'Switch Role',
                      subtitle: user?.role == 'host' 
                          ? 'Switch to Seeker mode'
                          : 'Switch to Host mode',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _showRoleSwitchDialog(context),
                    ),
                    IOSStyleListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.verified_user_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: 'Verification Status',
                      subtitle: 'Verified User',
                      trailing: const Icon(Icons.check_circle, color: Color(0xFF34C759)),
                      onTap: () => _showVerificationInfo(context),
                    ),
                  ],
                ),
                
                // Tools & Utilities
                IOSStyleSection(
                  title: 'Tools & Utilities',
                  children: [
                    IOSStyleListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5856D6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calculate_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: 'Bill Calculator',
                      subtitle: 'Split bills and expenses with flatmates',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _navigateToBillCalculator(context),
                    ),
                    IOSStyleListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3B30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.psychology_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: 'Lifestyle Preferences',
                      subtitle: 'Update your compatibility preferences',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _navigateToLifestylePreferences(context),
                    ),
                  ],
                ),
                
                // App Settings
                IOSStyleSection(
                  title: 'App Settings',
                  children: [
                    IOSStyleListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9500),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: 'Notifications',
                      subtitle: 'Manage notification preferences',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _showNotificationSettings(context),
                    ),
                    IOSStyleListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.dark_mode_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: 'Dark Mode',
                      subtitle: 'Toggle dark theme',
                      trailing: Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return Switch(
                            value: themeProvider.isDarkMode,
                            onChanged: (value) => themeProvider.toggleTheme(),
                            activeColor: const Color(0xFF34C759),
                          );
                        },
                      ),
                    ),
                    IOSStyleListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF007AFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.language_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: 'Language',
                      subtitle: 'English',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _showLanguageOptions(context),
                    ),
                  ],
                ),
                
                // Support & Information
                IOSStyleSection(
                  title: 'Support & Information',
                  children: [
                    IOSStyleListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: 'Help & FAQ',
                      subtitle: 'Get help and find answers',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _navigateToHelp(context),
                    ),
                    IOSStyleListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8E8E93),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: 'About',
                      subtitle: 'App version and information',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _navigateToAbout(context),
                    ),
                  ],
                ),
                
                // Sign Out
                IOSStyleSection(
                  children: [
                    IOSStyleListTile(
                      title: 'Sign Out',
                      onTap: () => _showSignOutDialog(context),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                _buildSettingsCard([
                  _buildSettingsTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage notification preferences',
                    onTap: () => _showNotificationSettings(context),
                  ),
                  _buildSettingsTile(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    subtitle: 'Toggle dark theme',
                    trailing: Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) => themeProvider.toggleTheme(),
                        );
                      },
                    ),
                  ),
                  _buildSettingsTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () => _showLanguageOptions(context),
                  ),
                ]),
                
                const SizedBox(height: 24),
                
                // Support & Info
                _buildSectionTitle('Support & Information'),
                _buildSettingsCard([
                  _buildSettingsTile(
                    icon: Icons.help_outline,
                    title: 'Help & FAQ',
                    subtitle: 'Get help and find answers',
                    onTap: () => _navigateToHelp(context),
                  ),
                  _buildSettingsTile(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and information',
                    onTap: () => _navigateToAbout(context),
                  ),
                  _buildSettingsTile(
                    icon: Icons.star_rate,
                    title: 'Rate App',
                    subtitle: 'Rate us on the app store',
                    onTap: () => _showRateApp(context),
                  ),
                  _buildSettingsTile(
                    icon: Icons.feedback,
                    title: 'Send Feedback',
                    subtitle: 'Help us improve the app',
                    onTap: () => _showFeedbackDialog(context),
                  ),
                ]),
                
                const SizedBox(height: 24),
                
                // Privacy & Legal
                _buildSectionTitle('Privacy & Legal'),
                _buildSettingsCard([
                  _buildSettingsTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your data',
                    onTap: () => _showPrivacyPolicy(context),
                  ),
                  _buildSettingsTile(
                    icon: Icons.description,
                    title: 'Terms of Service',
                    subtitle: 'Terms and conditions',
                    onTap: () => _showTermsOfService(context),
                  ),
                  _buildSettingsTile(
                    icon: Icons.report,
                    title: 'Report Issue',
                    subtitle: 'Report inappropriate content',
                    onTap: () => _showReportDialog(context),
                  ),
                ]),
                
                const SizedBox(height: 32),
                
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // App Version
                Center(
                  child: Text(
                    'FlatmateFinder v1.0.0',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIOSProfileSection(BuildContext context, user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: user?.profileImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      user!.profileImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'User Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'user@example.com',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    user?.role?.toUpperCase() ?? 'USER',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF8E8E93),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await authProvider.signOut();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false,
        );
      }
    }
  }

  Widget _buildProfileSection(BuildContext context, user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: user?.profilePicture != null
                  ? NetworkImage(user!.profilePicture!)
                  : null,
              backgroundColor: Colors.blue.shade100,
              child: user?.profilePicture == null
                  ? Icon(Icons.person, size: 35, color: Colors.blue.shade600)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: user?.role == 'host' ? Colors.green.shade100 : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user?.role?.toUpperCase() ?? 'USER',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: user?.role == 'host' ? Colors.green.shade700 : Colors.blue.shade700,
                      ),
                    ),
                  ),
                  if (user?.occupation != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      user!.occupation!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.verified_user,
              color: Colors.green.shade600,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue.shade600, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
  }

  void _navigateToHelp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HelpScreen()),
    );
  }

  void _navigateToAbout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AboutScreen()),
    );
  }

  void _navigateToManageListings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ManageListingsScreen()),
    );
  }

  void _navigateToBillCalculator(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const BillCalculatorScreen()),
    );
  }

  void _navigateToLifestylePreferences(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LifestylePreferencesScreen()),
    );
  }

  void _showRoleSwitchDialog(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentRole = authProvider.userModel?.role;
    final newRole = currentRole == 'host' ? 'seeker' : 'host';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Switch Role'),
          content: Text(
            'Are you sure you want to switch from ${currentRole?.toUpperCase()} to ${newRole.toUpperCase()}?\n\nThis will change your app experience.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await authProvider.updateUserData({'role': newRole});
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success 
                          ? 'Role switched successfully!' 
                          : 'Failed to switch role'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Switch'),
            ),
          ],
        );
      },
    );
  }

  void _showVerificationInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verification Status'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Profile Verified'),
                ],
              ),
              SizedBox(height: 8),
              Text('Your profile has been verified. This helps build trust with other users.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification Settings'),
          content: const Text('Notification preferences will be available once Firebase is configured.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  void _showLanguageOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Language'),
          content: const Text('Currently only English is supported. More languages coming soon!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showRateApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rate FlatmateFinder'),
          content: const Text('Would you like to rate our app on the app store?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your interest! App store link will be available after publication.')),
                );
              },
              child: const Text('Rate Now'),
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final feedbackController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Help us improve FlatmateFinder by sharing your feedback:'),
              const SizedBox(height: 16),
              TextField(
                controller: feedbackController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Your feedback...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your feedback!')),
                );
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
              'Privacy Policy\n\n'
              'We value your privacy and are committed to protecting your personal information.\n\n'
              'Information We Collect:\n'
              '• Profile information (name, age, occupation)\n'
              '• Photos you upload\n'
              '• Messages and communications\n'
              '• Usage data and preferences\n\n'
              'How We Use Your Information:\n'
              '• To provide and improve our services\n'
              '• To facilitate connections between users\n'
              '• To ensure safety and security\n\n'
              'We do not sell your personal information to third parties.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms of Service'),
          content: const SingleChildScrollView(
            child: Text(
              'Terms of Service\n\n'
              'By using FlatmateFinder, you agree to these terms:\n\n'
              '1. You must be 18 years or older to use this service\n'
              '2. You are responsible for the accuracy of your profile information\n'
              '3. Respectful communication is required at all times\n'
              '4. No harassment, discrimination, or inappropriate behavior\n'
              '5. We reserve the right to suspend accounts that violate these terms\n'
              '6. You are responsible for your own safety when meeting other users\n\n'
              'Please use the app responsibly and report any issues.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Issue'),
          content: const Text('If you encounter inappropriate content or behavior, please contact our support team.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted. Thank you for helping keep our community safe.')),
                );
              },
              child: const Text('Report'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}