import 'package:addminsaid_mycity/screens/add_service_screen.dart';
import 'package:addminsaid_mycity/screens/all_bookings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/service_model.dart';
import '../services/api_service.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/service_card.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  List<ServiceModel> services = [];

  int totalUsers = 0;
  int totalBookings = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadServices();
    loadUsersCount();
    loadBookingsCount();
  }

  // ================= LOAD USERS COUNT =================

  Future<void> loadUsersCount() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').count().get();
      setState(() {
        totalUsers = snapshot.count ?? 0;
      });
    } catch (e) {
      debugPrint('Error fetching users: $e');
    }
  }

  // ================= LOAD BOOKINGS COUNT =================

  Future<void> loadBookingsCount() async {
    try {
      final count = await ApiService.getTotalBookings();
      setState(() {
        totalBookings = count;
      });
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
    }
  }

  // ================= REFRESH DATA =================

  Future<void> refreshData() async {
    try {
      final data = await ApiService.getServices();
      final snapshot =
          await FirebaseFirestore.instance.collection('users').count().get();
      final bookingsCount = await ApiService.getTotalBookings();
      setState(() {
        services = data;
        totalUsers = snapshot.count ?? 0;
        totalBookings = bookingsCount;
      });
    } catch (e) {
      debugPrint('Error refreshing data: $e');
    }
  }

  // ================= LOAD SERVICES =================

  Future<void> loadServices() async {
    try {
      setState(() {
        loading = true;
      });

      final data = await ApiService.getServices();

      setState(() {
        services = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      debugPrint(e.toString());
    }
  }

  // ================= DELETE SERVICE =================

  Future<void> deleteService(String id) async {
    try {
      await ApiService.deleteService(id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Service Deleted Successfully'),
        ),
      );

      loadServices();
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  // ================= SHOW ALL SERVICES =================

  void showAllServices() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff1E293B),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'All Services',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          service.name,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          service.category,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
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
      },
    );
  }

  // ================= SHOW ALL USERS =================

  void showAllUsers() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff1E293B),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'All Users',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text("Error loading users",
                              style: TextStyle(color: Colors.white)));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text("No users found",
                              style: TextStyle(color: Colors.white)));
                    }

                    final users = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user =
                            users[index].data() as Map<String, dynamic>;
                        debugPrint('User data from Firestore: $user');
                        final name =
                            user['name'] ?? user['displayName'] ?? 'No Name';
                        final email = user['email'] ?? 'No Email';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.purple,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            title: Text(
                              name,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              email,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= SHOW CATEGORIES =================

  void showCategories() {
    final categories = services.map((e) => e.category).toSet().toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff1E293B),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'All Categories',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    final total = services
                        .where(
                          (e) => e.category == category,
                        )
                        .length;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          category,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '$total Services',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white54,
                          size: 18,
                        ),
                        onTap: () {
                          Navigator.pop(context);

                          final filteredServices = services
                              .where(
                                (e) => e.category == category,
                              )
                              .toList();

                          showCategoryServices(
                            category,
                            filteredServices,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= CATEGORY SERVICES =================

  void showCategoryServices(
    String category,
    List<ServiceModel> filteredServices,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff0F172A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                category,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = filteredServices[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          service.name,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          service.phone,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
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
      },
    );
  }

  // ================= MAIN UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      // ================= FLOATING BUTTON =================

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddServiceScreen(),
            ),
          );

          if (result == true) {
            loadServices();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),

      // ================= BODY =================

      body: SafeArea(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= TITLE =================

                      Text(
                        'Admin Panel',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ================= DASHBOARD =================

                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: showAllServices,
                                  child: AspectRatio(
                                    aspectRatio: 1.1,
                                    child: DashboardCard(
                                      title: 'Services',
                                      value: services.length.toString(),
                                      icon: Icons.miscellaneous_services,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  onTap: showAllUsers,
                                  child: AspectRatio(
                                    aspectRatio: 1.1,
                                    child: DashboardCard(
                                      title: 'Users',
                                      value: totalUsers.toString(),
                                      icon: Icons.people,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: showCategories,
                                  child: AspectRatio(
                                    aspectRatio: 1.1,
                                    child: DashboardCard(
                                      title: 'Categories',
                                      value: services
                                          .map((e) => e.category)
                                          .toSet()
                                          .length
                                          .toString(),
                                      icon: Icons.category,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const AllBookingsScreen(),
                                      ),
                                    );
                                    // Refresh bookings count when returning
                                    loadBookingsCount();
                                  },
                                  child: AspectRatio(
                                    aspectRatio: 1.1,
                                    child: DashboardCard(
                                      title: 'Bookings',
                                      value: totalBookings.toString(),
                                      icon: Icons.book_online,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // ================= ALL SERVICES =================

                      Text(
                        'All Services',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ================= SERVICES LIST =================

                      services.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Text(
                                  'No Services Found',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: services.length,
                              itemBuilder: (context, index) {
                                final service = services[index];

                                return ServiceCard(
                                  service: service,

                                  // ================= EDIT =================

                                  onEdit: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddServiceScreen(
                                          service: service,
                                        ),
                                      ),
                                    );

                                    if (result == true) {
                                      loadServices();
                                    }
                                  },

                                  // ================= DELETE =================

                                  onDelete: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        backgroundColor:
                                            const Color(0xff1E293B),
                                        title: const Text(
                                          'Delete Service',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        content: const Text(
                                          'Are you sure you want to delete this service?',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);

                                              await deleteService(
                                                service.id,
                                              );
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
