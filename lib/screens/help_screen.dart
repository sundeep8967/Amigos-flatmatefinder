import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Help & FAQ'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search for help...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    'Contact Support',
                    Icons.support_agent,
                    Colors.blue,
                    () => _contactSupport(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    'Report Issue',
                    Icons.report_problem,
                    Colors.orange,
                    () => _reportIssue(context),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // FAQ Sections
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFAQSection('Getting Started', [
              _buildFAQItem(
                'How do I create an account?',
                'Simply download the app and follow the onboarding process. You\'ll need to select your gender, choose your role (Host or Seeker), and complete your profile with basic information.',
              ),
              _buildFAQItem(
                'What\'s the difference between Host and Seeker?',
                'Hosts have a flat and are looking for flatmates to join them. Seekers are looking for a flat to join. You can switch between roles anytime in Settings.',
              ),
              _buildFAQItem(
                'How do I complete my profile?',
                'After selecting your role, you\'ll be guided through profile setup. Add your photo, personal details, budget, and preferences to help others find you.',
              ),
            ]),
            
            _buildFAQSection('For Hosts', [
              _buildFAQItem(
                'How do I create a flat listing?',
                'Go to your dashboard and tap "Add Listing". Fill in details about your flat including location, rent, amenities, and upload photos.',
              ),
              _buildFAQItem(
                'How do I manage requests?',
                'Tap "Requests" on your dashboard to see all incoming requests. You can view seeker profiles and accept or reject requests.',
              ),
              _buildFAQItem(
                'Can I edit my flat listing?',
                'Yes! Go to your listings and tap on any listing to edit details, update photos, or change availability.',
              ),
            ]),
            
            _buildFAQSection('For Seekers', [
              _buildFAQItem(
                'How do I find flats?',
                'Browse the "Available Flats" section on your dashboard. Use filters to narrow down options by price, location, and preferences.',
              ),
              _buildFAQItem(
                'How do I request to join a flat?',
                'Tap on any flat listing to view details, then tap "View Details" and "Request to Join". You can include a personal message.',
              ),
              _buildFAQItem(
                'How do I track my requests?',
                'Check the "My Requests" section to see the status of all your sent requests - pending, accepted, or rejected.',
              ),
            ]),
            
            _buildFAQSection('Messaging & Matches', [
              _buildFAQItem(
                'When can I start chatting?',
                'You can chat with someone once your request is accepted. A chat room will be automatically created.',
              ),
              _buildFAQItem(
                'How do I access my messages?',
                'Tap the "Messages" or "Chats" button on your dashboard to see all your conversations.',
              ),
              _buildFAQItem(
                'Can I report inappropriate messages?',
                'Yes, use the report function in Settings or contact support directly if you encounter inappropriate behavior.',
              ),
            ]),
            
            _buildFAQSection('Safety & Privacy', [
              _buildFAQItem(
                'Is my personal information safe?',
                'Yes, we take privacy seriously. Your data is encrypted and we never share personal information with third parties.',
              ),
              _buildFAQItem(
                'How do I stay safe when meeting flatmates?',
                'Always meet in public places first, trust your instincts, and let friends know your plans. Take time to get to know someone before committing.',
              ),
              _buildFAQItem(
                'How do I report suspicious activity?',
                'Use the "Report Issue" feature in Settings or contact our support team immediately.',
              ),
            ]),
            
            _buildFAQSection('Account & Settings', [
              _buildFAQItem(
                'How do I change my role?',
                'Go to Settings > Switch Role. You can change between Host and Seeker anytime.',
              ),
              _buildFAQItem(
                'How do I update my profile?',
                'Go to Settings > Edit Profile to update your information, photos, and preferences.',
              ),
              _buildFAQItem(
                'How do I delete my account?',
                'Contact our support team to request account deletion. We\'ll help you through the process.',
              ),
            ]),
            
            const SizedBox(height: 32),
            
            // Contact Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.help_center,
                    size: 48,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Still need help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our support team is here to help you with any questions or issues.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _contactSupport(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Contact Support'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        ...items,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: const TextStyle(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  void _contactSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Get in touch with our support team:'),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('support@flatmatefinder.com'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Mon-Fri, 9AM-6PM'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening email app...')),
                );
              },
              child: const Text('Send Email'),
            ),
          ],
        );
      },
    );
  }

  void _reportIssue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final issueController = TextEditingController();
        return AlertDialog(
          title: const Text('Report Issue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please describe the issue you\'re experiencing:'),
              const SizedBox(height: 16),
              TextField(
                controller: issueController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe the issue...',
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
                  const SnackBar(
                    content: Text('Issue reported. Our team will investigate.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Report'),
            ),
          ],
        );
      },
    );
  }
}