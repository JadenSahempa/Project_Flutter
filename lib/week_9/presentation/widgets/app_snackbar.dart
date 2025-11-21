import 'package:flutter/material.dart';

SnackBar _buildSnackBar(String message, {required bool isError}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16),
    backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
    content: Row(
      children: [
        Icon(
          isError ? Icons.error_outline : Icons.check_circle_outline,
          color: Colors.white,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(_buildSnackBar(message, isError: true));
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(_buildSnackBar(message, isError: false));
}
