import 'package:flutter/material.dart';

class HomeUserPage extends StatelessWidget {
  const HomeUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Column(

        children: [

          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              "Ó vida, por que eres tão cruel com seus semelhantes?",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          )
          
        ],
      ),
    );
  }
}