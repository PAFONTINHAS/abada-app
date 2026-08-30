import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sistema_abada_capoeira/core/providers/providers_injection.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/pages/coordenator_dashboard_page.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/pages/student_dashboard_page.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  final ProvidersInjection providerInjection = ProvidersInjection();

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white
      ),
      title: 'Flutter Demo',
      home: StudentDashboardPage()
    );
  }
}



