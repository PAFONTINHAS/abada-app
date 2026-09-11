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

                Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 50),
                  child: Center(child: Image.asset('assets/images/logo.png')),
                ),
            

              Text("Bem-vindo(a)! 👋", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold ),),
              Text("Faça o login para acessar sua conta", style: TextStyle(fontSize: 15),),

              TabBar(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                labelColor: Colors.white,
                unselectedLabelColor: Color.fromRGBO(193, 194, 199, 1),
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
                  ? const LoginWidget() 
                  : const RegisterWidget()
                ),
            ],
          ),
        ),
      ),
    )
    
    )  ;
  }
}
