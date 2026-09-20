import 'package:sistema_abada_capoeira/core/providers/class_providers.dart';

import 'membership_validation_providers.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/core/providers/auth_providers.dart';
import 'package:sistema_abada_capoeira/core/providers/splash_providers.dart';
import 'package:sistema_abada_capoeira/core/providers/profile_providers.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/core/providers/fee_exemption_providers.dart';
import 'package:sistema_abada_capoeira/core/providers/membership_validation_providers.dart';

class ProvidersInjection {
  ProvidersInjection() {
    _buildProviders();
  }

  final AuthController authController = AuthProviders.authController;
  late final List<SingleChildWidget> providers;

  void _buildProviders() {
    providers = [
      ...AuthProviders.providers,
      ...ClassProviders.providers,
      ...SplashProviders.providers,
      ...ProfileProviders.providers,
      ...MembershipValidationProviders.providers,
      ...FeeExemptionProviders.providers,
    ];
  }
}
