import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/auth/data/repository/auth_repository_impl.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/repository/auth_repository.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/home_page_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/login_form_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/register_form_controller.dart';

class AuthProvider {


  AuthProvider ._();


  static final LoginUserUsecase loginUserUsecase = LoginUserUsecase(authRepository);
  static final AuthRemoteDatasource authRemoteDatasource = AuthRemoteDatasourceImpl();
  static final AuthRepository authRepository = AuthRepositoryImpl(authRemoteDatasource);
  static final RegisterUserUsecase registerUserUsecase = RegisterUserUsecase(authRepository);

  static List<SingleChildWidget> providers = [

    ChangeNotifierProvider(create: (_) => HomePageController()),
    ChangeNotifierProvider(create: (_) => LoginFormController(loginUserUsecase)),
    ChangeNotifierProvider(create: (_) => RegisterFormController(registerUserUsecase))

  ];






}