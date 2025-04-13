import 'package:flutter/material.dart';

class QuoteCard extends StatelessWidget {
  final String text;
  final Widget? trailing;

  const QuoteCard({
    super.key,
    required this.text,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(height: 16),
              Center(child: trailing!),
            ],
          ],
        ),
      ),
    );
  }
}