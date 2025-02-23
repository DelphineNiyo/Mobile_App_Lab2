import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactService {
  static const String baseUrl = "https://apps.ashesi.edu.gh/contactmgt/actions";

  static Future<Map<String, dynamic>?> fetchSingleContact(int contactId) async {
    final Uri url = Uri.parse("$baseUrl/get_a_contact_mob?contid=$contactId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return {
            "id": data[0]["pid"],
            "name": data[0]["pname"],
            "phone": data[0]["pphone"],
          };
        }
      }
      return null;
    } catch (e) {
      print("Error fetching contact: $e");
      return null;
    }
  }

  // Fetch all contacts
  static Future<List<Map<String, dynamic>>> fetchAllContacts() async {
    final Uri url = Uri.parse("$baseUrl/get_all_contact_mob");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((contact) {
          return {
            "id": contact["pid"],
            "name": contact["pname"],
            "phone": contact["pphone"],
          };
        }).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching contacts: $e");
      return [];
    }
  }

  // Add new contact
  static Future<String> addContact(String fullName, String phoneNumber) async {
    final Uri url = Uri.parse("$baseUrl/add_contact_mob");
    try {
      final response = await http.post(
        url,
        body: {"ufullname": fullName, "uphonename": phoneNumber},
      );

      return response.body;
    } catch (e) {
      print("Error adding contact: $e");
      return "failed";
    }
  }

  // Edit existing contact
  static Future<String> editContact(String id, String newName, String newPhone) async {
    final Uri url = Uri.parse("$baseUrl/update_contact");
    try {
      final response = await http.post(
        url,
        body: {"cid": id, "cname": newName, "cnum": newPhone},
      );

      return response.body;
    } catch (e) {
      print("Error editing contact: $e");
      return "failed";
    }
  }

  // Delete a contact
  static Future<bool> deleteContact(String id) async {
    final Uri url = Uri.parse("$baseUrl/delete_contact");
    try {
      final response = await http.post(
        url,
        body: {"cid": id},
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error deleting contact: $e");
      return false;
    }
  }
}
