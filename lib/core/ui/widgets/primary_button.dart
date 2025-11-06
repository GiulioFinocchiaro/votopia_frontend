import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Future<void> Function()? onPressed;
  final IconData icon; // <--- aggiunto parametro
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon = Icons.arrow_forward, // valore di default
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(
            fontFamily: 'Roboto', fontWeight: FontWeight.w600, fontSize: 16),
        elevation: 2,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(child: Text(text, style: const TextStyle(color: Colors.white))),
          Positioned(right: 16, child: Icon(icon, color: Colors.white)), // <--- usa il parametro
        ],
      ),
    );
  }
}