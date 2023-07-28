import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservedBooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserved Books'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('addbook')
            .where('reserved', isEqualTo: true)
            .get(),
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

  const BookListTile({
    required this.bookName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String bookTitle =
        bookName ?? 'Unknown Book'; // Add null check for bookName

    return ListTile(
      title: Text(bookTitle),
      // subtitle: Text('Added on: $formattedDate'),
      onTap: () {
        // Implement what should happen when the user taps on a book tile here.
        // For example, you can navigate to a detailed view of the book.
      },
    );
  }
}
