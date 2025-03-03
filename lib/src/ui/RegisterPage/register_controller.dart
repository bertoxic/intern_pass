// lib/controllers/sign_up_controller.dart
import 'package:flutter/material.dart';
import 'package:intern_pass/src/data/models/auth_models.dart';
import '../../services/authService/auth_service.dart';

class SignUpController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool agreeToTerms = true;

  final Function onUpdate;
  final AuthService _authService = AuthService();

  SignUpController({required this.onUpdate});

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    onUpdate();
  }

  void setAgreeToTerms(bool? value) {
    if (value != null) {
      agreeToTerms = value;
      onUpdate();
    }
  }

  Future<void> signUp(BuildContext ctx) async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      // Handle validation
      return;
    }

    try {
      await _authService.register(
        ctx,
        registerDetails: RegisterDetails(
            firstname: firstNameController.text,
            lastname: lastNameController.text,
            username: "username",
            phone: phoneController.text,
            email: emailController.text,
            password: passwordController.text)
        // name: nameController.text,
        // email: emailController.text,
        // password: passwordController.text,
      );
      // Navigate to home or dashboard
    } catch (e) {
      // Handle error
      debugPrint('Sign up error: $e');
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      // await _authService.signInWithGoogle();
      // Navigate to home or dashboard
    } catch (e) {
      // Handle error
      debugPrint('Google sign up error: $e');
    }
  }

  Future<void> signUpWithApple() async {
    try {
      // await _authService.signInWithApple();
      // Navigate to home or dashboard
    } catch (e) {
      // Handle error
      debugPrint('Apple sign up error: $e');
    }
  }

  void navigateToSignIn() {
    // Navigation to sign in screen
    debugPrint('Navigate to sign in');
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}