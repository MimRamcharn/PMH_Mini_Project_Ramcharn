import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'routes.dart';

class AddEditTaskPage extends StatefulWidget {
  final Map<String, dynamic>? task;

  AddEditTaskPage({this.task});

  @override
  _AddEditTaskPageState createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleController.text = widget.task!['title'];
      _descriptionController.text = widget.task!['description'];
      _selectedDate = widget.task!['date'].toDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text(
                        '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final title = _titleController.text;
                    final description = _descriptionController.text;
                    if (widget.task != null) {
                      await FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(widget.task!['id'])
                          .update({
                        'title': title,
                        'description': description,
                        'date': _selectedDate,
                      });
                    } else {
                      await FirebaseFirestore.instance.collection('tasks').add({
                        'title': title,
                        'description': description,
                        'date': _selectedDate,
                      });
                    }

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
