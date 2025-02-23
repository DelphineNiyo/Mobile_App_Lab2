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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
  }

  void _saveContact() async {
    String updatedName = _nameController.text.trim();
    String updatedPhone = _phoneController.text.trim();

    String result = await ContactService.editContact(widget.id, updatedName, updatedPhone);

    if (result == "success") {
      Navigator.pop(context, {"id": widget.id, "name": updatedName, "phone": updatedPhone});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update contact.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Contact')),
      body: Column(
        children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name')),
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
          ElevatedButton(onPressed: _saveContact, child: const Text('Save Changes'))
        ],
      ),
    );
  }
}
