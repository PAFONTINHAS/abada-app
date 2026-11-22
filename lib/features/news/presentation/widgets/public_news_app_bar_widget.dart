import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class PublicNewsAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const PublicNewsAppBarWidget({super.key, this.section = 0});

  final int section;

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    final isArchive = section == 1;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 6,
        left: 14,
        right: 14,
        bottom: 6,
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/logo.png',
                height: 42,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            height: 36,
            child: FilledButton(
              onPressed: () => context.go(
                '/?tab=login${isArchive ? '&section=archive' : ''}',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: ColorConstants.indigoColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(72, 36),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Entrar'),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 36,
            child: OutlinedButton(
              onPressed: () => context.go(
                '/?tab=register${isArchive ? '&section=archive' : ''}',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorConstants.indigoColor,
                side: const BorderSide(color: ColorConstants.indigoColor),
                minimumSize: const Size(84, 36),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Cadastrar'),
            ),
          ),
        ],
      ),
    );
  }
}
