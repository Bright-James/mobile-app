import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyReserversScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reading List'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('reservers').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final books = snapshot.data!.docs;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final bookData = books[index].data() as Map<String, dynamic>;
                return BookListTile(
                  bookName: bookData['bookName'],
                  timestamp: bookData['timestamp'],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class BookListTile extends StatelessWidget {
  final String? bookName;
  final Timestamp? timestamp;

  const BookListTile({
    required this.bookName,
    required this.timestamp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        timestamp != null ? timestamp!.toDate().toString() : 'Unknown Date';

    String bookTitle =
        bookName ?? 'Unknown Book'; // Add null check for bookName

    return ListTile(
      title: Text(bookTitle),
      subtitle: Text('Added on: $formattedDate'),
      onTap: () {
        // Implement what should happen when the user taps on a book tile here.
        // For example, you can navigate to a detailed view of the book.
      },
    );
  }
}
