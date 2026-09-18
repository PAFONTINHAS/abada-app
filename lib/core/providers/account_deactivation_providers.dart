import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/features/account_deactivation/data/datasources/account_deactivation_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/account_deactivation/data/datasources/account_deactivation_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/account_deactivation/data/repository/account_deactivation_repository_impl.dart';
import 'package:sistema_abada_capoeira/features/account_deactivation/domain/repository/account_deactivation_repository.dart';
import 'package:sistema_abada_capoeira/features/account_deactivation/domain/usecases/deactivate_account_usecase.dart';
import 'package:sistema_abada_capoeira/features/account_deactivation/presentation/controllers/account_deactivation_controller.dart';

class AccountDeactivationProviders {
  AccountDeactivationProviders._();

  static final AccountDeactivationRemoteDatasource remoteDatasource =
      AccountDeactivationRemoteDatasourceImpl();
  static final AccountDeactivationRepository repository =
      AccountDeactivationRepositoryImpl(remoteDatasource);
  static final DeactivateAccountUseCase deactivateAccountUseCase =
      DeactivateAccountUseCase(repository);

  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(
      create: (_) => AccountDeactivationController(deactivateAccountUseCase),
    ),
  ];
}
