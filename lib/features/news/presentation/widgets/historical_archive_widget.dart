import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/archive_section_widget.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/section_label_widget.dart';

class HistoricalArchiveWidget extends StatelessWidget {
  const HistoricalArchiveWidget({super.key, required this.isPublic});

  final bool isPublic;

  @override
  Widget build(BuildContext context) {
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
        if (isPublic) ...[
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
        const SectionLabelWidget(
          icon: Icons.menu_book_outlined,
          label: 'Acervo Histórico',
        ),
        const SizedBox(height: 14),
        const ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          child: Image(
            image: AssetImage('assets/images/capoeira_event_image.jpg'),
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
      ],
    );
  }
}
