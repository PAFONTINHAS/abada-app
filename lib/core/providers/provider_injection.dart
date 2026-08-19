import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/core/providers/auth_providers.dart';

class ProviderInjection {
  

  ProviderInjection(){
    _buildProviders();
  }

  late final List<SingleChildWidget> providers;



  void _buildProviders(){

    providers = [

      ...AuthProvider.providers
    ];


  }



}