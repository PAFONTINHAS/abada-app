import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/shared/appBar/custom_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/historical_archive_widget.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/news_list_widget.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/page_indicator_widget.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/public_news_app_bar_widget.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key, this.isPublic = false, this.initialSection = 0});

  final bool isPublic;
  final int initialSection;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late final PageController pageController;
  late int selectedSection;

  @override
  void initState() {
    super.initState();
    selectedSection = widget.initialSection;
    pageController = PageController(initialPage: selectedSection);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void changeSection(int section) {
    pageController.animateToPage(
      section,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isPublic
          ? PublicNewsAppBarWidget(section: selectedSection)
          : CustomAppBarWidget(
              pageTitle: selectedSection == 0 ? 'Notícias' : 'Acervo Histórico',
              onNotificationTap: () {},
            ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() => selectedSection = index);
                },
                children: [
                  StandardScaffoldBodyWidget(
                    child: NewsListWidget(isPublic: widget.isPublic),
                  ),
                  StandardScaffoldBodyWidget(
                    child: HistoricalArchiveWidget(isPublic: widget.isPublic),
                  ),
                ],
              ),
            ),
            PageIndicatorWidget(
              selectedSection: selectedSection,
              onSelected: changeSection,
            ),
          ],
        ),
      ),
    );
  }
}
