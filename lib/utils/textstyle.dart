

import 'package:flutter/material.dart';

const TextStyle headingStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const TextStyle subHeadingStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey,
);

const TextStyle listItemStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

const TextStyle footerTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.grey,
);

Widget CustomListTile({
  required IconData leadingIcon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(leadingIcon, color: Colors.grey),
    title: Text(title, style: listItemStyle),
    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    onTap: onTap,
  );
}