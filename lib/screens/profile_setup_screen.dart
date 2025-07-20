import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/auth_provider.dart';
import '../services/storage_service.dart';
import '../widgets/ios_style_form_field.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  final _occupationController = TextEditingController();
  final _budgetController = TextEditingController();
  final _locationController = TextEditingController();
  
  String? _selectedPreferredGender;
  File? _selectedImage;
  bool _isLoading = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Other', 'No Preference'];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _occupationController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complete Profile',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: 1.0, // Complete progress for profile setup
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                ),
                
                const SizedBox(height: 32),
                
                // Profile Picture Section
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(
                              color: Colors.blue.shade300,
                              width: 3,
                            ),
                          ),
                          child: _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(57),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                  color: Colors.grey.shade600,
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Add Profile Photo',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Personal Information Section
                IOSStyleSection(
                  title: 'Personal Information',
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          IOSStyleFormField(
                            label: 'Full Name',
                            placeholder: 'Enter your full name',
                            controller: _nameController,
                            prefixIcon: const Icon(Icons.person_outline),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          IOSStyleFormField(
                            label: 'Age',
                            placeholder: 'Enter your age',
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(Icons.cake_outlined),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your age';
                              }
                              final age = int.tryParse(value);
                              if (age == null || age < 18 || age > 100) {
                                return 'Please enter a valid age (18-100)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          IOSStyleFormField(
                            label: 'Occupation',
                            placeholder: 'What do you do for work?',
                            controller: _occupationController,
                            prefixIcon: const Icon(Icons.work_outline),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your occupation';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // About You Section
                IOSStyleSection(
                  title: 'About You',
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: IOSStyleFormField(
                        label: 'Bio',
                        placeholder: 'Tell us about yourself...',
                        controller: _bioController,
                        maxLines: 4,
                        prefixIcon: const Icon(Icons.description_outlined),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please write a short bio';
                          }
                          if (value.trim().length < 20) {
                            return 'Bio should be at least 20 characters';
                          }
                          return null;
                        },
                        helperText: 'Minimum 20 characters',
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Preferences Section
                IOSStyleSection(
                  title: 'Preferences',
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          IOSStyleFormField(
                            label: 'Monthly Budget',
                            placeholder: 'Enter your budget',
                            controller: _budgetController,
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(Icons.attach_money_outlined),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your budget';
                              }
                              final budget = double.tryParse(value);
                              if (budget == null || budget <= 0) {
                                return 'Please enter a valid budget';
                              }
                              return null;
                            },
                            helperText: 'Amount you can afford monthly',
                          ),
                          const SizedBox(height: 16),
                          IOSStyleFormField(
                            label: 'Preferred Location',
                            placeholder: 'Enter preferred area',
                            controller: _locationController,
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your preferred location';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Preferred Gender Dropdown
                _buildDropdownField(),
                
                const SizedBox(height: 40),
                
                // Complete Profile Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleCompleteProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Complete Profile',
                            style: TextStyle(
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
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedPreferredGender,
      decoration: InputDecoration(
        labelText: 'Preferred Flatmate Gender',
        prefixIcon: Icon(Icons.people, color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: _genderOptions.map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedPreferredGender = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select preferred flatmate gender';
        }
        return null;
      },
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 512,
                    maxHeight: 512,
                    imageQuality: 75,
                  );
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 512,
                    maxHeight: 512,
                    imageQuality: 75,
                  );
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleCompleteProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Upload profile picture if selected
      String? profilePictureUrl;
      if (_selectedImage != null) {
        final storageService = StorageService();
        profilePictureUrl = await storageService.uploadProfilePicture(
          _selectedImage!,
          authProvider.user!.uid,
        );
      }

      // Prepare profile data
      final profileData = {
        'name': _nameController.text.trim(),
        'age': int.parse(_ageController.text.trim()),
        'bio': _bioController.text.trim(),
        'occupation': _occupationController.text.trim(),
        'budget': double.parse(_budgetController.text.trim()),
        'preferredLocation': _locationController.text.trim(),
        'preferredGender': _selectedPreferredGender,
        if (profilePictureUrl != null) 'profilePicture': profilePictureUrl,
      };

      // Update user profile
      final success = await authProvider.updateUserData(profileData);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to home screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Failed to update profile'),
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