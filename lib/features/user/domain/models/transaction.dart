class Transaction {
  final String id;
  final String type;
  final double amount;
  final DateTime date;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) => Transaction(
        id: map['id'],
        type: map['type'],
        amount: (map['amount'] as num).toDouble(),
        date: DateTime.parse(map['date']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'amount': amount,
        'date': date.toIso8601String(),
      };
}
