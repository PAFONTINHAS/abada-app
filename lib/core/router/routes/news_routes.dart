import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/pages/news_page.dart';

class NewsRoutes {
  NewsRoutes._();

  static final route = GoRoute(
    path: '/news',
    builder: (context, state) {
      return const NewsPage();
    },
    routes: [
      GoRoute(
        path: 'archive',
        builder: (context, state) {
          return const NewsPage(initialSection: 1);
        },
      ),
    ],
  );
}
