import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_preferences_model.dart';

class LifestylePreferencesScreen extends StatefulWidget {
  final bool isOnboarding;

  const LifestylePreferencesScreen({
    super.key,
    this.isOnboarding = false,
  });

  @override
  State<LifestylePreferencesScreen> createState() => _LifestylePreferencesScreenState();
}

class _LifestylePreferencesScreenState extends State<LifestylePreferencesScreen> {
  String? _cleanlinessLevel;
  String? _smokingPreference;
  String? _petPreference;
  String? _socialLevel;
  String? _workSchedule;
  String? _partyFrequency;
  String? _guestPolicy;
  String? _musicPreference;
  final List<String> _interests = [];
  final List<String> _dealBreakers = [];
  DateTime? _moveInDate;
  DateTime? _moveOutDate;
  bool _isFlexibleWithDates = true;
  bool _isLoading = false;

  final Map<String, List<String>> _options = {
    'cleanliness': ['Very Clean', 'Clean', 'Moderate', 'Relaxed'],
    'smoking': ['Non-Smoker', 'Occasional', 'Regular', 'No Preference'],
    'pets': ['Love Pets', 'Okay with Pets', 'No Pets', 'Allergic'],
    'social': ['Very Social', 'Social', 'Moderate', 'Private'],
    'work': ['Day Shift', 'Night Shift', 'Flexible', 'Work from Home'],
    'party': ['Never', 'Rarely', 'Sometimes', 'Often'],
    'guests': ['No Guests', 'Occasional', 'Frequent', 'No Preference'],
    'music': ['Quiet', 'Moderate', 'Loud', 'No Preference'],
  };

  final List<String> _interestOptions = [
    'Cooking', 'Fitness', 'Reading', 'Gaming', 'Music', 'Movies', 'Travel',
    'Photography', 'Art', 'Sports', 'Technology', 'Nature', 'Yoga', 'Dancing',
    'Writing', 'Gardening', 'Fashion', 'Food', 'Learning Languages', 'Volunteering'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(widget.isOnboarding ? 'Lifestyle Preferences' : 'Edit Preferences'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          if (!widget.isOnboarding)
            TextButton(
              onPressed: _isLoading ? null : _savePreferences,
              child: Text(
                'Save',
                style: TextStyle(
                  color: _isLoading ? Colors.white54 : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isOnboarding) ...[
              const Text(
                'Help us find your perfect match!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tell us about your lifestyle preferences to get better matches.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),
            ],

            // Cleanliness Level
            _buildPreferenceSection(
              'Cleanliness Level',
              'How clean do you like your living space?',
              Icons.cleaning_services,
              _options['cleanliness']!,
              _cleanlinessLevel,
              (value) => setState(() => _cleanlinessLevel = value),
            ),

            // Smoking Preference
            _buildPreferenceSection(
              'Smoking Preference',
              'What\'s your stance on smoking?',
              Icons.smoke_free,
              _options['smoking']!,
              _smokingPreference,
              (value) => setState(() => _smokingPreference = value),
            ),

            // Pet Preference
            _buildPreferenceSection(
              'Pet Preference',
              'How do you feel about pets?',
              Icons.pets,
              _options['pets']!,
              _petPreference,
              (value) => setState(() => _petPreference = value),
            ),

            // Social Level
            _buildPreferenceSection(
              'Social Level',
              'How social are you at home?',
              Icons.people,
              _options['social']!,
              _socialLevel,
              (value) => setState(() => _socialLevel = value),
            ),

            // Work Schedule
            _buildPreferenceSection(
              'Work Schedule',
              'What\'s your typical work schedule?',
              Icons.schedule,
              _options['work']!,
              _workSchedule,
              (value) => setState(() => _workSchedule = value),
            ),

            // Party Frequency
            _buildPreferenceSection(
              'Party Frequency',
              'How often do you party or have gatherings?',
              Icons.celebration,
              _options['party']!,
              _partyFrequency,
              (value) => setState(() => _partyFrequency = value),
            ),

            // Guest Policy
            _buildPreferenceSection(
              'Guest Policy',
              'How often do you have guests over?',
              Icons.group_add,
              _options['guests']!,
              _guestPolicy,
              (value) => setState(() => _guestPolicy = value),
            ),

            // Music Preference
            _buildPreferenceSection(
              'Music Volume',
              'How loud do you like your music?',
              Icons.volume_up,
              _options['music']!,
              _musicPreference,
              (value) => setState(() => _musicPreference = value),
            ),

            // Interests
            _buildInterestsSection(),

            // Move-in Date
            _buildDateSection(),

            const SizedBox(height: 40),

            // Continue/Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        widget.isOnboarding ? 'Complete Setup' : 'Save Preferences',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceSection(
    String title,
    String subtitle,
    IconData icon,
    List<String> options,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.blue.shade600, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option.toLowerCase().replaceAll(' ', '_');
            return GestureDetector(
              onTap: () => onChanged(option.toLowerCase().replaceAll(' ', '_')),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade600 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.favorite, color: Colors.blue.shade600, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interests & Hobbies',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'What do you enjoy doing in your free time?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _interestOptions.map((interest) {
            final isSelected = _interests.contains(interest);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _interests.remove(interest);
                  } else {
                    _interests.add(interest);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green.shade600 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.green.shade600 : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      const Icon(Icons.check, color: Colors.white, size: 16),
                    if (isSelected) const SizedBox(width: 4),
                    Text(
                      interest,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.calendar_today, color: Colors.blue.shade600, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Move-in Timeline',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'When are you looking to move?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(true),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Move-in Date',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _moveInDate != null
                            ? '${_moveInDate!.day}/${_moveInDate!.month}/${_moveInDate!.year}'
                            : 'Select date',
                        style: TextStyle(
                          fontSize: 16,
                          color: _moveInDate != null ? Colors.black87 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(false),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Move-out Date (Optional)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _moveOutDate != null
                            ? '${_moveOutDate!.day}/${_moveOutDate!.month}/${_moveOutDate!.year}'
                            : 'Select date',
                        style: TextStyle(
                          fontSize: 16,
                          color: _moveOutDate != null ? Colors.black87 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        CheckboxListTile(
          title: const Text('I\'m flexible with dates'),
          value: _isFlexibleWithDates,
          onChanged: (value) {
            setState(() {
              _isFlexibleWithDates = value ?? true;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _selectDate(bool isMoveIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (picked != null) {
      setState(() {
        if (isMoveIn) {
          _moveInDate = picked;
        } else {
          _moveOutDate = picked;
        }
      });
    }
  }

  Future<void> _savePreferences() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final preferences = UserPreferencesModel(
        cleanlinessLevel: _cleanlinessLevel,
        smokingPreference: _smokingPreference,
        petPreference: _petPreference,
        socialLevel: _socialLevel,
        workSchedule: _workSchedule,
        partyFrequency: _partyFrequency,
        guestPolicy: _guestPolicy,
        musicPreference: _musicPreference,
        interests: _interests,
        dealBreakers: _dealBreakers,
        moveInDate: _moveInDate,
        moveOutDate: _moveOutDate,
        isFlexibleWithDates: _isFlexibleWithDates,
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.updateUserData({
        'preferences': preferences.toMap(),
      });

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferences saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        if (widget.isOnboarding) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          Navigator.of(context).pop();
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Failed to save preferences'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}