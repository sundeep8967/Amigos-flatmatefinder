import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final _searchController = TextEditingController();
  String? _selectedAddress;
  double? _selectedLatitude;
  double? _selectedLongitude;
  bool _isLoading = false;

  // Predefined popular locations for demo purposes
  final List<Map<String, dynamic>> _popularLocations = [
    {
      'name': 'Koramangala, Bangalore',
      'address': 'Koramangala, Bengaluru, Karnataka, India',
      'latitude': 12.9352,
      'longitude': 77.6245,
    },
    {
      'name': 'Indiranagar, Bangalore',
      'address': 'Indiranagar, Bengaluru, Karnataka, India',
      'latitude': 12.9784,
      'longitude': 77.6408,
    },
    {
      'name': 'Whitefield, Bangalore',
      'address': 'Whitefield, Bengaluru, Karnataka, India',
      'latitude': 12.9698,
      'longitude': 77.7500,
    },
    {
      'name': 'Electronic City, Bangalore',
      'address': 'Electronic City, Bengaluru, Karnataka, India',
      'latitude': 12.8456,
      'longitude': 77.6603,
    },
    {
      'name': 'HSR Layout, Bangalore',
      'address': 'HSR Layout, Bengaluru, Karnataka, India',
      'latitude': 12.9116,
      'longitude': 77.6473,
    },
    {
      'name': 'BTM Layout, Bangalore',
      'address': 'BTM Layout, Bengaluru, Karnataka, India',
      'latitude': 12.9165,
      'longitude': 77.6101,
    },
    {
      'name': 'Marathahalli, Bangalore',
      'address': 'Marathahalli, Bengaluru, Karnataka, India',
      'latitude': 12.9591,
      'longitude': 77.6974,
    },
    {
      'name': 'Jayanagar, Bangalore',
      'address': 'Jayanagar, Bengaluru, Karnataka, India',
      'latitude': 12.9237,
      'longitude': 77.5838,
    },
  ];

  List<Map<String, dynamic>> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _filteredLocations = _popularLocations;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        title: const Text('Select Location'),
        elevation: 0,
        actions: [
          if (_selectedAddress != null)
            TextButton(
              onPressed: _handleConfirmLocation,
              child: const Text(
                'CONFIRM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.blue.shade600,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterLocations,
              decoration: InputDecoration(
                hintText: 'Search for a location...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterLocations('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          // Current Location Button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _getCurrentLocation,
              icon: _isLoading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              label: Text(_isLoading ? 'Getting location...' : 'Use Current Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          // Selected Location Display
          if (_selectedAddress != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade600),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Location:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          _selectedAddress!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Locations List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredLocations.length,
              itemBuilder: (context, index) {
                final location = _filteredLocations[index];
                final isSelected = _selectedAddress == location['address'];
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: isSelected ? 4 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? Colors.blue.shade600 : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
                    ),
                    title: Text(
                      location['name'],
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.blue.shade600 : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      location['address'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: Colors.blue.shade600)
                        : const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _selectLocation(location),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _filterLocations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLocations = _popularLocations;
      } else {
        _filteredLocations = _popularLocations
            .where((location) =>
                location['name'].toLowerCase().contains(query.toLowerCase()) ||
                location['address'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectLocation(Map<String, dynamic> location) {
    setState(() {
      _selectedAddress = location['address'];
      _selectedLatitude = location['latitude'];
      _selectedLongitude = location['longitude'];
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // For demo purposes, we'll use a mock address
      // In a real app, you would use reverse geocoding to get the actual address
      final mockAddress = 'Current Location (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})';

      setState(() {
        _selectedAddress = mockAddress;
        _selectedLatitude = position.latitude;
        _selectedLongitude = position.longitude;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Current location selected'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: $e'),
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

  void _handleConfirmLocation() {
    if (_selectedAddress != null && _selectedLatitude != null && _selectedLongitude != null) {
      Navigator.of(context).pop({
        'address': _selectedAddress,
        'latitude': _selectedLatitude,
        'longitude': _selectedLongitude,
      });
    }
  }
}