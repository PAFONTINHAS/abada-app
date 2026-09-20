import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/waiting_layer/presentation/widgets/waiting_info_card_widget.dart';
import 'package:sistema_abada_capoeira/features/waiting_layer/presentation/widgets/pending_status_badge_widget.dart';
import 'package:sistema_abada_capoeira/features/waiting_layer/presentation/widgets/deactivate_account_dialog_widget.dart';
import 'package:sistema_abada_capoeira/features/waiting_layer/presentation/widgets/deactivate_account_button_widget.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo ABADÁ
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset('assets/images/logo.png', width: 100),
                ),
                SizedBox(height: 16),

                // Desenho ampulheta
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF3EFFF),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/waiting_icon.png',
                        width: 280,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ), //espaço entre o desenho e o texto cadastro em análise
                //cadastro em analise
                Text(
                  'Cadastro em análise',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF17152F),
                  ),
                ),
                SizedBox(height: 8),
                //pendente + icon
                Center(child: PendingStatusBadge()),
                SizedBox(height: 20),
                //instruções
                WaitingInfoCard(),
                SizedBox(height: 18),
                //botao editar meu perfil
                // TODO: integrar com RF04 - Gerenciar Perfil
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      debugPrint('Editar Perfil');
                    },
                    icon: Icon(Icons.person_outline, color: Colors.white),
                    label: Text(
                      'Editar meu perfil',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5424D6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //botao sair da conta
                // TODO: integrar com autenticação
                SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: ()  async {

                      final authController = context.read<AuthController>();

                      await authController.logoutUser();

                    },
                    icon: Icon(Icons.logout, color: Color(0xFF5424D6)),
                    label: Text(
                      'Sair da conta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF5424D6),
                      side: BorderSide(color: Color(0xFF5424D6)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                DeactivateAccountButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => DeactivateAccountDialog(
                        onConfirm: () async {
                          final authController = context.read<AuthController>();
                          final profileController = context
                              .read<ProfileController>();
                          final deactivated = await profileController
                              .deactivateAccount();
                          if (!deactivated || !dialogContext.mounted) {
                            return deactivated;
                          }

                          Navigator.pop(dialogContext);
                          return await authController.deleteCurrentUser();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
