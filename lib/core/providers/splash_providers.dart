import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/features/splash_screen/presentation/controllers/data_loading_controller.dart';

class SplashProviders {

  SplashProviders._();

  static List<SingleChildWidget> providers = [

    ChangeNotifierProvider(create: (_) => DataLoadingController())
  ];

}