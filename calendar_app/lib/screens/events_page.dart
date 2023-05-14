import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'routes.dart';

class EventsPage extends StatelessWidget {
  final DateTime selectedDate;

  EventsPage({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('date', isEqualTo: selectedDate)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
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
                      .collection('events')
                      .doc(document.id)
                      .delete();
                },
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, Routes.addEditTask,
              arguments: {'date': selectedDate});
        },
      ),
    );
  }
}
