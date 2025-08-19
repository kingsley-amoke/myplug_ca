import 'package:flutter/material.dart';
import 'package:myplug_ca/features/job/domain/models/job_type.dart';

class FilterOptions {
  final RangeValues? salaryRange;
  final String? location;
  final RangeValues? priceRange;
  final List<String>? selectedCategories;
  final List<JobType>? selectedJobTypes;
  final String searchTerm;

  FilterOptions({
    this.salaryRange,
    this.location,
    this.priceRange,
    this.selectedCategories,
    this.selectedJobTypes,
    required this.searchTerm,
  });

  FilterOptions copyWith({
    RangeValues? salaryRange,
    String? location,
    RangeValues? priceRange,
    List<String>? selectedCategories,
    List<JobType>? selectedJobTypes,
    String? searchTerm,
  }) {
    return FilterOptions(
      salaryRange: salaryRange ?? this.salaryRange,
      location: location ?? this.location,
      priceRange: priceRange ?? this.priceRange,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedJobTypes: selectedJobTypes ?? this.selectedJobTypes,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}
