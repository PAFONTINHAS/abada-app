import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/home_page_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/login_widget.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/register_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.initialTab = 0, this.publicSection = 0});

  final int initialTab;
  final int publicSection;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomePageController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isLoginTab = initialTab == 0;
      if (controller.isLogin != isLoginTab) {
        controller.setIsLogin(isLoginTab);
      }
    });

    return DefaultTabController(
      length: 2,
      initialIndex: initialTab,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 12,
          title: TextButton.icon(
            onPressed: () {
              context.go(
                publicSection == 1 ? '/welcome/news/archive' : '/welcome/news',
              );
            },
            icon: const Icon(Icons.arrow_back),
            label: Text(
              publicSection == 1
                  ? 'Voltar ao Acervo Histórico'
                  : 'Voltar às Notícias',
            ),
            style: TextButton.styleFrom(
              foregroundColor: ColorConstants.indigoColor,
            ),
          ),
        ),
        body: SafeArea(
          child: Selector<HomePageController, bool>(
            selector: (_, pageController) => pageController.isLogin,
            builder: (context, isLogin, child) {
              final content = Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: isLogin ? 8 : 16,
                      bottom: isLogin ? 8 : 12,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: isLogin ? 58 : 78,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  Text(
                    "Bem-vindo(a)! 👋",
                    style: TextStyle(
                      fontSize: isLogin ? 26 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Faça o login para acessar sua conta",
                    style: const TextStyle(fontSize: 14),
                  ),

                  TabBar(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 30,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Color.fromRGBO(193, 194, 199, 1),
                    indicatorColor: Color.fromRGBO(78, 39, 211, 100),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Color.fromRGBO(78, 39, 211, 100),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    onTap: (index) => index == 0
                        ? controller.setIsLogin(true)
                        : controller.setIsLogin(false),
                    tabs: [
                      Tab(text: "Entrar"),
                      Tab(text: "Cadastre-se"),
                    ],
                  ),

                  Selector<HomePageController, bool>(
                    selector: (_, controller) => controller.isLogin,
                    builder: (context, isLogin, child) =>
                        isLogin ? const LoginWidget() : const RegisterWidget(),
                  ),
                ],
              );

              if (isLogin) {
                return content;
              }

              return SingleChildScrollView(child: content);
            },
          ),
        ),
      ),
    );
  }
}
