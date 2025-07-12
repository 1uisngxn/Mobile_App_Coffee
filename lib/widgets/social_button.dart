import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback? onPressed; // Cho phép null để disable

  const SocialButton({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed, // null sẽ disable nút
      icon: Icon(icon, color: Colors.white),
      label: Text(text,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        disabledBackgroundColor: color.withOpacity(0.5), // khi disabled
      ),
    );
  }
}
