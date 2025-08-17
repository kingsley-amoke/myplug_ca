import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/skills.dart';
import 'package:myplug_ca/core/constants/validators.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/bottom_nav.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_input.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/domain/models/skill.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final addressController = TextEditingController();

  bool isLoading = false;
  Skill? selectedSkill;

  List<DropdownMenuEntry<Skill>> dropDownSkills = services.map((e) {
    return DropdownMenuEntry<Skill>(value: e, label: e.name);
  }).toList();

  void _signup() {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      if (passwordController.text == confirmPasswordController.text) {
        final user = MyplugUser(
            email: emailController.text,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            phone: phoneController.text,
            skills: [selectedSkill!]);

        context.read<UserProvider>().signUp(
            user: user,
            address: addressController.text,
            password: passwordController.text);
      }

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isLoading = false);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const BottomNav()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  "Create Account",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFDAA579),
                      ),
                ),
                const SizedBox(height: 8),
                const Text("Fill in your details to get started"),
                const SizedBox(height: 32),

                // First Name
                MyInput(
                    controller: firstNameController,
                    hintText: "First Name",
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (v) => textValidator(v)),
                const SizedBox(height: 16),

                // Last Name
                MyInput(
                    controller: lastNameController,
                    hintText: "Last Name",
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (v) => textValidator(v)),
                const SizedBox(height: 16),
                const SizedBox(height: 16),

                // Email
                MyInput(
                    controller: emailController,
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (v) => emailValidator(v)),
                const SizedBox(height: 16),

                // Phone
                MyInput(
                    controller: phoneController,
                    hintText: "Phone Number",
                    prefixIcon: const Icon(Icons.phone),
                    validator: (v) => textValidator(v)),

                const SizedBox(height: 16),

                // Password
                MyInput(
                    controller: passwordController,
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.password_rounded),
                    validator: (v) => textValidator(v)),
                const SizedBox(height: 16),
                MyInput(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    prefixIcon: const Icon(Icons.password_rounded),
                    validator: (v) => textValidator(v)),
                const SizedBox(height: 16),

                MyInput(
                    controller: addressController,
                    hintText: "Street Address",
                    prefixIcon: const Icon(Icons.location_city),
                    validator: (v) => textValidator(v)),
                const SizedBox(height: 16),
                DropdownMenu(
                  width: getScreenWidth(context),
                  hintText: 'Select Skills',
                  dropdownMenuEntries: dropDownSkills,
                  enableSearch: true,
                  onSelected: (value) => setState(() {
                    selectedSkill = value;
                  }),
                ),
                const SizedBox(height: 16),

                // Signup Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDAA579),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Already have an account? Login"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
