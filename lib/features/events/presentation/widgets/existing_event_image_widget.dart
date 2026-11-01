import 'package:flutter/material.dart';

class ExistingEventImageWidget extends StatelessWidget {
  const ExistingEventImageWidget({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        semanticLabel: 'Imagem atual do evento',
        errorBuilder: (_, error, stack) => const SizedBox(
          height: 80,
          child: Center(
            child: Text('Não foi possível carregar a imagem atual.'),
          ),
        ),
      ),
    ),
  );
}
