import 'package:flutter/material.dart';

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
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_sections[_selectedIndex].title) {
      case "Overview":
        return _overviewSection();
      case "Users":
        return _usersSection();
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

  Widget _overviewSection() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: const [
        _StatCard(title: "Total Users", value: "245"),
        _StatCard(title: "Active Jobs", value: "32"),
        _StatCard(title: "Products", value: "180"),
        _StatCard(title: "Transactions", value: "₦1.2M"),
      ],
    );
  }

  Widget _usersSection() {
    return const Center(child: Text("Manage Users 👤"));
  }

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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 8),
            Text(value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    )),
          ],
        ),
      ),
    );
  }
}
