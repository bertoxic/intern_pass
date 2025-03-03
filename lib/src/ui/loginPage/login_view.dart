// lib/views/sign_in_view.dart
import 'package:flutter/material.dart';
import '../../widgets/authWidget/auth_text_field.dart';
import '../../widgets/authWidget/password_field.dart';
import '../../widgets/authWidget/social_signin_button.dart';
import 'login_controller.dart';


class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  late SignInController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignInController(
      onUpdate: () => setState(() {}),
    );
    // Pre-fill for demo purposes
    _controller.emailController.text = "Courtney Henry";
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
              const SizedBox(height: 12),
              _buildRememberForgotRow(),
              const SizedBox(height: 24),
              _buildSignInButton(),
              const SizedBox(height: 16),
              _buildOrDivider(),
              const SizedBox(height: 16),
              _buildSocialSignInButtons(),
              const Spacer(),
              _buildSignUpRow(),
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
          "Let's Sign you in",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Sign in to make an impact today.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildRememberForgotRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _controller.rememberMe,
                onChanged: _controller.setRememberMe,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "Remember me",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: _controller.forgotPassword,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            "Forgot password?",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: ()=> _controller.signIn(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3730F5),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        "Sign In",
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
            "or sign in with",
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

  Widget _buildSocialSignInButtons() {
    return Column(
      children: [
        SocialSignInButton(
          onPressed: _controller.signInWithApple,
          iconData: Icons.apple,
          text: "Continue with apple",
          isApple: true,
        ),
        const SizedBox(height: 12),
        SocialSignInButton(
          onPressed: _controller.signInWithGoogle,
          iconPath: "assets/google_logo.png",
          text: "Continue with google",
          isApple: false,
        ),
      ],
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have a account? ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: _controller.navigateToSignUp,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            "Sign up",
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