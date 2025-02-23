import 'package:flutter/material.dart';
import '../services/contact_service.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String _message = "";
  bool _contactAdded = false; // Track if contact was added

  void _saveContact() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      setState(() {
        _message = "Please fill in all fields";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = "";
    });

    String result = await ContactService.addContact(name, phone);

    setState(() {
      _isLoading = false;
      if (result == "success") {
        _message = "Contact added successfully!";
        _contactAdded = true; // Set flag to true
      } else {
        _message = "Failed to add contact. Please try again.";
      }
    });
  }

  void _goBack() {
    if (_contactAdded) {
      Navigator.pop(context, {"name": _nameController.text, "phone": _phoneController.text});
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Add Contact')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveContact,
                    child: const Text('Save Contact'),
                  ),
            const SizedBox(height: 10),
            Text(
              _message,
              style: TextStyle(
                color: _message.contains("successfully") ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
