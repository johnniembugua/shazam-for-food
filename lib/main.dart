import 'package:cats_or_dogs/homescreen.dart';
import 'package:flutter/material.dart';
import 'explore.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Know Your Food",
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        /* textTheme: GoogleFonts.montserratTextTheme(), */
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/explore': (BuildContext context) => Explore()
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/asparagus.png',
                          height: 350,
                          width: 350,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Container(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Spacer(),
                          Text('v1.0'),
                          Spacer(
                            flex: 4,
                          ),
                          Text(
                            '©johnnie2021',
                          ),
                          Spacer(),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
