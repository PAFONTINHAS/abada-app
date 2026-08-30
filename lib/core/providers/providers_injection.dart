import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/core/providers/auth_providers.dart';
import 'package:sistema_abada_capoeira/core/providers/splash_providers.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';

class ProvidersInjection {
  

  ProvidersInjection(){
    _buildProviders();
  }

  final AuthController authController = AuthProvider.authController;
  late final List<SingleChildWidget> providers;

  void _buildProviders(){

    providers = [
      ...AuthProvider.providers,
      ...SplashProviders.providers
    ];
  }
}