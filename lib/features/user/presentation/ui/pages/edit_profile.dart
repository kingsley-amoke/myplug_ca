import 'dart:io';

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

  void _pickImage() async {
    final userProvider = context.read<UserProvider>();
    File? imageFile = await pickImage();

    if (imageFile != null) {
      userProvider.uploadProfilePic(imageFile).then((res) {
        if (res) {
          showToast(context, message: 'Success', type: ToastType.success);
        } else {
          // showToast(context,
          //     message: 'Something went wrong', type: ToastType.error);
        }
      });
    }
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
                // Profile Image
                GestureDetector(
                  onTap: _pickImage,
                  child: Center(
                    child: Consumer<UserProvider>(
                      builder: (context, provider, child) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: provider.myplugUser!.image != null
                              ? NetworkImage(provider.myplugUser!.image!)
                              : const AssetImage(noUserImage),
                          child: user!.image == null
                              ? const Icon(Icons.camera_alt, size: 40)
                              : null,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Text Fields
                const Text('First Name'),
                MyInput(
                  controller: _firstNameController,
                  hintText: user?.firstName ?? 'First Name',
                  validator: (v) => emailValidator(v),
                ),

                const SizedBox(
                  height: 10,
                ),
                const Text('First Name'),
                MyInput(
                  controller: _lastNameController,
                  hintText: user?.lastName ?? 'Last Name',
                  validator: (v) => textValidator(v),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Phone Number'),
                MyInput(
                  controller: _phoneController,
                  hintText: user?.phone ?? 'Phone Number',
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
