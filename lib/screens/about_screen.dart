import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.home_outlined,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'FlatmateFinder',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Description
            _buildSection(
              'About FlatmateFinder',
              'FlatmateFinder is a modern platform designed to connect people looking for shared accommodation. Whether you\'re a host with a spare room or a seeker looking for the perfect flatmate, our app makes it easy to find compatible matches.',
            ),
            
            const SizedBox(height: 24),
            
            // Features
            _buildSection(
              'Key Features',
              '• Easy profile creation and verification\n'
              '• Advanced filtering and search options\n'
              '• Real-time messaging system\n'
              '• Secure request and match system\n'
              '• Location-based flat discovery\n'
              '• Photo sharing and gallery views\n'
              '• Safe and trusted community',
            ),
            
            const SizedBox(height: 24),
            
            // Mission
            _buildSection(
              'Our Mission',
              'To make finding compatible flatmates simple, safe, and stress-free. We believe that everyone deserves a comfortable living situation with people they can trust and enjoy living with.',
            ),
            
            const SizedBox(height: 24),
            
            // Contact
            _buildSection(
              'Contact Us',
              'Have questions or feedback? We\'d love to hear from you!\n\n'
              'Email: support@flatmatefinder.com\n'
              'Website: www.flatmatefinder.com\n'
              'Follow us on social media for updates and tips.',
            ),
            
            const SizedBox(height: 24),
            
            // Credits
            _buildSection(
              'Credits',
              'Built with Flutter and Firebase\n'
              'Icons by Material Design\n'
              'Special thanks to our beta testers and early users',
            ),
            
            const SizedBox(height: 32),
            
            // Legal Links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => _showPrivacyPolicy(context),
                  child: const Text('Privacy Policy'),
                ),
                TextButton(
                  onPressed: () => _showTermsOfService(context),
                  child: const Text('Terms of Service'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Copyright
            Center(
              child: Text(
                '© 2024 FlatmateFinder. All rights reserved.',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
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
}