import 'package:flutter/material.dart';
import 'package:myplug_ca/features/admin/presentation/ui/widgets/overview.dart';
import 'package:myplug_ca/features/admin/presentation/ui/widgets/users.dart';
import 'package:myplug_ca/features/job/presentation/viewmodels/job_provider.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class DashboardItem {
  final String title;
  final IconData icon;

  const DashboardItem({required this.icon, required this.title});
}

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  final List<DashboardItem> _sections = const [
    DashboardItem(
      icon: Icons.analytics,
      title: "Overview",
    ),
    DashboardItem(
      icon: Icons.group,
      title: "Users",
    ),
    DashboardItem(
      icon: Icons.work,
      title: "Jobs",
    ),
    DashboardItem(
      icon: Icons.shop,
      title: "Products",
    ),
    DashboardItem(
      icon: Icons.receipt_long,
      title: "Transactions",
    ),
    DashboardItem(
      icon: Icons.card_membership,
      title: "Subscriptions",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     // TODO: implement notifications
          //   },
          //   icon: const Icon(Icons.notifications),
          // ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            selectedIndex: _selectedIndex,
            selectedIconTheme: const IconThemeData(color: Colors.white),
            onDestinationSelected: (int index) {
              setState(() => _selectedIndex = index);
            },
            labelType: NavigationRailLabelType.all,
            destinations: _sections
                .map((DashboardItem e) => NavigationRailDestination(
                      icon: Icon(e.icon),
                      label: Text(e.title),
                    ))
                .toList(),
          ),

          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildContent(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final int noOfUsers = context.watch<UserProvider>().allUsers.length;
    final int noOfProducts = context.watch<ProductProvider>().products.length;
    final int noOfJobs = context.watch<JobProvider>().jobs.length;

    switch (_sections[_selectedIndex].title) {
      case "Overview":
        return overviewSection(
          noOfJobs: noOfJobs,
          noOfProducts: noOfProducts,
          noOfUsers: noOfUsers,
          sumOfTransactions: 5090000000,
        );
      case "Users":
        return UsersSection();
      case "Jobs":
        return _jobsSection();
      case "Products":
        return _productsSection();
      case "Portfolios":
        return _portfoliosSection();
      case "Chats":
        return _chatsSection();
      case "Transactions":
        return _transactionsSection();
      case "Subscriptions":
        return _subscriptionsSection();
      case "Settings":
        return _settingsSection();
      default:
        return const Center(child: Text("Section not implemented yet"));
    }
  }

  // ----------------- Section Widgets -----------------

  Widget _jobsSection() {
    return const Center(child: Text("Manage Jobs 💼"));
  }

  Widget _productsSection() {
    return const Center(child: Text("Manage Products 🛒"));
  }

  Widget _portfoliosSection() {
    return const Center(child: Text("Manage Portfolios 📂"));
  }

  Widget _chatsSection() {
    return const Center(child: Text("Monitor Chats 💬"));
  }

  Widget _transactionsSection() {
    return const Center(child: Text("View Transactions 💳"));
  }

  Widget _subscriptionsSection() {
    return const Center(child: Text("Manage Subscriptions 🔑"));
  }

  Widget _settingsSection() {
    return const Center(child: Text("App Settings ⚙️"));
  }
}
