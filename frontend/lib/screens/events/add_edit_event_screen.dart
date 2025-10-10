// lib/screens/events/add_edit_event_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event_model.dart'; // Corrected import
import '../../services/auth_service.dart';
import '../../services/event_service.dart';

// ... (rest of the file is correct)

class AddEditEventScreen extends StatefulWidget {
  const AddEditEventScreen({super.key});

  @override
  State<AddEditEventScreen> createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date.')),
        );
        return;
      }

      final authService = Provider.of<IAuthService>(context, listen: false);
      final user = authService.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to create an event.')),
        );
        return;
      }
      
      final newEvent = EventModel(
        id: '', // Firestore will generate this
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate!,
        author: user.fullName,
        authorId: user.uid,
      );

      final eventService = Provider.of<EventService>(context, listen: false);
      await eventService.addEvent(newEvent);

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title.' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
                 validator: (value) =>
                    value!.isEmpty ? 'Please enter a description.' : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date chosen!'
                          : 'Picked Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text('Choose Date'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvent,
                child: const Text('Save Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}