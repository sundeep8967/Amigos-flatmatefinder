import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/advance_saver_provider.dart';
import '../providers/auth_provider.dart';
import '../models/advance_saver_model.dart';
import 'create_advance_saver_listing_screen.dart';
import 'advance_saver_details_screen.dart';

class AdvanceSaverScreen extends StatefulWidget {
  const AdvanceSaverScreen({super.key});

  @override
  State<AdvanceSaverScreen> createState() => _AdvanceSaverScreenState();
}

class _AdvanceSaverScreenState extends State<AdvanceSaverScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Urgent', 'No Deposit', 'Immediate'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<AdvanceSaverProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    await Future.wait([
      provider.loadOpenListings(),
      provider.loadUrgentListings(),
      if (authProvider.userModel != null)
        provider.loadUserListings(authProvider.userModel!.uid),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text(
                'AdvanceSaver',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              pinned: true,
              floating: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAdvanceSaverListingScreen(),
                      ),
                    );
                  },
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: const [
                  Tab(text: 'Browse'),
                  Tab(text: 'My Listings'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildBrowseTab(),
            _buildMyListingsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateAdvanceSaverListingScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.save_alt),
        label: const Text('Save Deposit'),
      ),
    );
  }

  Widget _buildBrowseTab() {
    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: Consumer<AdvanceSaverProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(provider.error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final filteredListings = _getFilteredListings(provider.listings);

              if (filteredListings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.savings_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No AdvanceSaver Listings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedFilter == 'All' 
                            ? 'No one is looking to save their deposit right now.'
                            : 'No listings match your filter.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateAdvanceSaverListingScreen(),
                            ),
                          );
                        },
                        child: Text('Create Listing'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _loadData,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredListings.length,
                  itemBuilder: (context, index) {
                    return _buildListingCard(filteredListings[index]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMyListingsTab() {
    return Consumer<AdvanceSaverProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(provider.error!, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadData,
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (provider.userListings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.savings_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No Listings Yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first AdvanceSaver listing to save your deposit when leaving.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAdvanceSaverListingScreen(),
                      ),
                    );
                  },
                  child: Text('Create Listing'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.userListings.length,
            itemBuilder: (context, index) {
              return _buildListingCard(provider.userListings[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.blue.withValues(alpha: 0.1),
              checkmarkColor: Colors.blue,
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  List<AdvanceSaverModel> _getFilteredListings(List<AdvanceSaverModel> listings) {
    switch (_selectedFilter) {
      case 'Urgent':
        return listings.where((l) => l.daysUntilExit <= 7).toList();
      case 'No Deposit':
        return listings.where((l) => l.refundableDeposit == 0).toList();
      case 'Immediate':
        return listings.where((l) => l.daysUntilExit <= 3).toList();
      default:
        return listings;
    }
  }

  Widget _buildListingCard(AdvanceSaverModel listing) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdvanceSaverDetailsScreen(
                listing: listing,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with urgency tag
              Row(
                children: [
                  Expanded(
                    child: Text(
                      listing.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildUrgencyTag(listing),
                ],
              ),
              const SizedBox(height: 8),
              
              // Location
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      listing.location,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Key details
              Row(
                children: [
                  _buildDetailChip(
                    icon: Icons.attach_money,
                    label: '\$${listing.rent.toStringAsFixed(0)}/mo',
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  if (listing.refundableDeposit > 0)
                    _buildDetailChip(
                      icon: Icons.savings,
                      label: '\$${listing.refundableDeposit.toStringAsFixed(0)} saved',
                      color: Colors.orange,
                    ),
                  const SizedBox(width: 8),
                  _buildDetailChip(
                    icon: Icons.schedule,
                    label: '${listing.daysUntilExit} days',
                    color: listing.isUrgent ? Colors.red : Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Description preview
              Text(
                listing.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              
              // Owner actions would be shown in details screen
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUrgencyTag(AdvanceSaverModel listing) {
    Color color;
    String text = listing.urgencyTag;
    
    switch (listing.urgencyTag) {
      case 'URGENT':
        color = Colors.red;
        break;
      case 'LEAVING SOON':
        color = Colors.orange;
        break;
      case 'EXPIRED':
        color = Colors.grey;
        break;
      default:
        color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerActions(AdvanceSaverModel listing) {
    return Row(
      children: [
        Icon(
          listing.isMatched ? Icons.check_circle : Icons.pending,
          size: 16,
          color: listing.isMatched ? Colors.green : Colors.orange,
        ),
        const SizedBox(width: 4),
        Text(
          listing.isMatched ? 'Matched!' : 'Waiting for match',
          style: TextStyle(
            color: listing.isMatched ? Colors.green : Colors.orange,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        if (!listing.isMatched && !listing.isExpired)
          TextButton(
            onPressed: () => _cancelListing(listing),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Future<void> _cancelListing(AdvanceSaverModel listing) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Listing'),
        content: const Text('Are you sure you want to cancel this listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = Provider.of<AdvanceSaverProvider>(context, listen: false);
      final success = await provider.cancelListing(listing.id!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Listing cancelled' : 'Failed to cancel listing'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}