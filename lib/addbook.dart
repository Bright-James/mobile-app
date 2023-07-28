import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //to save the state of form of textfields
  final TextEditingController _bookNameController =
      TextEditingController(); //name controller
  final TextEditingController _authorNameController =
      TextEditingController(); // author controller
  final TextEditingController _yearController =
      TextEditingController(); //year colntroller

  bool _isUploading = false;
  bool _showSuccessMessage = false;
//add book method to upload book on firestore database
  Future<void> _addBookToFirestore() async {
    //check for valid state if their any issues in fields
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true; // set loading to true
      });

      print('Uploading...'); // Print 'Uploading' to the console

      try {
        // create instance of firestore database addbook collection
        await FirebaseFirestore.instance.collection('addbook').add({
          'bookName': _bookNameController.text, //add bookname
          'authorName': _authorNameController.text, //add author name

          'reserved': false, //set reserve state
          'year': _yearController.text, //set year
        });
        //change variable to initial stat after updating data on firestore

        setState(() {
          _isUploading = false;
          _showSuccessMessage = true;
        });

        // Reset the form after successful upload
        _formKey.currentState!.reset();

        print('Uploaded!'); // Print 'Uploaded' to the console
      } catch (e) {
        setState(() {
          _isUploading = false;
          _showSuccessMessage = false;
        });
        print('Error adding book: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //app bar for addbook page
      appBar: AppBar(
        title: const Text(
          "Welcome",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[800],
      ),
      //body is a form containing data in text fields
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _bookNameController,
              style: TextStyle(color: Colors.white),
              //set input decoration
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.purple[800],
                labelText: 'Book Name',
                labelStyle: TextStyle(color: Colors.white),
                //Border on enabling the textfield

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                //set border on focused textformfield
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                //set border on error textformfield
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Book Name is required'; // Validation error message
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFormField(
              controller: _authorNameController,
              style: TextStyle(color: Colors.white),
              //set input decoration

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.purple[800],
                labelText: 'Author Name',
                labelStyle: TextStyle(color: Colors.white),
                //Border on enabling the textfield

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                //set border on focused textformfield
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                //set border on error textformfield
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Author Name is required'; // Validation error message
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFormField(
              controller: _yearController,
              style: TextStyle(color: Colors.white),
              //set input decoration

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.purple[800],
                labelText: 'Year',
                labelStyle: TextStyle(color: Colors.white),
                //Border on enabling the textfield
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                //set border on focused textformfield
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                //set border on error textformfield
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Year is required'; // Validation error message
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            if (_isUploading)
              CircularProgressIndicator()
            else if (_showSuccessMessage)
              Text(
                "Book added successfully!",
                style: TextStyle(color: Colors.green, fontSize: 18),
              )
            else
              SizedBox(
                width: size.width,
                height: size.height * 0.07,
                child: ElevatedButton(
                  onPressed: _addBookToFirestore,
                  child: Text(
                    "Add Book to Library",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
