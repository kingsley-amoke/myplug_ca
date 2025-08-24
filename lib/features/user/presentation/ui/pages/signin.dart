import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/core/constants/validators.dart';
import 'package:myplug_ca/core/domain/models/toast.dart';
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
  bool isVisible = false;

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      final navigator = Navigator.of(context);
      context
          .read<UserProvider>()
          .signIn(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((v) {
        if (v) {
          setState(() => isLoading = false);
          showToast(message: 'Success', type: ToastType.success);
          navigator.popAndPushNamed('/');
        } else {
          setState(() => isLoading = false);
          showToast(
              message: 'Invalid email or password', type: ToastType.error);
        }
      });
    }
  }

  void toggleIsVisible() {
    setState(() {
      isVisible = !isVisible;
    });
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Image.asset(loginImage, height: 280),
                ), // fixed size to avoid overflow
                const SizedBox(height: 24),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SignupPage()),
                          );
                        },
                        child: const Text("Don't have an account? Sign Up"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
