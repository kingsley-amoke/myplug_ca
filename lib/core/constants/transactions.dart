import 'package:myplug_ca/features/user/domain/models/transaction.dart';

List<Transaction> demoTransactions = [
  Transaction(
    id: '1',
    type: TransactionType.credit,
    description: 'Account funded successfully',
    amount: 4000,
    date: DateTime.now(),
  ),
  Transaction(
    id: '2',
    type: TransactionType.credit,
    description: 'Account funded successfully',
    amount: 23000,
    date: DateTime.now(),
  ),
  Transaction(
    id: '3',
    type: TransactionType.credit,
    description: 'Account funded successfully',
    amount: 4000,
    date: DateTime.now().add(const Duration(days: 2)),
  ),
   Transaction(
    id: '5',
    type: TransactionType.debit,
    description: 'Account funded successfully',
    amount: 5000,
    date: DateTime.now().add(const Duration(days: 12)),
  ),
   Transaction(
    id: '4',
    type: TransactionType.debit,
    description: 'Account funded successfully',
    amount: 40000,
    date: DateTime.now().add(const Duration(days: 12)),
  )
];
