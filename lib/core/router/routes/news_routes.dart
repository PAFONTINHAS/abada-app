import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/metrics/presentation/pages/metrics_page.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/pages/news_page.dart';

class NewsRoutes {

  NewsRoutes._();

  static final route = GoRoute(
    path: '/news',
    builder: (context, state){
      return NewsPage();
    },
  );


}