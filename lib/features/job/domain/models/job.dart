class Job {
  final String? id;
  final String title;
  final String description;
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
    required this.location,
    required this.company,
    required this.companyLogo,
    required this.salary,
    required this.requirements,
    required this.date,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      location: map['location'],
      company: map['company'],
      companyLogo: map['company_logo'],
      salary: map['salary'],
      requirements: map['requirements'],
      date: DateTime.parse(map['date']),
    );
  }

  toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
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
    String? location,
    String? company,
    String? companyLogo,
    String? requirement,
    double? salary,
  }) {
    return Job(
        title: title ?? this.title,
        description: description ?? this.description,
        location: location ?? this.location,
        company: company ?? this.company,
        companyLogo: companyLogo ?? this.companyLogo,
        salary: salary ?? this.salary,
        requirements:
            requirement != null ? [...requirements, requirement] : requirements,
        date: date);
  }
}
