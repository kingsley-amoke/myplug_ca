import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/chat/presentation/ui/pages/messagepage.dart';
import 'package:myplug_ca/features/chat/presentation/viewmodels/chat_provider.dart';
import 'package:myplug_ca/features/job/domain/models/job.dart';
import 'package:myplug_ca/features/job/presentation/ui/widgets/job_item.dart';
import 'package:myplug_ca/features/job/presentation/viewmodels/job_provider.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';

import 'package:myplug_ca/features/product/presentation/ui/widgets/product_grid.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/profile.dart';
import 'package:myplug_ca/features/user/presentation/ui/widgets/user_card.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class GlobalSearchPage extends StatefulWidget {
  const GlobalSearchPage({super.key, required this.searchTerm});

  final String searchTerm;

  @override
  State<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  // String _searchTerm = "";

  // Assume these are fetched or injected from repositories/viewmodels
  List<MyplugUser> _allUsers = [];
  List<Product> _allProducts = [];
  List<Job> _allJobs = [];

  List<MyplugUser> _filteredUsers = [];
  List<Product> _filteredProducts = [];
  List<Job> _filteredJobs = [];

  @override
  void initState() {
    super.initState();

    _allJobs = context.read<JobProvider>().jobs;
    _allProducts = context.read<ProductProvider>().products;
    _allUsers = context.read<UserProvider>().allUsers;

// //Users fitering
    _filteredUsers = _allUsers.where((user) {
      if (widget.searchTerm.trim().isEmpty) return false;

      final lower = widget.searchTerm.toLowerCase();
      final loggedUserId = context.read<UserProvider>().myplugUser?.id;

      final matchesSearch = user.firstName!.toLowerCase().contains(lower) ||
          user.lastName!.toLowerCase().contains(lower) ||
          user.location!.state!.toLowerCase().contains(lower) ||
          user.email.toLowerCase().contains(lower) ||
          user.skills.any((s) => s.name.toLowerCase().contains(lower));

      // must match search and not be the logged in user
      return matchesSearch && user.id != loggedUserId;
    }).toList();

    // Products filtering
    _filteredProducts = _allProducts.where((product) {
      if (widget.searchTerm.trim().isEmpty) return false;
      final lower = widget.searchTerm.toLowerCase();
      return product.title.toLowerCase().contains(lower) ||
          (product.description.toLowerCase().contains(lower)) ||
          product.location.toLowerCase().contains(lower);
    }).toList();

    // Jobs filtering
    _filteredJobs = _allJobs.where((job) {
      if (widget.searchTerm.trim().isEmpty) return false;
      final lower = widget.searchTerm.toLowerCase();
      return job.title.toLowerCase().contains(lower) ||
          (job.description.toLowerCase().contains(lower)) ||
          job.location.toLowerCase().contains(lower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final provider = context.read<UserProvider>();
    return Scaffold(
      appBar: myAppbar(context, title: 'Results'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_filteredUsers.isNotEmpty)
              _buildSection(
                title: "Users",
                children: _filteredUsers
                    .map(
                      (u) => UserCard(
                        user: u,
                        onViewProfile: () {
                          navigator.push(
                            MaterialPageRoute(
                              builder: (_) => ProfilePage(user: u),
                            ),
                          );
                        },
                        onBook: () {
                          if (provider.myplugUser != null) {
                            context
                                .read<ChatProvider>()
                                .createOrGetConversation(
                                    provider.myplugUser!.id!, u.id!)
                                .then((conversationId) {
                              navigator.push(
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    otherUser: u,
                                    conversationId: conversationId,
                                  ),
                                ),
                              );
                            });
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            if (_filteredProducts.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Products',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ProductGrid(products: _filteredProducts),
                ],
              ),
            if (_filteredJobs.isNotEmpty)
              _buildSection(
                title: "Jobs",
                children: _filteredJobs
                    .map(
                      (j) => JobItem(job: j),
                    )
                    .toList(),
              ),
            if (_filteredUsers.isEmpty &&
                _filteredProducts.isEmpty &&
                _filteredJobs.isEmpty &&
                widget.searchTerm.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "No results found for '${widget.searchTerm}'",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}
