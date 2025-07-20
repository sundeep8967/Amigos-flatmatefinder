import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final Map<String, dynamic>? currentFilters;

  const FilterScreen({
    super.key,
    this.currentFilters,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final _minRentController = TextEditingController();
  final _maxRentController = TextEditingController();
  final _locationController = TextEditingController();
  
  String? _selectedGenderPreference;
  String? _selectedFlatType;
  List<String> _selectedAmenities = [];

  final List<String> _genderOptions = [
    'No Preference',
    'Male',
    'Female',
  ];

  final List<String> _flatTypes = [
    'Any',
    '1 BHK',
    '2 BHK', 
    '3 BHK',
    '4 BHK',
    'Studio',
    'Shared Room',
    'PG',
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
    _initializeFilters();
  }

  void _initializeFilters() {
    if (widget.currentFilters != null) {
      final filters = widget.currentFilters!;
      _minRentController.text = filters['minRent']?.toString() ?? '';
      _maxRentController.text = filters['maxRent']?.toString() ?? '';
      _locationController.text = filters['location'] ?? '';
      _selectedGenderPreference = filters['genderPreference'];
      _selectedFlatType = filters['flatType'];
      _selectedAmenities = List<String>.from(filters['amenities'] ?? []);
    }
  }

  @override
  void dispose() {
    _minRentController.dispose();
    _maxRentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Filter Flats'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _clearAllFilters,
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price Range
            _buildSectionTitle('Price Range'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _minRentController,
                    label: 'Min Rent',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _maxRentController,
                    label: 'Max Rent',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Location
            _buildSectionTitle('Location'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _locationController,
              label: 'Location',
              hintText: 'Enter area, city, or landmark',
            ),
            
            const SizedBox(height: 24),
            
            // Gender Preference
            _buildSectionTitle('Gender Preference'),
            const SizedBox(height: 12),
            _buildDropdownField(
              value: _selectedGenderPreference,
              items: _genderOptions,
              hint: 'Select gender preference',
              onChanged: (value) {
                setState(() {
                  _selectedGenderPreference = value;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Flat Type
            _buildSectionTitle('Flat Type'),
            const SizedBox(height: 12),
            _buildDropdownField(
              value: _selectedFlatType,
              items: _flatTypes,
              hint: 'Select flat type',
              onChanged: (value) {
                setState(() {
                  _selectedFlatType = value;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Amenities
            _buildSectionTitle('Amenities'),
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
                    selectedColor: Colors.blue.shade100,
                    checkmarkColor: Colors.blue.shade600,
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
      
      // Apply Filters Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
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
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
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
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _clearAllFilters() {
    setState(() {
      _minRentController.clear();
      _maxRentController.clear();
      _locationController.clear();
      _selectedGenderPreference = null;
      _selectedFlatType = null;
      _selectedAmenities.clear();
    });
  }

  void _applyFilters() {
    final filters = <String, dynamic>{};
    
    if (_minRentController.text.isNotEmpty) {
      filters['minRent'] = double.tryParse(_minRentController.text);
    }
    
    if (_maxRentController.text.isNotEmpty) {
      filters['maxRent'] = double.tryParse(_maxRentController.text);
    }
    
    if (_locationController.text.isNotEmpty) {
      filters['location'] = _locationController.text.trim();
    }
    
    if (_selectedGenderPreference != null && _selectedGenderPreference != 'No Preference') {
      filters['genderPreference'] = _selectedGenderPreference;
    }
    
    if (_selectedFlatType != null && _selectedFlatType != 'Any') {
      filters['flatType'] = _selectedFlatType;
    }
    
    if (_selectedAmenities.isNotEmpty) {
      filters['amenities'] = _selectedAmenities;
    }
    
    Navigator.of(context).pop(filters);
  }
}