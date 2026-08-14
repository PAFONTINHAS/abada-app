import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("HomePage"),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(child:  Text("Home Page"))
    );
  }
}



