// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ProfileViewModel extends ChangeNotifier {
//   String _name = 'Manpreet Singh';
//   String _bio =
//       'Lorem ipsum simply dummy text of the printing and typesetting industry.';
//   String _email = 'manpreetsingh123@gmail.com';
//   String _phone = '+91 97653 3214';

//   String get name => _name;
//   String get bio => _bio;
//   String get email => _email;
//   String get phone => _phone;

//   set name(String newName) {
//     _name = newName;
//     notifyListeners();
//   }

//   set bio(String newBio) {
//     _bio = newBio;
//     notifyListeners();
//   }

//   set email(String newEmail) {
//     _email = newEmail;
//     notifyListeners();
//   }

//   set phone(String newPhone) {
//     _phone = newPhone;
//     notifyListeners();
//   }

//   Future<void> updateProfile({
//     required String name,
//     required String bio,
//     required String email,
//     required String phone,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://jsonplaceholder.typicode.com/posts'),
//         body: {'name': name, 'bio': bio, 'email': email, 'phone': phone},
//       );
//       if (response.statusCode == 201) {
//         _name = name;
//         _bio = bio;
//         _email = email;
//         _phone = phone;
//         notifyListeners();
//       } else {
//         print('Failed to update profile: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error updating profile: $e');
//     }
//   }

//   Future<void> loadProfile() async {
//     await Future.delayed(const Duration(seconds: 1));
//     notifyListeners();
//   }

//   void resetProfile() {
//     _name = 'Manpreet Singh';
//     _bio =
//         'Lorem ipsum simply dummy text of the printing and typesetting industry.';
//     _email = 'manpreetsingh123@gmail.com';
//     _phone = '+91 97653 3214';
//     notifyListeners();
//   }
// }
