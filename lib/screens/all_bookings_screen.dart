import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';

class AllBookingsScreen extends StatefulWidget {
  const AllBookingsScreen({super.key});

  @override
  State<AllBookingsScreen> createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsScreen> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await ApiService.getAllBookings();
      setState(() {
        bookings = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _deleteSingleBooking(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff1E293B),
        title:
            const Text('Delete Booking', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this booking?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService.deleteBooking(id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking Deleted Successfully')));
        _loadBookings();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _deleteAllBookings() async {
    if (bookings.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff1E293B),
        title: const Text('Delete All Bookings',
            style: TextStyle(color: Colors.white)),
        content: const Text(
            'Are you sure you want to delete ALL bookings? This cannot be undone.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Delete All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Try deleting 'all' first if backend supports it
        await ApiService.deleteBooking('all');

        // Loop through and delete each if 'all' didn't work as expected
        for (var b in bookings) {
          final id = b['id'];
          if (id != null) {
            await ApiService.deleteBooking(id.toString());
          }
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All Bookings Deleted Successfully')));
        _loadBookings();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        _loadBookings(); // reload to reflect any partial deletions
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xff1E293B),
        title: Text(
          'All Bookings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (bookings.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
              tooltip: 'Delete All',
              onPressed: _deleteAllBookings,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          "Error loading bookings\n$errorMessage",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    if (bookings.isEmpty) {
      return const Center(
        child: Text(
          "No bookings found",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final id = booking['id']?.toString() ?? '';
        final customerName = booking['customer_name'] ?? 'No Name';
        final serviceName = booking['service_name'] ?? 'No Service';
        final bookingDate = booking['booking_date'] ?? '';
        final bookingTime = booking['booking_time'] ?? '';
        final status = booking['status'] ?? 'Pending';
        final email = booking['email'] ?? '';
        final phone = booking['phone'] ?? '';
        final address = booking['address'] ?? '';
        final notes = booking['notes'] ?? '';
        final createdAt = booking['created_at'] ?? '';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceName,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Booking #$id',
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: status.toLowerCase() == 'confirmed'
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.poppins(
                        color: status.toLowerCase() == 'confirmed'
                            ? Colors.green
                            : Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _deleteSingleBooking(id),
                    child: const Icon(Icons.delete_outline,
                        color: Colors.redAccent),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (customerName.isNotEmpty) ...[
                _buildDetailRow(Icons.person, 'Customer', customerName),
                const SizedBox(height: 8),
              ],
              if (phone.isNotEmpty) ...[
                _buildDetailRow(Icons.phone, 'Phone', phone),
                const SizedBox(height: 8),
              ],
              if (email.isNotEmpty) ...[
                _buildDetailRow(Icons.email, 'Email', email),
                const SizedBox(height: 8),
              ],
              if (address.isNotEmpty) ...[
                _buildDetailRow(Icons.location_on, 'Address', address),
                const SizedBox(height: 8),
              ],
              if (bookingDate.isNotEmpty || bookingTime.isNotEmpty) ...[
                _buildDetailRow(Icons.calendar_today, 'Booking',
                    '$bookingDate at $bookingTime'),
                const SizedBox(height: 8),
              ],
              if (notes.isNotEmpty) ...[
                _buildDetailRow(Icons.note, 'Notes', notes),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 4),
              Divider(color: Colors.white.withValues(alpha: 0.1)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Created: $createdAt',
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.purple[300]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
