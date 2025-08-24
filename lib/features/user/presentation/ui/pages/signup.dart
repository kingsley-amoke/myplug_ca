import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/skills.dart';
import 'package:myplug_ca/core/constants/validators.dart';
import 'package:myplug_ca/core/domain/models/toast.dart';
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
  bool isVisible = false;
  bool isVisible2 = false;
  Skill? selectedSkill;

  List<DropdownMenuEntry<Skill>> dropDownSkills = services.map((e) {
    return DropdownMenuEntry<Skill>(value: e, label: e.name);
  }).toList();

  Future<void> _signup() async {
    setState(() => isLoading = true);
    if (await doesDomainExist(emailController.text)) {
      if (_formKey.currentState!.validate() && selectedSkill != null) {
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
        setState(() => isLoading = false);
        showToast(context, message: 'Success', type: ToastType.success);
        Navigator.of(context).popAndPushNamed('/');
      } else {
        setState(() => isLoading = false);
        showToast(context,
            message: 'Complete all fields', type: ToastType.error);
      }
    } else {
      setState(() => isLoading = false);
      showToast(context,
          message: 'Please use a valid email address', type: ToastType.error);
    }
  }

  void toggleIsVisible() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void toggleIsVisible2() {
    setState(() {
      isVisible2 = !isVisible2;
    });
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

                // Password Field
                MyInput(
                  controller: passwordController,
                  obscureText: isVisible,
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: isVisible
                      ? IconButton(
                          onPressed: toggleIsVisible,
                          icon: const Icon(Icons.visibility))
                      : IconButton(
                          onPressed: toggleIsVisible,
                          icon: const Icon(Icons.visibility_off),
                        ),
                  validator: (v) => textValidator(v),
                ),
                const SizedBox(height: 16),
                MyInput(
                  controller: confirmPasswordController,
                  obscureText: isVisible2,
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: isVisible2
                      ? IconButton(
                          onPressed: toggleIsVisible2,
                          icon: const Icon(Icons.visibility))
                      : IconButton(
                          onPressed: toggleIsVisible2,
                          icon: const Icon(Icons.visibility_off),
                        ),
                  validator: (v) => textValidator(v),
                ),
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
