import 'package:flutter/material.dart';

class StudentPageClassInfoCardWidget extends StatelessWidget {
  const StudentPageClassInfoCardWidget({
    super.key,
    required this.className,
    required this.hour,
    required this.location,
    required this.professor,
    required this.studentQuantity
  });

  
  final String className;
  final String hour;
  final String location;
  final String professor;
  final int studentQuantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      // O ClipRRect garante que a imagem do topo respeite o raio da borda
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11.0), // Levemente menor que a borda externa
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IMAGEM DO TOPO
            Container(
              height: 120,
              decoration:  BoxDecoration(
                color: Color(0xFF2B2073), // Cor de fundo caso a imagem demore a carregar
                // image: DecorationImage(
                //   // Substitua por NetworkImage ou AssetImage com a foto da turma
                //   image: AssetImage("assets/images/class_image.jpg"), 
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            
            // CONTEÚDO DO CARD
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título e Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Expanded(
                        child: Text(
                          className,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Ativa',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Informações em lista
                  _buildInfoRow(Icons.access_time, hour),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on_outlined, location),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.person_outline, professor),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.people_outline, '$studentQuantity alunos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para as linhas de informação com ícone
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}