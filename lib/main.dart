import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sistema_abada_capoeira/core/router/app_router.dart';
import 'package:sistema_abada_capoeira/core/providers/providers_injection.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final ProvidersInjection providerInjection = ProvidersInjection();

  final appRouter = AppRouter(authController: providerInjection.authController);

  runApp( 

    MultiProvider(
      providers: [

        Provider.value(value: providerInjection),

        ...providerInjection.providers

      ] ,
      child: MyApp(router: appRouter.router),
    )  
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;  

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white
      ),
      title: 'Flutter Demo',
      routerConfig: router,
    );
  }
}



