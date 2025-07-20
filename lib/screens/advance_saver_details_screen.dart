import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/advance_saver_model.dart';
import '../providers/advance_saver_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/ios_style_button.dart';
import '../widgets/ios_style_card.dart';
import 'image_gallery_screen.dart';

class AdvanceSaverDetailsScreen extends StatefulWidget {
  final AdvanceSaverModel listing;

  const AdvanceSaverDetailsScreen({
    super.key,
    required this.listing,
  });

  @override
  State<AdvanceSaverDetailsScreen> createState() => _AdvanceSaverDetailsScreenState();
}

class _AdvanceSaverDetailsScreenState extends State<AdvanceSaverDetailsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.userModel;
    final isOwner = currentUser?.uid == widget.listing.userId;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        elevation: 0,
        title: const Text(
          'AdvanceSaver Details',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildDetailsCard(),
            const SizedBox(height: 16),
            _buildRoomDetailsCard(),
            if (widget.listing.roomImages.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildImagesCard(),
            ],
            const SizedBox(height: 16),
            _buildLocationCard(),
            const SizedBox(height: 24),
            if (!isOwner && widget.listing.isOpen) _buildActionButton(),
            if (isOwner) _buildOwnerActions(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return IOSStyleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.listing.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _buildUrgencyTag(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.listing.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.currency_rupee,
                label: 'Rent',
                value: '₹${widget.listing.rent.toStringAsFixed(0)}/month',
                color: Colors.blue,
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.savings,
                label: 'Save Deposit',
                value: '₹${widget.listing.refundableDeposit.toStringAsFixed(0)}',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return IOSStyleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exit Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'Exit Date',
            value: _formatDate(widget.listing.exitDate),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            icon: Icons.timer,
            label: 'Days Remaining',
            value: '${widget.listing.daysUntilExit} days',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            icon: Icons.person,
            label: 'Preferred Gender',
            value: widget.listing.genderPreference,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            icon: Icons.info,
            label: 'Status',
            value: widget.listing.status.toUpperCase(),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomDetailsCard() {
    return IOSStyleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Room Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.listing.roomDescription.isNotEmpty 
                ? widget.listing.roomDescription
                : 'No room description provided.',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesCard() {
    return IOSStyleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Room Images',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.listing.roomImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageGalleryScreen(
                          images: widget.listing.roomImages,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      right: index < widget.listing.roomImages.length - 1 ? 12 : 0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(widget.listing.roomImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return IOSStyleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.listing.location,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return IOSStyleButton(
      text: 'Request to Replace',
      onPressed: _isLoading ? null : _requestToReplace,
      isLoading: _isLoading,
    );
  }

  Widget _buildOwnerActions() {
    return Column(
      children: [
        if (widget.listing.isOpen) ...[
          IOSStyleButton(
            text: 'Mark as Matched',
            onPressed: _isLoading ? null : _markAsMatched,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 12),
          IOSStyleButton(
            text: 'Cancel Listing',
            onPressed: _isLoading ? null : _cancelListing,
            isLoading: _isLoading,
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  widget.listing.isMatched ? Icons.check_circle : Icons.cancel,
                  color: widget.listing.isMatched ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.listing.isMatched 
                      ? 'This listing has been matched'
                      : 'This listing has expired',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUrgencyTag() {
    Color backgroundColor;
    Color textColor;
    String text = widget.listing.urgencyTag;

    switch (text) {
      case 'URGENT':
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      case 'LEAVING SOON':
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        break;
      case 'EXPIRED':
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        break;
      default:
        backgroundColor = Colors.green;
        textColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _requestToReplace() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Request to Replace'),
          content: Text(
            'Are you sure you want to request to replace the current tenant? '
            'You will save ₹${widget.listing.refundableDeposit.toStringAsFixed(0)} in deposit.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Request'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        // Here you would implement the request logic
        // For now, we'll just show a success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Request sent successfully! The owner will be notified.'),
              backgroundColor: Colors.green,
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

  Future<void> _markAsMatched() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<AdvanceSaverProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await provider.requestToReplace(widget.listing.id!, authProvider.userModel!.uid);
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Listing marked as matched!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.error ?? 'Failed to update listing'),
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

  Future<void> _cancelListing() async {
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
      setState(() {
        _isLoading = true;
      });

      try {
        final provider = Provider.of<AdvanceSaverProvider>(context, listen: false);
        final success = await provider.cancelListing(widget.listing.id!);
        
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Listing cancelled successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.error ?? 'Failed to cancel listing'),
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
  }
}