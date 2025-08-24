import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/images.dart';

import 'package:myplug_ca/core/constants/validators.dart';
import 'package:myplug_ca/core/domain/models/toast.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/custom_button.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_input.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  MyplugUser? user;

  bool isUploading = false;

  void _pickImage() async {
    setState(() {
      isUploading = true;
    });
    final userProvider = context.read<UserProvider>();
    File? imageFile = await pickImage();

    if (imageFile != null) {
      userProvider.uploadProfilePic(imageFile).then((res) {
        if (res) {
          showToast(context, message: 'Success', type: ToastType.success);
        } else {
          showToast(context,
              message: 'Something went wrong', type: ToastType.error);
        }
      });
    }
    setState(() {
      isUploading = false;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<UserProvider>().updateProfile(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phone: _phoneController.text.trim(),
          );
    }
  }

  @override
  void initState() {
    setState(() {
      user = context.read<UserProvider>().myplugUser;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(
        context,
        title: 'Edit Profile',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget? child) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileImageSection(
                  onPickImage: () {
                    _pickImage();
                  },
                ),

                const SizedBox(height: 40),

                // Text Fields
                // const Text('First Name'),
                MyInput(
                  controller: _firstNameController,
                  hintText: 'First Name',
                  validator: (v) => textValidator(v),
                ),

                const SizedBox(
                  height: 10,
                ),
                // const Text('First Name'),
                MyInput(
                  controller: _lastNameController,
                  hintText: 'Last Name',
                  validator: (v) => textValidator(v),
                ),
                const SizedBox(
                  height: 10,
                ),
                // const Text('Phone Number'),
                MyInput(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: (v) => textValidator(v),
                ),

                const SizedBox(height: 20),

                CustomButton(text: 'Save Changes', onPressed: _saveProfile),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class ProfileImageSection extends StatelessWidget {
  final VoidCallback onPickImage;

  const ProfileImageSection({super.key, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<UserProvider>(
        builder: (context, provider, child) {
          final imageUrl = provider.myplugUser?.image;
          final isUploading = provider.isUploading;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Profile Image
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : const AssetImage(noUserImage) as ImageProvider,
              ),

              // Loading Overlay
              if (isUploading)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: SizedBox(
                            height: 28,
                            width: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Camera Button
              Positioned(
                bottom: 4,
                right: 4,
                child: GestureDetector(
                  onTap: isUploading ? null : onPickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
