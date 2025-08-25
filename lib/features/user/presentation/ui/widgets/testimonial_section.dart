import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/section_header.dart';
import 'package:fixnbuy/features/user/domain/models/myplug_user.dart';
import 'package:fixnbuy/features/user/presentation/ui/pages/add_testimonial.dart';
import 'package:fixnbuy/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:star_rating/star_rating.dart';

Widget testimonialsSection(
  BuildContext context, {
  required MyplugUser user,
}) {
  void onAdd() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AddTestimonialPage(
              user: user,
            )));
  }

  bool isOwner = context.read<UserProvider>().myplugUser?.id == user.id;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionHeader(
        title: 'Testimonials',
        onAdd: onAdd,
        show: !isOwner,
      ),
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
              title: Text(t.comment.toSentenceCase()),
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
