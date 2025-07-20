import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/flat_provider.dart';
import '../services/storage_service.dart';
import '../models/flat_model.dart';
import 'location_picker_screen.dart';

class EditFlatListingScreen extends StatefulWidget {
  final FlatModel flat;

  const EditFlatListingScreen({
    super.key,
    required this.flat,
  });

  @override
  State<EditFlatListingScreen> createState() => _EditFlatListingScreenState();
}

class _EditFlatListingScreenState extends State<EditFlatListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rentController = TextEditingController();
  final _spotsController = TextEditingController();
  
  String? _selectedFlatType;
  String? _selectedGenderPreference;
  String? _selectedLocation;
  double? _selectedLatitude;
  double? _selectedLongitude;
  List<String> _selectedAmenities = [];
  List<String> _currentImages = [];
  final List<File> _newImages = [];
  bool _isLoading = false;

  final List<String> _flatTypes = [
    '1 BHK',
    '2 BHK', 
    '3 BHK',
    '4 BHK',
    'Studio',
    'Shared Room',
    'PG',
  ];

  final List<String> _genderOptions = [
    'Male',
    'Female', 
    'No Preference',
  ];

  final List<String> _amenityOptions = [
    'WiFi',
    'AC',
    'Washing Machine',
    'Refrigerator',
    'Microwave',
    'TV',
    'Parking',
    'Gym',
    'Swimming Pool',
    'Security',
    'Power Backup',
    'Water Supply',
    'Furnished',
    'Semi-Furnished',
    'Balcony',
    'Garden',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  void _loadCurrentData() {
    final flat = widget.flat;
    _titleController.text = flat.title;
    _descriptionController.text = flat.description;
    _rentController.text = flat.rentPerHead.toString();
    _spotsController.text = flat.availableSpots.toString();
    _selectedFlatType = flat.flatType;
    _selectedGenderPreference = flat.genderPreference;
    _selectedLocation = flat.location;
    _selectedLatitude = flat.latitude;
    _selectedLongitude = flat.longitude;
    _selectedAmenities = List.from(flat.amenities);
    _currentImages = List.from(flat.images);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _rentController.dispose();
    _spotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Edit Listing'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveListing,
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
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              _buildTextField(
                controller: _titleController,
                label: 'Listing Title',
                icon: Icons.title,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title for your listing';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Flat Type Dropdown
              _buildDropdownField(
                value: _selectedFlatType,
                label: 'Flat Type',
                icon: Icons.home,
                items: _flatTypes,
                onChanged: (value) {
                  setState(() {
                    _selectedFlatType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select flat type';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Rent Field
              _buildTextField(
                controller: _rentController,
                label: 'Rent Per Head (Monthly)',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter rent amount';
                  }
                  final rent = double.tryParse(value);
                  if (rent == null || rent <= 0) {
                    return 'Please enter a valid rent amount';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Available Spots Field
              _buildTextField(
                controller: _spotsController,
                label: 'Available Spots',
                icon: Icons.people,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter number of available spots';
                  }
                  final spots = int.tryParse(value);
                  if (spots == null || spots <= 0 || spots > 10) {
                    return 'Please enter a valid number (1-10)';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Location Picker
              _buildLocationPicker(),
              
              const SizedBox(height: 20),
              
              // Gender Preference Dropdown
              _buildDropdownField(
                value: _selectedGenderPreference,
                label: 'Preferred Flatmate Gender',
                icon: Icons.person,
                items: _genderOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedGenderPreference = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select gender preference';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Description Field
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.trim().length < 50) {
                    return 'Description should be at least 50 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Amenities Section
              _buildAmenitiesSection(),
              
              const SizedBox(height: 20),
              
              // Images Section
              _buildImagesSection(),
              
              const SizedBox(height: 40),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveListing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
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
                          'Save Changes',
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
        prefixIcon: Icon(icon, color: Colors.green.shade600),
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
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
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

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green.shade600),
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
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildLocationPicker() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.of(context).push<Map<String, dynamic>>(
          MaterialPageRoute(
            builder: (context) => const LocationPickerScreen(),
          ),
        );
        
        if (result != null) {
          setState(() {
            _selectedLocation = result['address'];
            _selectedLatitude = result['latitude'];
            _selectedLongitude = result['longitude'];
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.green.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedLocation ?? 'Tap to select location',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedLocation != null ? Colors.black87 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amenities',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _amenityOptions.map((amenity) {
              final isSelected = _selectedAmenities.contains(amenity);
              return FilterChip(
                label: Text(amenity),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedAmenities.add(amenity);
                    } else {
                      _selectedAmenities.remove(amenity);
                    }
                  });
                },
                selectedColor: Colors.green.shade100,
                checkmarkColor: Colors.green.shade600,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildImagesSection() {
    final allImages = [..._currentImages, ..._newImages.map((f) => f.path)];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Flat Images',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            TextButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Add Photos'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (allImages.isEmpty)
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey.shade500),
                const SizedBox(height: 8),
                Text(
                  'Add photos of your flat',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allImages.length + 1,
              itemBuilder: (context, index) {
                if (index == allImages.length) {
                  return GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                      ),
                      child: Icon(Icons.add, size: 40, color: Colors.grey.shade500),
                    ),
                  );
                }
                
                final imagePath = allImages[index];
                final isNetworkImage = imagePath.startsWith('http');
                
                return Stack(
                  children: [
                    Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: isNetworkImage 
                              ? NetworkImage(imagePath)
                              : FileImage(File(imagePath)) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
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
                );
              },
            ),
          ),
      ],
    );
  }

  Future<void> _pickImages() async {
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
                  final List<XFile> images = await picker.pickMultiImage(
                    maxWidth: 1024,
                    maxHeight: 1024,
                    imageQuality: 75,
                  );
                  if (images.isNotEmpty) {
                    setState(() {
                      _newImages.addAll(images.map((image) => File(image.path)));
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
                    maxWidth: 1024,
                    maxHeight: 1024,
                    imageQuality: 75,
                  );
                  if (image != null) {
                    setState(() {
                      _newImages.add(File(image.path));
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

  void _removeImage(int index) {
    setState(() {
      if (index < _currentImages.length) {
        _currentImages.removeAt(index);
      } else {
        _newImages.removeAt(index - _currentImages.length);
      }
    });
  }

  Future<void> _saveListing() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_currentImages.isEmpty && _newImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one photo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final flatProvider = Provider.of<FlatProvider>(context, listen: false);
      final storageService = StorageService();

      // Upload new images
      List<String> newImageUrls = [];
      if (_newImages.isNotEmpty) {
        newImageUrls = await storageService.uploadFlatImages(_newImages, widget.flat.id!);
      }

      // Combine current and new image URLs
      final allImageUrls = [..._currentImages, ...newImageUrls];

      // Prepare update data
      final updateData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'flatType': _selectedFlatType!,
        'rentPerHead': double.parse(_rentController.text.trim()),
        'location': _selectedLocation!,
        'latitude': _selectedLatitude,
        'longitude': _selectedLongitude,
        'amenities': _selectedAmenities,
        'images': allImageUrls,
        'genderPreference': _selectedGenderPreference!,
        'availableSpots': int.parse(_spotsController.text.trim()),
      };

      // Update flat listing
      final success = await flatProvider.updateFlat(widget.flat.id!, updateData);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.of(context).pop(true); // Return true to indicate success
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(flatProvider.error ?? 'Failed to update listing'),
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