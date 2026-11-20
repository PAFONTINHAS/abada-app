import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/metrics/presentation/pages/metrics_page.dart';

class MetricsRoutes {

  MetricsRoutes._();

  static final route = GoRoute(
    path: '/metrics',
    builder: (context, state){
      return MetricsPage();
    },
  );


}