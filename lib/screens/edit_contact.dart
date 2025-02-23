import 'package:flutter/material.dart';
import '../services/contact_service.dart';

class EditContactScreen extends StatefulWidget {
  final String id;
  final String name;
  final String phone;

  const EditContactScreen({super.key, required this.id, required this.name, required this.phone});

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isLoading = false;
  String _message = "";
  bool _contactUpdated = false; // Track if contact was updated

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
  }

  void _saveContact() async {
    String updatedName = _nameController.text.trim();
    String updatedPhone = _phoneController.text.trim();

    if (updatedName.isEmpty || updatedPhone.isEmpty) {
      setState(() {
        _message = "Please fill in all fields";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = "";
    });

    String result = await ContactService.editContact(widget.id, updatedName, updatedPhone);

    setState(() {
      _isLoading = false;
      if (result == "success") {
        _message = "Contact updated successfully!";
        _contactUpdated = true; // Set flag to true
      } else {
        _message = "Failed to update contact. Please try again.";
      }
    });
  }

  void _goBack() {
    if (_contactUpdated) {
      Navigator.pop(context, {
        "id": widget.id,
        "name": _nameController.text,
        "phone": _phoneController.text
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Contact')),
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
                    child: const Text('Save Changes'),
                  ),
            const SizedBox(height: 10),
            Text(
              _message,
              style: TextStyle(
                color: _message.contains("successfully") ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_contactUpdated) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _goBack,
                child: const Text("Go Back to Contacts"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
