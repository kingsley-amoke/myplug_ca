import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/section_header.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/add_testimonial.dart';
import 'package:star_rating/star_rating.dart';

Widget testimonialsSection(
  BuildContext context, {
  required MyplugUser user,
}) {
  void onAdd() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AddTestimonialPage()));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionHeader(title: 'Testimonials', onAdd: onAdd),
      const SizedBox(height: 8),
      if (user.testimonials.isEmpty)
        const Text('No testimonials yet.')
      else
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: user.testimonials.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final t = user.testimonials[index];
            return ListTile(
              title: Text(t.content),
              subtitle: StarRating(
                rating: t.rating,
                length: 5,
              ),
            );
          },
        ),
    ],
  );
}
