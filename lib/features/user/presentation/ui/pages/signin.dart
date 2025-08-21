import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/core/constants/validators.dart';
import 'package:myplug_ca/core/domain/models/toast.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/bottom_nav.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_input.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/signup.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      context
          .read<UserProvider>()
          .signIn(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((v) {
        showToast(context, message: 'Success', type: ToastType.success);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const BottomNav(),
          ),
        );
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isLoading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(loginImage, height: 280),
                ), // fixed size to avoid overflow
                const SizedBox(height: 24),

                Text(
                  "Welcome Back",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFDAA579),
                      ),
                ),
                const SizedBox(height: 8),
                const Text("Login to continue your journey"),
                const SizedBox(height: 32),

                // Email Field
                MyInput(
                  controller: emailController,
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (v) => emailValidator(v),
                ),
                const SizedBox(height: 16),

                // Password Field
                MyInput(
                  controller: passwordController,
                  obscureText: true,
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: (v) => textValidator(v),
                ),
                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDAA579),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignupPage()),
                      );
                    },
                    child: const Text("Don't have an account? Sign Up"),
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
