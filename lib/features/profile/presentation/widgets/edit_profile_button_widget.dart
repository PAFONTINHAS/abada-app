import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/pages/edit_profile_page.dart';

class EditProfileButtonWidget extends StatelessWidget {
  const EditProfileButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(right: 16),
      icon: const Icon(Icons.settings_outlined, color: Colors.black54),
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const EditProfilePage()));
      },
    );
  }
}
