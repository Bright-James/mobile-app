import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReserveBook extends StatefulWidget {
  const ReserveBook({Key? key}) : super(key: key);

  @override
  State<ReserveBook> createState() => _ReserveBookState();
}

class _ReserveBookState extends State<ReserveBook> {
  final String reservationPrefKey = 'reservationTimestamp';
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    // checkReservationStatus();
  }

  void initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //app bar for Reserve Bokk page

      appBar: AppBar(
        title: Text("All Books"),
      ),
      //fwtch the book from firestore data base
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchBooks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child:
                    CircularProgressIndicator(), //circular progress indicator to show while updating the toggle values
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              final books = snapshot.data ?? [];
              //grid to represent the books on page
              return SizedBox(
                width: size.width * 0.75,
                height: size.height,
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return _buildBookCard(
                        book, size); // Create a ListTile widget for each book
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  String generateRandomCode() {
    Random random = Random();
    int randomNumber = random.nextInt(900000) +
        100000; // Generates a random number between 100000 and 999999
    return randomNumber.toString();
  }

  void saveCodeToFirestore(String code) {
    // Replace 'reserves' with the name of your collection in Firestore.
    // Make sure you have the appropriate Firebase authentication set up to identify the current user.
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      print('Current User ID: $userId');

      FirebaseFirestore.instance
          .collection('reservers')
          .doc(userId)
          .set({'code': code}).then((value) {
        print('Code saved to Firestore successfully!');
      }).catchError((error) {
        print('Error saving code to Firestore: $error');
      });
    }
  }

  void showRandomCodeDialog(BuildContext context) {
    String code = generateRandomCode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Random 6-Digit Code Keep it safe'),
          content: Text(code),
          actions: <Widget>[
            TextButton(
              child: Text('Copy'),
              onPressed: () {
                // Add code here to copy the code to the clipboard if desired.
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                saveCodeToFirestore(code);
              },
            ),
          ],
        );
      },
    );
  }

  void showAddToReadingListDialog(BuildContext context, String bookName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add to Reading List'),
          content: Text('"$bookName"is added to your Reading List'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                addBookToReadingList(bookName);
                Navigator.of(context).pop(); // Close the dialog.
              },
            ),
          ],
        );
      },
    );
  }

  void addBookToReadingList(String bookName) {
    // Replace 'reservers' with the name of your collection in Firestore where you want to store the books in the reading list.

    // Create a new document with a unique ID in the "reservers" collection and set the book details.
    FirebaseFirestore.instance.collection('reservers').add({
      'bookName': bookName,
      'timestamp': DateTime
          .now(), // You can also store the timestamp when the book was added to the reading list.
      'reserved': true,
    }).then((value) {
      print('Book added to Reading List successfully!');
    }).catchError((error) {
      print('Error adding book to Reading List: $error');
    });
  }

//buid cards to represent books on page
  Widget _buildBookCard(Map<String, dynamic> book, Size size) {
    bool isReserved = book['reserved'] ?? false;
    String documentId = book['documentId'] as String;

    void turnOffSwitchAfter15Days() {
      Timer(Duration(days: 7), () {
        setState(() {
          isReserved = false;
        });

        FirebaseFirestore.instance
            .collection('addbook')
            .doc(documentId)
            .update({'reserved': false}).then((_) {
          print(
              'Reserved status automatically turned off for ${book['bookName']}');
        }).catchError((error) {
          print('Error updating reserved status: $error');
        });
      });
    }

    void extendReservation() {
      setState(() {
        isReserved = true;
      });

      // Update the 'reserved' field in Firestore using the document ID
      FirebaseFirestore.instance
          .collection('addbook')
          .doc(documentId)
          .update({'reserved': isReserved}).then((_) {
        print('Reserved status extended for ${book['bookName']}');

        // Schedule the automatic turning off after 7 days from the current timestamp
        Timer(Duration(days: 7), () {
          setState(() {
            isReserved = false;
          });

          FirebaseFirestore.instance
              .collection('addbook')
              .doc(documentId)
              .update({'reserved': false}).then((_) {
            print(
                'Reserved status automatically turned off for ${book['bookName']}');

            // Show the dialog to inform the user about the extension
          }).catchError((error) {
            print('Error updating reserved status: $error');
          });
        });
      }).catchError((error) {
        print('Error updating reserved status: $error');
      });
    }

    return Card(
      elevation: 4.0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                book['bookName'],
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                book['authorName'],
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                book['year'],
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: size.height * 0.01),
              ElevatedButton(
                onPressed: isReserved
                    ? null
                    : () async {
                        showRandomCodeDialog(context);

                        setState(() {
                          isReserved = true;
                        });

                        if (isReserved) {
                          turnOffSwitchAfter15Days();
                        } else {
                          Timer.run(() {
                            isReserved = !isReserved;
                          });
                        }

                        // if (prefs != null) {
                        //   prefs!.setInt(reservationPrefKey,
                        //       DateTime.now().millisecondsSinceEpoch);
                        // }

                        FirebaseFirestore.instance
                            .collection('addbook')
                            .doc(documentId)
                            .update({'reserved': isReserved}).then((_) {
                          print(
                              'Reserved status updated for ${book['bookName']}');
                        }).catchError((error) {
                          print('Error updating reserved status: $error');
                        });
                      },
                child: Text("Reserve Book"),
              ),
              SizedBox(height: size.height * 0.02),
              ElevatedButton(
                onPressed: () {
                  showAddToReadingListDialog(context, book['bookName']);

                  // Implement the functionality for the new ElevatedButton here.
                  // For example, you can show another dialog or perform other actions.
                },
                child: Text("Add to Reading List"),
              ),
              SizedBox(height: size.height * 0.02),
              ElevatedButton(
                onPressed: () {
                  extendReservation();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Reservation Extended'),
                        content: Text(
                            'You have extended the reservation for ${book['bookName']} for 7 more days.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Extend Reservation for 7 days"),
              ),
              SizedBox(height: size.height * 0.02),
              Text("To unreserve the book"),
              Switch(
                value: isReserved,
                onChanged: (newValue) {
                  setState(() {
                    isReserved = false;
                  });

                  FirebaseFirestore.instance
                      .collection('addbook')
                      .doc(documentId)
                      .update({'reserved': false}).then((_) {
                    print('Reserved status updated for ${book['bookName']}');
                  }).catchError((error) {
                    print('Error updating reserved status: $error');
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

//fetch boobk on firestore database
  Future<List<Map<String, dynamic>>> _fetchBooks() async {
    try {
      //create instatnce of Firestoredatabase collection of AddBook
      final snapshot =
          await FirebaseFirestore.instance.collection('addbook').get();
      return snapshot.docs.map((doc) {
        final data = doc.data(); //add the data to the variable
        data['documentId'] = doc.id; // Add the document ID to the book data
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }
}
