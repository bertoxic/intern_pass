// lib/controllers/sign_in_controller.dart
import 'package:flutter/material.dart';
import '../../services/authService/auth_service.dart';

class SignInController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool rememberMe = false;

  final Function onUpdate;
  final AuthService _authService = AuthService();

  SignInController({required this.onUpdate});

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    onUpdate();
  }

  void setRememberMe(bool? value) {
    if (value != null) {
      rememberMe = value;
      onUpdate();
    }
  }

  Future<void> signIn(BuildContext ctx) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      // Handle validation
      return;
    }

    try {
      await _authService.login(
        ctx,
        email: emailController.text,
        password: passwordController.text,
      );
      // Navigate to home or dashboard
    } catch (e) {
      // Handle error
      debugPrint('Sign in error: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
    //  await _authService.signInWithGoogle();
      // Navigate to home or dashboard
    } catch (e) {
      // Handle error
      debugPrint('Google sign in error: $e');
    }
  }

  Future<void> signInWithApple() async {
    try {
    //  await _authService.signInWithApple();
      // Navigate to home or dashboard
    } catch (e) {
      // Handle error
      debugPrint('Apple sign in error: $e');
    }
  }

  void forgotPassword() {
    // Navigation to forgot password screen or show dialog
    debugPrint('Navigate to forgot password');
  }

  void navigateToSignUp() {
    // Navigation to sign up screen
    debugPrint('Navigate to sign up');
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}