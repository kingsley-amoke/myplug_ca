class Transaction {
  final String id;
  final TransactionType type;
  final String description;
  final double amount;
  final DateTime date;

  Transaction({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) => Transaction(
        id: map['id'],
        type: TransactionType.values.firstWhere(
          (e) => e.name == map['type'],
          orElse: () => TransactionType.debit,
        ),
        description: map['description'],
        amount: (map['amount'] as num).toDouble(),
        date: DateTime.parse(map['date']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type.name, // store as string
        'description': description,
        'amount': amount,
        'date': date.toIso8601String(),
      };
}

enum TransactionType {
  debit,
  credit,
}
