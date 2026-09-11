import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/profile/data/datasources/profile_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/profile/data/repository/profile_repository_impl.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/decide_change_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/get_change_requests_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/get_current_user_profile_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/request_belt_nickname_change_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/update_info_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/upload_profile_photo_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/request_status_controller.dart';

class ProfileProviders {

  ProfileProviders._();

  static final ProfileRemoteDatasource profileRemoteDatasource = ProfileRemoteDatasourceImpl();
  static final ProfileRepository profileRepository = ProfileRepositoryImpl(profileRemoteDatasource);

  static final UpdateProfileInfoUseCase updateProfileInfoUseCase = UpdateProfileInfoUseCase(profileRepository);
  static final GetChangeRequestsUseCase getChangeRequestsUseCase = GetChangeRequestsUseCase(profileRepository);
  static final UploadProfilePhotoUsecase uploadProfilePhotoUsecase = UploadProfilePhotoUsecase(profileRepository);
  static final DecideChangeRequestUseCase decideChangeRequestUseCase = DecideChangeRequestUseCase(profileRepository);
  static final GetCurrentUserProfileUsecase getCurrentUserProfileUsecase = GetCurrentUserProfileUsecase(profileRepository);
  static final RequestBeltNicknameChangeUseCase requestBeltNicknameChangeUseCase = RequestBeltNicknameChangeUseCase(profileRepository);
  
  static final ProfileController profileController = ProfileController(
    getCurrentUserProfileUsecase,
    updateProfileInfoUseCase,
    uploadProfilePhotoUsecase,
    requestBeltNicknameChangeUseCase,
  );


  static final RequestStatusController requestStatusController = RequestStatusController(getChangeRequestsUseCase);

  static List<SingleChildWidget> providers = [

    ChangeNotifierProvider(create: (_) => profileController),
    ChangeNotifierProvider(create: (_) => requestStatusController)
  ];



}