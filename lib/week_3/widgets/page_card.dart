import 'package:flutter/material.dart';

class PageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String route;

  const PageCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
