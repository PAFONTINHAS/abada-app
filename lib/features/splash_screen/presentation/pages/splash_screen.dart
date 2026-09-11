import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema_abada_capoeira/core/constants/app_spacing.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/splash_screen/presentation/controllers/data_loading_controller.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareUserApp();
    });
  }


  Future<void> _prepareUserApp() async{

    final DataLoadingController dataLoadingController = context.read<DataLoadingController>();
    final AuthController authController = context.read<AuthController>();
    final ProfileController profileController = context.read<ProfileController>();

    final User? user = authController.user;

    if(user == null){
      throw Exception("Usuário não autenticado");
    }

    try{ 

      await dataLoadingController.fetchUserData(authController, profileController);

      final userRole = profileController.userProfile.role;

      if(userRole == UserRole.unknown) throw Exception("Papel de Usuário não reconhecido");

      await dataLoadingController.finishSplash(authController, userRole);

    }catch(error, stack){

      LoggingService.displayError( "Erro na inicialização do dispositivo. Saindo da conta...", error: error, stack: stack,);

      await authController.logoutUser();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.horizontal16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              AppSpacing.gapV40,

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },

                child: Selector<DataLoadingController, String>(
                  selector: (_, controller) => controller.progressText,
                  builder: (context, value, child){
                    return Text(
                      value,
                      key: ValueKey<String>(value),
                      textAlign: TextAlign.center,
                    );
                  } 
                ),
              ),

              AppSpacing.gapV24,

              Selector<DataLoadingController, double>(
                selector: (_, controller) => controller.progress,
                builder: (context, value, child){
                  return    ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      minHeight: 10,
                    ),
                  );
 
                } 
              ),

              AppSpacing.gapV16,

              Selector<DataLoadingController, double>(
                selector: (_, controller) => controller.progress,
                builder: (context, value, child){
                  return Text( 
                    "${(value * 100).toInt()}%",
                  );
                } 
              ),

            ],
          ),
        ),
      ),
    );
  }
}
