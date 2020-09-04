import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lyrically',
      theme: ThemeData(
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _globalkey =
      GlobalKey<ScaffoldState>();
  TextEditingController artistecontroller = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();

  String lyrics;

  searchlyrics() async {
    if (artistecontroller.text != '' && titlecontroller.text != '') {
      var url =
          'https://api.lyrics.ovh/v1/${artistecontroller.text}/${titlecontroller.text}';
      var response = await http.get(url);
      var result = jsonDecode(response.body);
      if (result['error'] == 'No lyrics found') {
        _globalkey.currentState.showSnackBar(
          SnackBar(
            content: Text("Sorry! Lyrics not found in our database"),
          ),
        );
      } else {
        setState(() {
          lyrics = result['lyrics'];
        });
      }
    } else {
      _globalkey.currentState.showSnackBar(
        SnackBar(
          content: Text("You have to fill both fields"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalkey,
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              color: Colors.amber,
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    "Search for lyrics",
                    style: GoogleFonts.montserrat(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: Colors.purple,
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: artistecontroller,
                      decoration: InputDecoration(
                        labelText: "Artiste name",
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Icon(Icons.person),
                        focusColor: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: titlecontroller,
                      decoration: InputDecoration(
                        labelText: "Song Title",
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Icon(Icons.music_note),
                        focusColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          RaisedButton(
            onPressed: () => searchlyrics(),
            color: Colors.purple,
            child: Text(
              "Search",
              style: GoogleFonts.montserrat(
                color: Colors.white,
              ),
            ),
          ),
          lyrics == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    lyrics,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ],
      )),
    );
  }
}
