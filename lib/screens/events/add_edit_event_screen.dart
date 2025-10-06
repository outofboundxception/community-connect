import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/event_service.dart';
import 'package:intl/intl.dart';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveEvent() async {
    // Validate the form fields.
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date for the event.')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        // Use the EventService to add the new event.
        await Provider.of<EventService>(context, listen: false).addEvent(
          _titleController.text,
          _descriptionController.text,
          _selectedDate!,
        );

        if (mounted) {
          Navigator.of(context).pop(); // Go back to the events list screen.
        }
      } catch (e) {
        // Handle potential errors.
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add event: $e')));
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Event"),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveEvent),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Event Title',
                      ),
                      validator: (value) => (value?.isEmpty ?? true)
                          ? 'Please enter a title.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 5,
                      validator: (value) => (value?.isEmpty ?? true)
                          ? 'Please enter a description.'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'No Date Chosen'
                                : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                          ),
                        ),
                        TextButton(
                          onPressed: _presentDatePicker,
                          child: const Text('Choose Date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
