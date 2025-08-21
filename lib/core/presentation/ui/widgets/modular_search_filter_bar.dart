import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/features/job/domain/models/job_type.dart';
import 'package:myplug_ca/features/product/domain/models/myplug_shop.dart';

class ModularSearchFilterBar extends StatefulWidget {
  final Function(String searchTerm, Map<String, dynamic> filters) onSearch;
  final List<String> locations;
  final List<MyplugShop> categories;
  final List<JobType?> jobTypes;
  final bool showRating;
  final bool showSalary;
  final bool showPrice;
  final bool showFilterIcon; // ✅ new parameter

  const ModularSearchFilterBar({
    super.key,
    required this.onSearch,
    this.locations = const [],
    this.categories = const [],
    this.jobTypes = const [],
    this.showRating = false,
    this.showSalary = true,
    this.showPrice = false,
    this.showFilterIcon = true, // ✅ default value
  });

  @override
  State<ModularSearchFilterBar> createState() => _ModularSearchFilterBarState();
}

class _ModularSearchFilterBarState extends State<ModularSearchFilterBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  String? _selectedLocation;
  String? _selectedCategory;
  String? _selectedJobType;
  double? _priceValue;
  double? _salaryValue;
  double? _ratingValue;

  void _applyFilters() {
    final filters = {
      'location': _selectedLocation,
      'category': _selectedCategory,
      'jobType': _selectedJobType,
      if (widget.showPrice) 'price': _priceValue,
      if (widget.showSalary) 'salary': _salaryValue,
      if (widget.showRating) 'rating': _ratingValue,
    }..removeWhere((key, value) => value == null);
    widget.onSearch(_searchController.text.trim(), filters);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (widget.showFilterIcon) // ✅ only show if true
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => setState(() => _showFilters = !_showFilters),
              ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (_) => _applyFilters(),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              onPressed: _applyFilters,
            ),
          ],
        ),
        if (_showFilters &&
            widget.showFilterIcon) // ✅ filters depend on icon toggle
          _buildFilters(),
        if (widget.showFilterIcon)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('Clear Filters'),
                onPressed: () {
                  setState(() {
                    _selectedLocation = null;
                    _salaryValue = null;
                    _priceValue = null;
                    _selectedCategory = null;
                    _searchController.text = '';
                    _selectedJobType = null;
                    _ratingValue = null;
                  });
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          if (widget.locations.isNotEmpty)
            ExpansionTile(
              title: const Text('Location'),
              children: widget.locations.map((loc) {
                return RadioListTile<String>(
                  title: Text(loc),
                  value: loc,
                  groupValue: _selectedLocation,
                  onChanged: (value) =>
                      setState(() => _selectedLocation = value),
                );
              }).toList(),
            ),
          if (widget.showPrice)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Max Price"),
                ),
                Slider(
                  value: _priceValue ?? 1000,
                  min: 0,
                  max: 1000000,
                  divisions: 1000,
                  label: formatPrice(amount: _priceValue ?? 1000.00),
                  onChanged: (value) => setState(() => _priceValue = value),
                ),
              ],
            ),
          if (widget.showRating)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Max Rating"),
                ),
                Slider(
                  value: _ratingValue ?? 1,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _ratingValue != null ? _ratingValue.toString() : '1',
                  onChanged: (value) => setState(() => _ratingValue = value),
                ),
              ],
            ),
          if (widget.showSalary)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: Text("Min Salary"),
                ),
                Slider(
                  value: _salaryValue ?? 1000,
                  min: 0,
                  max: 1000000,
                  divisions: 100,
                  label: formatPrice(amount: _salaryValue ?? 1000.00),
                  onChanged: (value) => setState(() => _salaryValue = value),
                ),
              ],
            ),
          if (widget.categories.isNotEmpty)
            ExpansionTile(
              title: const Text('Category'),
              children: widget.categories.map((cat) {
                return RadioListTile<String>(
                  title: Text(cat.name),
                  value: cat.name,
                  groupValue: _selectedCategory,
                  onChanged: (value) =>
                      setState(() => _selectedCategory = value),
                );
              }).toList(),
            ),
          if (widget.jobTypes.isNotEmpty)
            ExpansionTile(
              title: const Text('Job Type'),
              children: widget.jobTypes.map((jt) {
                return RadioListTile<String>(
                  title: Text(jt!.name.toCapitalCase()),
                  value: jt.name,
                  groupValue: _selectedJobType,
                  onChanged: (value) =>
                      setState(() => _selectedJobType = value),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
