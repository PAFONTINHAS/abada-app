import 'package:provider/single_child_widget.dart';

import 'membership_validation_providers.dart';

class ProviderInjection {
  ProviderInjection() {
    _buildProviders();
  }

  late final List<SingleChildWidget> providers;

  void _buildProviders() {
    providers = [
      ...MembershipValidationProvider.providers,
    ];
  }
}