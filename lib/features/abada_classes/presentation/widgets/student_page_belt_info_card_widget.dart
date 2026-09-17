import 'package:flutter/material.dart';

class StudentPageBeltInfoCardWidget extends StatelessWidget {
  const StudentPageBeltInfoCardWidget({
    super.key,
    required this.className,
    required this.hour,
    required this.location,
    required this.professor,
    required this.studentQuantity,
  });

  final String className;
  final String hour;
  final String location;
  final String professor;
  final int studentQuantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0), // Espaçamento interno
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
      ),
      // 1. COLUMN PRINCIPAL (Título em cima, conteúdo embaixo)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'Minhas informações',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20), // Espaço entre o título e os dados
          // 2. INTRINSIC HEIGHT (O segredo para a linha vertical funcionar)
          IntrinsicHeight(
            child: Row(
              children: [
                // 3. LADO ESQUERDO (Imagem + Textos)
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      // Imagem da corda (com ClipOval ou ClipRRect)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // Borda redonda se necessário
                        child: Image.asset(
                          'assets/images/yellow_belt.jpeg', // Substitua pela sua imagem
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Coluna com os textos da esquerda
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Corda Atual',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Corda Amarela',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 4. DIVISOR VERTICAL
                VerticalDivider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  width: 32, // Espaço horizontal que o divisor ocupa
                ),

                // 5. LADO DIREITO (Textos)
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Entrei em',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '15/02/2025',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
