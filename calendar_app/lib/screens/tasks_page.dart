import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'routes.dart';

class TasksPage extends StatefulWidget {
  final DateTime selectedDate;

  TasksPage({required this.selectedDate});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('date', isEqualTo: widget.selectedDate)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _title = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _description = value!;
                      },
                    ),
                    ElevatedButton(
                      child: Text('Add Task'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          FirebaseFirestore.instance.collection('tasks').add({
                            'title': _title,
                            'description': _description,
                            'date': widget.selectedDate,
                          });
                          _formKey.currentState!.reset();
                        }
                      },
                    ),
                  ],
                ),
              ),
              ...snapshot.data!.docs.map((DocumentSnapshot document) {
                return ListTile(
                  title: Text(document['title']),
                  subtitle: Text(document['description']),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.addEditTask,
                          arguments: {
                            'id': document.id,
                            'title': document['title'],
                            'description': document['description'],
                            'date': document['date']
                          });
                    },
                  ),
                  onLongPress: () {
                    FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(document.id)
                        .delete();
                  },
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
