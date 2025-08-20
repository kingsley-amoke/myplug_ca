class JobApplication {
  final String? id;
  final String jobId;
  final String userId;
  final String resumeUrl;
  final String coverLetterUrl;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  JobApplication({
    this.id,
    required this.jobId,
    required this.userId,
    required this.resumeUrl,
    required this.coverLetterUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  /// Convert object to map (for Firestore / JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobId': jobId,
      'userId': userId,
      'resumeUrl': resumeUrl,
      'coverLetterUrl': coverLetterUrl,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    };
  }

  /// Create object from map (Firestore / JSON)
  factory JobApplication.fromMap(Map<String, dynamic> map) {
    return JobApplication(
      id: map['id'],
      jobId: map['jobId'] ?? '',
      userId: map['userId'] ?? '',
      resumeUrl: map['resumeUrl'] ?? '',
      coverLetterUrl: map['coverLetterUrl'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  /// CopyWith to create modified copies
  JobApplication copyWith({
    String? id,
    String? jobId,
    String? userId,
    String? resumeUrl,
    String? coverLetterUrl,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return JobApplication(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      userId: userId ?? this.userId,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      coverLetterUrl: coverLetterUrl ?? this.coverLetterUrl,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
