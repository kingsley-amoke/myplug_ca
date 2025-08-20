// import 'package:flutter/material.dart';

// class StatCard extends StatelessWidget {
//   final String title;
//   final String value;

//   const StatCard({super.key, required this.title, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(title,
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     )),
//             const SizedBox(height: 8),
//             Text(value,
//                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                       color: Theme.of(context).primaryColor,
//                       fontWeight: FontWeight.bold,
//                     )),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (icon != null)
              CircleAvatar(
                backgroundColor:
                    (color ?? Theme.of(context).primaryColor).withOpacity(0.1),
                child: Icon(
                  icon,
                  color: color ?? Theme.of(context).primaryColor,
                ),
              ),
            if (icon != null) const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: color ?? Theme.of(context).primaryColor,
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
