import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/news_card_widget.dart';
import 'package:sistema_abada_capoeira/features/news/presentation/widgets/section_label_widget.dart';

class NewsListWidget extends StatelessWidget {
  const NewsListWidget({super.key, required this.isPublic});

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
          icon: Icons.newspaper_outlined,
          label: 'Notícias',
        ),
        const SizedBox(height: 14),
        _buildNewsCard(
          context,
          imagePath: 'assets/images/capoeira_event_image.jpg',
          title:
              'XV Jogos Mundiais ABADÁ-Capoeira reuniram atletas de mais de 10 países no Rio de Janeiro',
          date: '24 ago 2026',
          scope: 'Nacional',
          detailTitle: 'XV Jogos Mundiais ABADÁ-Capoeira',
          detailDescription:
              'O encontro reuniu praticantes de diferentes regiões do Brasil e de países parceiros para competições, rodas e atividades pedagógicas.',
        ),
        const SizedBox(height: 14),
        _buildNewsCard(
          context,
          imagePath: 'assets/images/generic_event_image.jpg',
          title:
              'Portugal recebe 19 atletas ao registrar participação histórica nos Mundiais ABADÁ',
          date: '27 ago 2026',
          scope: 'Internacional',
          detailTitle: 'ABADÁ-Capoeira em Portugal',
          detailDescription:
              'Representantes portugueses participaram de eventos internacionais, oficinas e rodas que fortaleceram a presença da capoeira na Europa.',
        ),
        const SizedBox(height: 14),
        _buildNewsCard(
          context,
          imagePath: 'assets/images/capoeira_member_profile_picture.png',
          title:
              'Projeto Capoeira e Cidadania retorna às aulas fortalecendo a inclusão social',
          date: '02 fev 2026',
          scope: 'Social',
          detailTitle: 'Projeto Capoeira e Cidadania',
          detailDescription:
              'A iniciativa voltou a atender crianças e jovens em comunidades por meio da educação, da arte e dos valores da capoeira.',
        ),
      ],
    );
  }

  Widget _buildNewsCard(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String date,
    required String scope,
    required String detailTitle,
    required String detailDescription,
  }) {
    return NewsCardWidget(
      imagePath: imagePath,
      title: title,
      date: date,
      scope: scope,
      onTap: () => showModalBottomSheet<void>(
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
                  detailTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: ColorConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  detailDescription,
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
      ),
    );
  }
}
