import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/home_page_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/login_widget.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/register_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = context.read<HomePageController>();

    return DefaultTabController(
      length: 2, 
      child: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image.asset('assets/images/logo.png')),

              Text("Bem-vindo(a)!"),
              Text("Faça o login para acessar sua conta"),

              TabBar(
                padding: EdgeInsets.all(50),
                labelColor: Colors.white,
                unselectedLabelColor: Color.fromRGBO(113, 118, 168, 100),
                indicatorColor: Color.fromRGBO(78, 39, 211, 100),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Color.fromRGBO(78, 39, 211, 100),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                onTap: (index) => index == 0 ? controller.setIsLogin(true) : controller.setIsLogin(false),
                tabs: [
                  Tab(text: "Entrar",),
                  Tab(text: "Cadastre-se",)
                ],
              ),

              Selector<HomePageController, bool>(
                selector: (_, controller) => controller.isLogin, 
                builder: (context, isLogin, child) => 
                  isLogin 
                  ? LoginWidget() 
                  : RegisterWidget()
                ),
            ],
          ),
        ),
      ),
    )
    
    )  ;
  }
}
