import 'dart:convert';

import 'package:bid4style/Models/profileModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  //set String
  static Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  //get String
  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  //emailotp password -set

  static Future<void> emailotpSet(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('emailotp', value);
  }

  static Future<void> passwordotpSet(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('passwordotp', value);
  }

  //Email -passwordotp-get
  static Future<String?> getEmailotp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('emailotp');
  }

  static Future<String?> getPasswordotp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('passwordotp');
  }

  // Save String Token
  static Future<void> saveToken(String? token) async {
    if (token == null) {
      throw ArgumentError("Token cannot be null");
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Get Token
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Save JSON data
  static Future<void> saveJsonData(
    String key,
    Map<String, dynamic> jsonData,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(jsonData); // Convert Map to JSON String
    await prefs.setString(key, jsonString);
  }

  // Retrieve JSON data
  static Future<Map<String, dynamic>?> getJsonData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      try {
        return json.decode(jsonString)
            as Map<
              String,
              dynamic
            >; // Convert JSON String to Map with type safety
      } catch (e) {
        print('Error decoding JSON data: $e');
      }
    }
    return null; // Return null if no data found
  }

  // Delete data
  static Future<void> removeData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Check if key exists
  static Future<bool> containsKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  // Clear all preferences
  static Future<void> clearAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("All data cleared from SharedPreferences________------");
  }

  // Save an object
  static Future<void> saveObject<T>(
    String key,
    T object,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(
      toJson(object),
    ); // Convert object to JSON String using toJson
    await prefs.setString(key, jsonString);
  }

  // Retrieve an object
  static Future<T?> getObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      try {
        Map<String, dynamic> jsonMap =
            json.decode(jsonString)
                as Map<
                  String,
                  dynamic
                >; // Convert JSON String to Map with type safety
        return fromJson(jsonMap); // Convert Map to object using fromJson
      } catch (e) {
        print('Error decoding object data: $e');
      }
    }
    return null; // Return null if no data found
  }

  // Function to save a user to shared preferences
  static Future<void> saveUserToPrefs(ProfileModel user) async {
    try {
      print("user comes ${user.toJson()}");
      final prefs = await SharedPreferences.getInstance();
      // Convert user object to a map
      final userMap = user.toJson();
      // Convert user map to a JSON string
      final jsonString = jsonEncode(userMap);
      // Save JSON string to shared preferences
      await prefs.setString('user', jsonString);
      print('User saved to shared preferences: $jsonString');
    } catch (e) {
      print('Error saving user to shared preferences: $e');
    }
  }

  // Function to retrieve a user from shared preferences
  static Future<ProfileModel?> getUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Get JSON string from shared preferences
      final jsonString = prefs.getString('user');
      if (jsonString != null) {
        print('Retrieved JSON string from shared preferences: $jsonString');
        // Decode JSON string to a map
        final userMap = jsonDecode(jsonString) as Map<String, dynamic>;
        // Create a user object from the map
        final user = ProfileModel.fromJson(userMap);
        print(
          'User detail retrieved from shared preferences: ${user.toJson()}',
        );
        return user;
      } else {
        print('No user found in shared preferences.');
        return null;
      }
    } catch (e) {
      print('Error retrieving user from shared preferences: $e');
      return null;
    }
  }

  static saveCustomerId(String? customerId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("cus", customerId!);
  }

  static getCustomerId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("cus");
  }
}
