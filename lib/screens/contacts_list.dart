import 'package:flutter/material.dart';
import '../services/contact_service.dart';
import 'edit_contact.dart';
import 'add_contact.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  List<Map<String, dynamic>> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  // Fetch all contacts from API
  void _fetchContacts() async {
    List<Map<String, dynamic>> contacts = await ContactService.fetchAllContacts();
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  // Delete a contact
  void _deleteContact(String id) async {
    bool success = await ContactService.deleteContact(id);
    if (success) {
      setState(() {
        _contacts.removeWhere((contact) => contact["id"] == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Contacts List')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
              ? const Center(child: Text("No contacts available."))
              : ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: Text(_contacts[index]["name"]),
                        subtitle: Text(_contacts[index]["phone"]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final updatedContact = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditContactScreen(
                                      id: _contacts[index]["id"].toString(),
                                      name: _contacts[index]["name"],
                                      phone: _contacts[index]["phone"],
                                    ),
                                  ),
                                );

                                if (updatedContact != null) {
                                  setState(() {
                                    _contacts[index] = updatedContact;
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteContact(_contacts[index]["id"].toString());
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContactScreen()),
          );

          if (newContact != null) {
            setState(() {
              _contacts.add(newContact);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
