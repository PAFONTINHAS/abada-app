import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/appBar/custom_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/archive_section_widget.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/public_news_app_bar_widget.dart';

class HistoricalArchivePage extends StatelessWidget {
  const HistoricalArchivePage({super.key, this.isPublic = false});

  final bool isPublic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isPublic
          ? const PublicNewsAppBarWidget()
          : CustomAppBarWidget(
              pageTitle: "Acervo Histórico",
              onNotificationTap: () {},
            ),
      body: StandardScaffoldBodyWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar para Notícias'),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/capoeira_event_image.jpg',
                width: double.infinity,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 18),
            const ArchiveSectionWidget(
              title: 'O que é o ABADÁ-Capoeira?',
              content:
                  'Entidade sem fins lucrativos dedicada a difundir a cultura brasileira por meio da Capoeira, promovendo integração social e cidadania para todas as classes.',
            ),
            const ArchiveSectionWidget(
              title: 'Nossa Missão',
              content:
                  'Sistematizar e centralizar informações de todos os núcleos de Capoeira do Brasil e do mundo, facilitando o acesso ao conhecimento e o aperfeiçoamento técnico dos praticantes e professores.',
            ),
            const ArchiveSectionWidget(
              title: 'Fundadores',
              content:
                  'Fundado pelos mestres Camisa e Nô, o ABADÁ-Capoeira nasceu da busca por organização pedagógica, expansão internacional e preservação da identidade da Capoeira.',
            ),
            const ArchiveSectionWidget(
              title: 'Organizações vinculadas',
              content:
                  'Grupos e núcleos oficiais em diferentes estados e países mantêm intercâmbio cultural, eventos, competições e formação técnica vinculados à organização.',
            ),
            const ArchiveSectionWidget(
              title: 'Impacto social',
              content:
                  'Por meio de projetos comunitários, oficinas, eventos e iniciativas educacionais, a organização utiliza a Capoeira como ferramenta de inclusão, cidadania e desenvolvimento humano.',
            ),
            const ArchiveSectionWidget(
              title: 'Movimentos e iniciativas',
              content:
                  'Entre suas principais iniciativas estão os Jogos Mundiais, encontros internacionais, festivais, projetos sociais e ações voltadas à formação de mestres, professores e alunos.',
            ),
            const ArchiveSectionWidget(
              title: 'Conteúdo institucional',
              content:
                  'Graduação, metodologia de ensino, calendário internacional, eventos culturais e a história das cordas fazem parte do acervo institucional do ABADÁ-Capoeira.',
            ),
            const SizedBox(height: 12),
            const Text(
              'Conteúdo institucional de referência',
              style: TextStyle(
                color: ColorConstants.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
