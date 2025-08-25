import 'dart:async';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fixnbuy/core/config/config.dart';
import 'package:fixnbuy/features/subscription/domain/models/subscription.dart';

class UserSubCard extends StatefulWidget {
  final Subscription subscription;
  final String? username;
  final bool isAdmin;
  final Function()? onCancel;

  const UserSubCard({
    super.key,
    required this.subscription,
    this.username,
    required this.isAdmin,
    this.onCancel,
  });

  @override
  State<UserSubCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<UserSubCard> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _startTimer();
  }

  void _calculateRemaining() {
    if (widget.subscription.endDate != null) {
      final now = DateTime.now();
      if (widget.subscription.endDate!.isAfter(now)) {
        _remaining = widget.subscription.endDate!.difference(now);
      } else {
        _remaining = Duration.zero;
      }
    }
  }

  void _startTimer() {
    if (_remaining.inSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _calculateRemaining();
          if (_remaining.inSeconds <= 0) {
            timer.cancel();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return "${duration.inDays} day${duration.inDays > 1 ? 's' : ''}";
    } else if (duration.inHours > 0) {
      return "${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}";
    } else if (duration.inMinutes > 0) {
      return "${duration.inMinutes} min";
    }
    return "${duration.inSeconds} sec";
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.subscription.plan;
    final expiringSoon = _remaining.inDays <= 3 && _remaining.inSeconds > 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Username (display only if provided)
            if (widget.username != null && widget.username!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  widget.username!.toCapitalCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                ),
              ),

            // Plan name & status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.title.toCapitalCase(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                widget.isAdmin
                    ? ElevatedButton(
                        onPressed: widget.onCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[100],
                          foregroundColor: Colors.red[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    : Chip(
                        label: Text(
                          widget.subscription.isActive ? "Active" : "Expired",
                          style: TextStyle(
                            color: widget.subscription.isActive
                                ? Colors.green[800]
                                : Colors.red[800],
                          ),
                        ),
                        backgroundColor: widget.subscription.isActive
                            ? Colors.green[100]
                            : Colors.red[100],
                      ),
              ],
            ),
            const SizedBox(height: 8),

            // Price
            Text(
              "${formatPrice(amount: plan.price)} / ${formatPlanDuration(plan.duration)}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
            ),

            const SizedBox(height: 12),

            // Expiry date
            if (widget.subscription.endDate != null)
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    "Expires: ${DateFormat.yMMMd().format(widget.subscription.endDate!)}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),

            const SizedBox(height: 12),

            // Countdown Timer if expiring soon
            if (expiringSoon)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer, size: 18, color: Colors.orange),
                    const SizedBox(width: 6),
                    Text(
                      "Expires in ${_formatDuration(_remaining)}",
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
