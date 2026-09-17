import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/core/providers/auth_providers.dart';
import 'package:sistema_abada_capoeira/core/providers/profile_providers.dart';
import 'package:sistema_abada_capoeira/core/providers/splash_providers.dart';
import 'package:sistema_abada_capoeira/core/providers/fee_exemption_providers.dart';
import 'package:sistema_abada_capoeira/core/providers/membership_validation_providers.dart';

class ProviderInjection {
  ProviderInjection() {
    _buildProviders();
  }

  late final List<SingleChildWidget> providers;

  void _buildProviders() {
    providers = [

      ...AuthProviders.providers,
      ...ProfileProviders.providers,
      ...SplashProviders.providers,
      ...MembershipValidationProvider.providers,
      ...FeeExemptionProviders.providers,
    ];
  }
}