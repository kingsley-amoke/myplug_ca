import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/features/job/domain/models/job_type.dart';

class Job {
  final String? id;
  final String title;
  final String description;
  final JobType type;
  final double salary;
  final String company;
  final String companyLogo;
  final String location;
  final DateTime date;
  final List<String> requirements;

  const Job({
    this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.company,
    required this.companyLogo,
    required this.salary,
    required this.requirements,
    required this.date,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'] as String?,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: jobTypeFromString(map['type']),
      salary: (map['salary'] as num).toDouble(),
      location: map['location'] ?? '',
      company: map['company'] ?? '',
      companyLogo: map['companyLogo'] ?? '',
      date: DateTime.parse(map['date']),
      requirements: List<String>.from(map['requirements'] ?? []),
    );
  }

  toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'location': location,
      'company': company,
      'company_logo': companyLogo,
      'requirements': requirements,
      'salary': salary,
      'date': date.toIso8601String(),
    };
  }

  Job copyWith({
    String? id,
    String? title,
    String? description,
    JobType? type,
    String? location,
    String? company,
    String? companyLogo,
    List<String>? requirements,
    double? salary,
  }) {
    return Job(
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      location: location ?? this.location,
      company: company ?? this.company,
      companyLogo: companyLogo ?? this.companyLogo,
      salary: salary ?? this.salary,
      requirements: requirements ?? this.requirements,
      date: date,
    );
  }
}
