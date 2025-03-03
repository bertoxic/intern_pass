// lib/views/sign_up_view.dart
import 'package:flutter/material.dart';
import 'package:intern_pass/src/ui/RegisterPage/register_controller.dart';
import '../../widgets/authWidget/auth_text_field.dart';
import '../../widgets/authWidget/password_field.dart';
import '../../widgets/authWidget/social_signin_button.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late SignUpController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignUpController(
      onUpdate: () => setState(() {}),
    );
    // Pre-fill for demo purposes as seen in the image
    _controller.firstNameController.text = "Courtney Henry";
    _controller.emailController.text = "dolores.chambers@example.com";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              _buildHeader(),
              const SizedBox(height: 40),
              AuthTextField(
                label: "First Name",
                controller: _controller.firstNameController,
              ),
              const SizedBox(height: 20), const SizedBox(height: 40),
              AuthTextField(
                label: "Last Name",
                controller: _controller.lastNameController,
              ),
              const SizedBox(height: 20),
              AuthTextField(
                label: "Email address",
                controller: _controller.emailController,
              ),
              const SizedBox(height: 20),
              PasswordField(
                label: "Password",
                controller: _controller.passwordController,
                obscureText: _controller.obscurePassword,
                onToggleVisibility: _controller.togglePasswordVisibility,
              ),
              const SizedBox(height: 16),
              _buildTermsRow(),
              const SizedBox(height: 24),
              _buildSignUpButton(),
              const SizedBox(height: 16),
              _buildOrDivider(),
              const SizedBox(height: 16),
              _buildSocialSignUpButtons(),
              const Spacer(),
              _buildSignInRow(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Create Account",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Join us and start creating change.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsRow() {
    return Row(
      children: [
        Text(
          "By signing up, you agree to our Terms.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () => _controller.signUp(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3730F5),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        "Sign Up",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "or sign up with",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialSignUpButtons() {
    return Row(
      children: [
        Expanded(
          child: SocialSignInButton(
            onPressed: _controller.signUpWithApple,
            iconData: Icons.apple,
            text: "Apple",
            isApple: true,
            isCompact: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SocialSignInButton(
            onPressed: _controller.signUpWithGoogle,
            iconPath: "assets/google_logo.png",
            text: "Google",
            isApple: false,
            isCompact: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: _controller.navigateToSignIn,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            "Sign in",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF3730F5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}