import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mylibrary/firebase_options.dart';
import 'package:mylibrary/readinglist.dart';
import 'package:mylibrary/reservbook.dart';
import 'package:mylibrary/reservedbooks.dart';

void main() async {
  //firebase initialization befor app start to load data
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //return app widget having a home page screen
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //display home screen as a main page
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //app bar for main page
      appBar: AppBar(
        //title of main page
        title: const Text(
          "Welcome ",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[800],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //firest button to navigate to the Add Book Page
          // SizedBox(
          //   width: size.width,
          //   child: ElevatedButton(
          //       onPressed: (() {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => AddBook()),
          //         );
          //       }),
          //       child: const Text(
          //         "Add Book",
          //         style: TextStyle(
          //             fontSize: 18,
          //             color: Colors.black,
          //             fontWeight: FontWeight.w600),
          //       )),
          // ),
          // //second button to navigate to the Reserve Book Page
          SizedBox(
            width: size.width,
            child: ElevatedButton(
                onPressed: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReserveBook()),
                  );
                }),
                child: Text(
                  "Reserve Book",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                )),
          ),
          SizedBox(
            width: size.width,
            child: ElevatedButton(
                onPressed: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyReserversScreen()),
                  );
                }),
                child: Text(
                  "Reading List",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                )),
          ),
          SizedBox(
            width: size.width,
            child: ElevatedButton(
                onPressed: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReservedBooksScreen()),
                  );
                }),
                child: Text(
                  "Reserved Books",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                )),
          ),
        ],
      ),
    );
  }
}
