import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/section_header.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class BioSection extends StatefulWidget {
  const BioSection({super.key, required this.user});

  final MyplugUser user;

  @override
  State<BioSection> createState() => _BioSectionState();
}

final _bioController = TextEditingController();

bool isEditing = false;

class _BioSectionState extends State<BioSection> {
  void editBio() {
    setState(() {
      isEditing = true;
    });
  }

  void onFinishedEditing() async {
    if (_bioController.text != '') {
      await context
          .read<UserProvider>()
          .updateProfile(bio: _bioController.text);
    }
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(title: 'About Me', icon: Icons.edit, onAdd: editBio),
        const SizedBox(height: 8),
        isEditing
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: widget.user.bio ?? "Write here..",
                      labelStyle: const TextStyle(),
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (val) => val == null || val.isEmpty
                        ? "Enter a description"
                        : null,
                  ),
                  TextButton(
                      onPressed: onFinishedEditing, child: const Text('Done'))
                ],
              )
            : Text(widget.user.bio ?? 'No bio provided.'),
      ],
    );
  }
}
