import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/appBar/custom_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/news_card_widget.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/public_news_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/archive_section_widget.dart';

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
              pageTitle: selectedSection == 0 ? "Notícias" : "Acervo Histórico",
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
                  StandardScaffoldBodyWidget(child: _buildNewsList(context)),
                  StandardScaffoldBodyWidget(child: _buildHistoricalArchive()),
                ],
              ),
            ),
            _PageIndicator(
              selectedSection: selectedSection,
              onSelected: changeSection,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seja bem-vindo(a)! 👋',
          style: TextStyle(
            color: ColorConstants.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (widget.isPublic) ...[
          const SizedBox(height: 6),
          const Text(
            'Entre ou cadastre-se para acessar o aplicativo.',
            style: TextStyle(
              color: ColorConstants.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
        const SizedBox(height: 14),
        const _SectionLabel(icon: Icons.newspaper_outlined, label: 'Notícias'),
        const SizedBox(height: 14),
        NewsCardWidget(
          imagePath: 'assets/images/capoeira_event_image.jpg',
          title:
              'XV Jogos Mundiais ABADÁ-Capoeira reuniram atletas de mais de 10 países no Rio de Janeiro',
          date: '24 ago 2026',
          scope: 'Nacional',
          onTap: () => _showNewsDetails(
            context,
            'XV Jogos Mundiais ABADÁ-Capoeira',
            'O encontro reuniu praticantes de diferentes regiões do Brasil e de países parceiros para competições, rodas e atividades pedagógicas.',
          ),
        ),
        const SizedBox(height: 14),
        NewsCardWidget(
          imagePath: 'assets/images/generic_event_image.jpg',
          title:
              'Portugal recebe 19 atletas ao registrar participação histórica nos Mundiais ABADÁ',
          date: '27 ago 2026',
          scope: 'Internacional',
          onTap: () => _showNewsDetails(
            context,
            'ABADÁ-Capoeira em Portugal',
            'Representantes portugueses participaram de eventos internacionais, oficinas e rodas que fortaleceram a presença da capoeira na Europa.',
          ),
        ),
        const SizedBox(height: 14),
        NewsCardWidget(
          imagePath: 'assets/images/capoeira_member_profile_picture.png',
          title:
              'Projeto Capoeira e Cidadania retorna às aulas fortalecendo a inclusão social',
          date: '02 fev 2026',
          scope: 'Social',
          onTap: () => _showNewsDetails(
            context,
            'Projeto Capoeira e Cidadania',
            'A iniciativa voltou a atender crianças e jovens em comunidades por meio da educação, da arte e dos valores da capoeira.',
          ),
        ),
      ],
    );
  }

  Widget _buildHistoricalArchive() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seja bem-vindo(a)! 👋',
          style: TextStyle(
            color: ColorConstants.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (widget.isPublic) ...[
          const SizedBox(height: 6),
          const Text(
            'Entre ou cadastre-se para acessar o aplicativo.',
            style: TextStyle(
              color: ColorConstants.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
        const SizedBox(height: 14),
        const _SectionLabel(
          icon: Icons.menu_book_outlined,
          label: 'Acervo Histórico',
        ),
        SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          child: Image(
            image: AssetImage('assets/images/capoeira_event_image.jpg'),
            width: double.infinity,
            height: 190,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 18),
        ArchiveSectionWidget(
          title: 'O que é o ABADÁ-Capoeira?',
          content:
              'Entidade sem fins lucrativos dedicada a difundir a cultura brasileira por meio da Capoeira, promovendo integração social e cidadania para todas as classes.',
        ),
        ArchiveSectionWidget(
          title: 'Nossa Missão',
          content:
              'Sistematizar e centralizar informações de todos os núcleos de Capoeira do Brasil e do mundo, facilitando o acesso ao conhecimento e o aperfeiçoamento técnico dos praticantes e professores.',
        ),
        ArchiveSectionWidget(
          title: 'Fundadores',
          content:
              'Fundado pelos mestres Camisa e Nô, o ABADÁ-Capoeira nasceu da busca por organização pedagógica, expansão internacional e preservação da identidade da Capoeira.',
        ),
        ArchiveSectionWidget(
          title: 'Organizações vinculadas',
          content:
              'Grupos e núcleos oficiais em diferentes estados e países mantêm intercâmbio cultural, eventos, competições e formação técnica vinculados à organização.',
        ),
        ArchiveSectionWidget(
          title: 'Impacto social',
          content:
              'Por meio de projetos comunitários, oficinas, eventos e iniciativas educacionais, a organização utiliza a Capoeira como ferramenta de inclusão, cidadania e desenvolvimento humano.',
        ),
        ArchiveSectionWidget(
          title: 'Movimentos e iniciativas',
          content:
              'Entre suas principais iniciativas estão os Jogos Mundiais, encontros internacionais, festivais, projetos sociais e ações voltadas à formação de mestres, professores e alunos.',
        ),
      ],
    );
  }

  void _showNewsDetails(
    BuildContext context,
    String title,
    String description,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  height: 1.45,
                  color: ColorConstants.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ColorConstants.indigoLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: ColorConstants.indigoDark),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: ColorConstants.indigoDark,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.selectedSection,
    required this.onSelected,
  });

  final int selectedSection;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) {
              final isSelected = selectedSection == index;
              return GestureDetector(
                onTap: () => onSelected(index),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: isSelected ? 11 : 9,
                    height: isSelected ? 11 : 9,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorConstants.indigoColor
                          : ColorConstants.borderColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Container(
            width: 48,
            height: 3,
            decoration: BoxDecoration(
              color: ColorConstants.textPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
