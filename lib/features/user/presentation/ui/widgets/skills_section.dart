import 'package:flutter/material.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

Widget skillsSection(MyplugUser user) {
  if (user.skills.isEmpty) return const SizedBox.shrink();

  return Wrap(
    spacing: 8,
    runSpacing: 4,
    children: user.skills
        .map((skill) => Chip(
              label: Text(skill.name),
              avatar: CircleAvatar(
                backgroundImage: AssetImage(skill.image),
              ),
            ))
        .toList(),
  );
}
