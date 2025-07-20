import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../providers/advance_saver_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/flat_provider.dart';
import '../models/advance_saver_model.dart';
import '../models/flat_model.dart';
import '../widgets/ios_style_form_field.dart';
import '../widgets/ios_style_button.dart';

class CreateAdvanceSaverListingScreen extends StatefulWidget {
  const CreateAdvanceSaverListingScreen({super.key});

  @override
  State<CreateAdvanceSaverListingScreen> createState() => _CreateAdvanceSaverListingScreenState();
}

class _CreateAdvanceSaverListingScreenState extends State<CreateAdvanceSaverListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _roomDescriptionController = TextEditingController();
  final _rentController = TextEditingController();
  final _depositController = TextEditingController();
  final _locationController = TextEditingController();
  
  DateTime? _exitDate;
  String _genderPreference = 'Any';
  FlatModel? _selectedFlat;
  List<String> _roomImages = [];
  bool _isLoading = false;
  
  final List<String> _genderOptions = ['Any', 'Male', 'Female'];

  @override
  void initState() {
    super.initState();
    _loadUserFlats();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _roomDescriptionController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserFlats() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final flatProvider = Provider.of<FlatProvider>(context, listen: false);
    
    if (authProvider.userModel != null) {
      await flatProvider.loadHostFlats(authProvider.userModel!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text(
          'Save Your Deposit',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildBasicInfoSection(),
            const SizedBox(height: 20),
            _buildFlatSelectionSection(),
            const SizedBox(height: 20),
            _buildFinancialSection(),
            const SizedBox(height: 20),
            _buildDateSection(),
            const SizedBox(height: 20),
            _buildPreferencesSection(),
            const SizedBox(height: 20),
            _buildRoomDetailsSection(),
            const SizedBox(height: 20),
            _buildImagesSection(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.save_alt, color: Colors.blue.shade700, size: 24),
              const SizedBox(width: 8),
              Text(
                'AdvanceSaver',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Don\'t lose your deposit! Find someone to take your place and save your advance money.',
            style: TextStyle(
              color: Colors.blue.shade600,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildSection(
      title: 'Basic Information',
      children: [
        IOSStyleFormField(
          controller: _titleController,
          label: 'Listing Title',
          placeholder: 'e.g., "Leaving my room in 2BHK"',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        IOSStyleFormField(
          controller: _descriptionController,
          label: 'Description',
          placeholder: 'Describe why you\'re leaving and what makes this a great spot...',
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFlatSelectionSection() {
    return _buildSection(
      title: 'Flat Selection',
      children: [
        Consumer<FlatProvider>(
          builder: (context, flatProvider, child) {
            if (flatProvider.hostFlats.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700),
                    const SizedBox(height: 8),
                    Text(
                      'No flats found. You need to have a flat listing to create an AdvanceSaver listing.',
                      style: TextStyle(color: Colors.orange.shade700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select your current flat',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...flatProvider.hostFlats.map((flat) => RadioListTile<FlatModel>(
                  title: Text(flat.title),
                  subtitle: Text(flat.location),
                  value: flat,
                  groupValue: _selectedFlat,
                  onChanged: (value) {
                    setState(() {
                      _selectedFlat = value;
                      _locationController.text = value?.location ?? '';
                    });
                  },
                )),
              ],
            );
          },
        ),
        if (_selectedFlat == null) ...[
          const SizedBox(height: 16),
          IOSStyleFormField(
            controller: _locationController,
            label: 'Location',
            placeholder: 'Enter flat location',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter location';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildFinancialSection() {
    return _buildSection(
      title: 'Financial Details',
      children: [
        Row(
          children: [
            Expanded(
              child: IOSStyleFormField(
                controller: _rentController,
                label: 'Monthly Rent Share',
                placeholder: '0',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter rent amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter valid amount';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: IOSStyleFormField(
                controller: _depositController,
                label: 'Refundable Deposit',
                placeholder: '0',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter deposit amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter valid amount';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.savings, color: Colors.green.shade700, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You\'ll save \$${_depositController.text.isEmpty ? '0' : _depositController.text} by finding a replacement!',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return _buildSection(
      title: 'Exit Date',
      children: [
        InkWell(
          onTap: _selectExitDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey.shade600),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _exitDate != null
                        ? 'Leaving on ${_exitDate!.day}/${_exitDate!.month}/${_exitDate!.year}'
                        : 'Select exit date',
                    style: TextStyle(
                      fontSize: 16,
                      color: _exitDate != null ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
        if (_exitDate != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getDaysUntilExit() <= 15 ? Colors.orange.shade50 : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getDaysUntilExit() <= 15 ? Colors.orange.shade200 : Colors.blue.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getDaysUntilExit() <= 15 ? Icons.warning : Icons.info,
                  color: _getDaysUntilExit() <= 15 ? Colors.orange.shade700 : Colors.blue.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_getDaysUntilExit()} days until exit${_getDaysUntilExit() <= 15 ? ' - Urgent!' : ''}',
                    style: TextStyle(
                      color: _getDaysUntilExit() <= 15 ? Colors.orange.shade700 : Colors.blue.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSection(
      title: 'Preferences',
      children: [
        const Text(
          'Preferred gender for replacement',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _genderOptions.map((gender) {
            final isSelected = _genderPreference == gender;
            return ChoiceChip(
              label: Text(gender),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _genderPreference = gender;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.blue.withValues(alpha: 0.1),
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRoomDetailsSection() {
    return _buildSection(
      title: 'Room Details',
      children: [
        IOSStyleFormField(
          controller: _roomDescriptionController,
          label: 'Room Description',
          placeholder: 'Describe your room, amenities, flatmates, etc...',
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please describe your room';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildImagesSection() {
    return _buildSection(
      title: 'Room Photos (Optional)',
      children: [
        if (_roomImages.isNotEmpty) ...[
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _roomImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _roomImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _roomImages.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
        OutlinedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add_photo_alternate),
          label: Text(_roomImages.isEmpty ? 'Add Photos' : 'Add More Photos'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return IOSStyleButton(
      text: 'Create AdvanceSaver Listing',
      onPressed: _isLoading ? null : _submitListing,
      isLoading: _isLoading,
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Future<void> _selectExitDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _exitDate = date;
      });
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        for (final image in images) {
          // Create a simple upload method for advance saver images
          final ref = FirebaseStorage.instance
              .ref()
              .child('advance_saver_rooms')
              .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
          await ref.putFile(File(image.path));
          final imageUrl = await ref.getDownloadURL();
          _roomImages.add(imageUrl);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload images: $e')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_exitDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an exit date')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.userModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to create a listing')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final listing = AdvanceSaverModel(
        userId: authProvider.userModel!.uid,
        flatId: _selectedFlat?.id ?? '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        rent: double.parse(_rentController.text),
        refundableDeposit: double.parse(_depositController.text),
        exitDate: _exitDate!,
        genderPreference: _genderPreference,
        roomDescription: _roomDescriptionController.text.trim(),
        roomImages: _roomImages,
        location: _locationController.text.trim(),
        createdAt: DateTime.now(),
      );

      final provider = Provider.of<AdvanceSaverProvider>(context, listen: false);
      final success = await provider.createListing(listing);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('AdvanceSaver listing created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.error ?? 'Failed to create listing'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  int _getDaysUntilExit() {
    if (_exitDate == null) return 0;
    return _exitDate!.difference(DateTime.now()).inDays;
  }
}