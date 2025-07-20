import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/flat_provider.dart';
import '../providers/request_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/ios_style_form_field.dart';
import 'create_flat_listing_screen.dart';
import 'flat_details_screen.dart';
import 'filter_screen.dart';
import 'requests_screen.dart';
import 'chat_list_screen.dart';
import 'settings_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'lifestyle_preferences_screen.dart';
import 'advance_saver_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> _currentFilters = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final flatProvider = Provider.of<FlatProvider>(context, listen: false);
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    final user = authProvider.userModel;
    
    if (user != null && user.role == 'host') {
      flatProvider.loadHostFlats(user.uid);
      requestProvider.loadHostRequests(user.uid);
    } else if (user != null && user.role == 'seeker') {
      _loadFlatsWithFilters();
      requestProvider.loadSeekerRequests(user.uid);
      favoritesProvider.loadFavorites(user.uid);
    }
  }

  void _loadFlatsWithFilters() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final flatProvider = Provider.of<FlatProvider>(context, listen: false);
    final user = authProvider.userModel;
    
    if (user != null) {
      flatProvider.loadAvailableFlats(
        genderPreference: _currentFilters['genderPreference'] ?? user.gender,
        maxRent: _currentFilters['maxRent']?.toDouble() ?? user.budget,
        location: _currentFilters['location'] ?? user.preferredLocation,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.userModel;
        
        if (user?.role == 'host') {
          return _buildHostDashboard(user!);
        } else {
          return _buildSeekerDashboard(user!);
        }
      },
    );
  }

  Widget _buildHostDashboard(user) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Host Dashboard',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        ),
        toolbarHeight: 100,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _navigateToSettings(),
          ),
        ],
      ),
      body: Consumer<FlatProvider>(
        builder: (context, flatProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await flatProvider.loadHostFlats(user.uid);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  _buildWelcomeCard(user, isHost: true),
                  
                  const SizedBox(height: 20),
                  
                  // Quick Stats
                  _buildHostStats(flatProvider.hostFlats),
                  
                  const SizedBox(height: 20),
                  
                  // Action Buttons Section
                  IOSStyleSection(
                    title: 'Quick Actions',
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
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: 'Add New Listing',
                        subtitle: 'Create a new flat listing',
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _navigateToCreateListing(),
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
                            Icons.inbox_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: 'View Requests',
                        subtitle: 'Manage incoming requests',
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _navigateToRequests(),
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
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: 'Messages',
                        subtitle: 'Chat with potential tenants',
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _navigateToChats(),
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
                            Icons.savings,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: 'AdvanceSaver',
                        subtitle: 'Save deposit when leaving',
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _navigateToAdvanceSaver(),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // My Listings Section
                  const Text(
                    'My Listings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Listings
                  if (flatProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (flatProvider.hostFlats.isEmpty)
                    _buildEmptyState(isHost: true)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: flatProvider.hostFlats.length,
                      itemBuilder: (context, index) {
                        final flat = flatProvider.hostFlats[index];
                        return _buildFlatCard(flat, isHost: true);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSeekerDashboard(user) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find Flats',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        ),
        toolbarHeight: 100,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined),
            onPressed: _showFilterScreen,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _navigateToSettings(),
          ),
        ],
      ),
      body: Consumer<FlatProvider>(
        builder: (context, flatProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await flatProvider.loadAvailableFlats(
                genderPreference: user.gender,
                maxRent: user.budget,
                location: user.preferredLocation,
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  _buildWelcomeCard(user, isHost: false),
                  
                  const SizedBox(height: 20),
                  
                  // Quick Actions Section
                  IOSStyleSection(
                    title: 'Quick Actions',
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
                            Icons.tune_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: 'Filter Search',
                        subtitle: 'Customize your search preferences',
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: _showFilterScreen,
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
                            Icons.favorite_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: 'Favorites',
                        subtitle: 'View your saved flats',
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _navigateToFavorites(),
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
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: 'Messages',
                        subtitle: 'Chat with hosts',
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _navigateToChats(),
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
                            Icons.savings,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: 'AdvanceSaver',
                        subtitle: 'Find no-deposit flats',
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _navigateToAdvanceSaver(),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Personalized Recommendations
                  _buildRecommendationsSection(),
                  
                  const SizedBox(height: 20),
                  
                  // Search Bar
                  GestureDetector(
                    onTap: () => _navigateToSearch(),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey.shade500),
                          const SizedBox(width: 12),
                          Text(
                            'Search flats, locations...',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Available Flats Section
                  const Text(
                    'Available Flats',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Flats List
                  if (flatProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (flatProvider.availableFlats.isEmpty)
                    _buildEmptyState(isHost: false)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: flatProvider.availableFlats.length,
                      itemBuilder: (context, index) {
                        final flat = flatProvider.availableFlats[index];
                        return _buildFlatCard(flat, isHost: false);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeCard(user, {required bool isHost}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: isHost 
                ? [Colors.green.shade400, Colors.green.shade600]
                : [Colors.blue.shade400, Colors.blue.shade600],
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: user.profilePicture != null
                  ? NetworkImage(user.profilePicture!)
                  : null,
              backgroundColor: Colors.white,
              child: user.profilePicture == null
                  ? const Icon(Icons.person, size: 30, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${user.name}!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    isHost 
                        ? 'Manage your flat listings'
                        : 'Find your perfect flatmate',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHostStats(List<dynamic> flats) {
    final activeFlats = flats.where((flat) => flat.isActive).length;
    final totalSpots = flats.fold<int>(0, (sum, flat) => sum + (flat.availableSpots as int));
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Active Listings',
            activeFlats.toString(),
            Icons.home,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Available Spots',
            totalSpots.toString(),
            Icons.people,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total Listings',
            flats.length.toString(),
            Icons.list,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlatCard(flat, {required bool isHost}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (flat.images.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                flat.images.first,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        flat.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isHost)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: flat.isActive ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          flat.isActive ? 'Active' : 'Inactive',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        flat.location,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rs.${flat.rentPerHead.toStringAsFixed(0)}/month',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      '${flat.availableSpots} spots • ${flat.flatType}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                
                if (!isHost) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<FavoritesProvider>(
                          builder: (context, favoritesProvider, child) {
                            final isFavorite = favoritesProvider.isFavorite(flat.id!);
                            return OutlinedButton.icon(
                              onPressed: () => _toggleFavorite(flat.id!),
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                size: 16,
                                color: isFavorite ? Colors.pink.shade600 : null,
                              ),
                              label: Text(isFavorite ? 'Saved' : 'Save'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isFavorite ? Colors.pink.shade600 : null,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _navigateToFlatDetails(flat),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('View Details'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({required bool isHost}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              isHost ? Icons.home_outlined : Icons.search_off,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isHost 
                  ? 'No listings yet'
                  : 'No flats found',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isHost 
                  ? 'Create your first flat listing to get started'
                  : 'Try adjusting your filters or check back later',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            if (isHost) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _navigateToCreateListing(),
                icon: const Icon(Icons.add),
                label: const Text('Create Listing'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToCreateListing() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const CreateFlatListingScreen(),
      ),
    );
    
    if (result == true) {
      // Refresh the listings
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final flatProvider = Provider.of<FlatProvider>(context, listen: false);
      final user = authProvider.userModel;
      
      if (user != null) {
        await flatProvider.loadHostFlats(user.uid);
      }
    }
  }

  void _navigateToFlatDetails(flat) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FlatDetailsScreen(flat: flat),
      ),
    );
  }

  void _navigateToRequests() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RequestsScreen(),
      ),
    );
  }

  void _navigateToChats() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatListScreen(),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _navigateToSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      ),
    );
  }

  void _navigateToFavorites() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FavoritesScreen(),
      ),
    );
  }

  void _navigateToAdvanceSaver() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AdvanceSaverScreen(),
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.userModel;
    
    if (user?.role != 'seeker' || user?.preferences == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recommended for You',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LifestylePreferencesScreen(),
                ),
              ),
              child: const Text('Update Preferences'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.purple.shade50],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.blue.shade600, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Smart Matching Active',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'We\'re showing flats based on your lifestyle preferences',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _toggleFavorite(String flatId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      final success = await favoritesProvider.toggleFavorite(
        authProvider.user!.uid,
        flatId,
      );
      
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(favoritesProvider.error ?? 'Failed to update favorites'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showFilterScreen() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => FilterScreen(currentFilters: _currentFilters),
      ),
    );
    
    if (result != null) {
      setState(() {
        _currentFilters = result;
      });
      _loadFlatsWithFilters();
    }
  }
}