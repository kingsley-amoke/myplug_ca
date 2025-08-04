class Referee {
  final String id;
  final String email;

  Referee({
    required this.id,
    required this.email,
  });

  factory Referee.fromMap(Map<String, dynamic> map) => Referee(
        id: map['id'],
        email: map['email'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
      };
}
