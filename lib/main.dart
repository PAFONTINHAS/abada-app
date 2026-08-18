import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/providers/provider_injection.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/home_page_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/login_form_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/register_form_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/pages/home_page.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  final ProviderInjection providerInjection = ProviderInjection();

  await Firebase.initializeApp();

  runApp( 

    MultiProvider(
      providers: [

        Provider.value(value: providerInjection),

        ...providerInjection.providers

      ] ,
      child: const MyApp(),
    )  
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white
      ),
      title: 'Flutter Demo',
      home: HomePage()
    );
  }
}



