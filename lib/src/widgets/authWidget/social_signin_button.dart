// lib/widgets/social_sign_in_button.dart
import 'package:flutter/material.dart';


class SocialSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? iconData;
  final String? iconPath;
  final String text;
  final bool isApple;
  final bool isCompact;

  const SocialSignInButton({
    Key? key,
    required this.onPressed,
    this.iconData,
    this.iconPath,
    required this.text,
    required this.isApple,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          vertical: isCompact ? 12 : 16,
          horizontal: isCompact ? 8 : 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: isCompact ? MainAxisAlignment.center : MainAxisAlignment.center,
        children: [
          if (iconData != null)
            Icon(
              iconData,
              color: isApple ? Colors.black : Colors.grey.shade700,
              size: 20,
            )
          else if (iconPath != null)
            Image.asset(
              iconPath!,
              height: 20,
              width: 20,
            ),
          if (!isCompact) SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isCompact ? FontWeight.w500 : FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}