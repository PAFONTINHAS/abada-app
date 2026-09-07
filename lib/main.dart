import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/providers/provider_injection.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/home_page_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/login_form_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/register_form_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/pages/home_page.dart';
import 'package:sistema_abada_capoeira/features/profile/data/datasources/profile_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/pages/profile_page.dart';
import 'package:sistema_abada_capoeira/features/profile/data/repository/user_profile_repository_impl.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/decide_change_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/get_change_requests_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ProviderInjection providerInjection = ProviderInjection();

  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: providerInjection),
        ...providerInjection.providers,

        Provider<ProfileRepository>(
          create: (_) => ProfileRepositoryImpl(ProfileRemoteDatasourceImpl()),
        ),

        ProxyProvider<ProfileRepository, GetChangeRequestsUseCase>(
          update: (_, repository, __) => GetChangeRequestsUseCase(repository),
        ),

        ProxyProvider<ProfileRepository, DecideChangeRequestUseCase>(
          update: (_, repository, __) => DecideChangeRequestUseCase(repository),
        ),

        ChangeNotifierProvider<ProfileController>(
          create: (context) =>
              ProfileController(context.read<ProfileRepository>()),
        ),
      ],
      child: const MyApp(),
    ),
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
        scaffoldBackgroundColor: Colors.white,
      ),
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}
