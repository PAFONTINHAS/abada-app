import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/shared/appBar/custom_app_bar_widget.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        pageTitle: "Notícias",
        onNotificationTap: (){} ,
      ),
      body: Column(children: [],),
    );
  }
}