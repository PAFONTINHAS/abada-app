import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/schedule_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/home_page_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/login_form_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/register_form_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/schedule_color_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/created_events_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_migration_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_products_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_requests_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/request_status_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_graduation_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/create_location_controller.dart';
import 'package:sistema_abada_capoeira/features/splash_screen/presentation/controllers/data_loading_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/student_class_selection_controller.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/controllers/request_result_controller.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/controllers/membership_validation_controller.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/controllers/fee_exemption_request_controller.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/controllers/fee_exemption_documents_controller.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/controllers/fee_exemption_complementation_controller.dart';

class ControllersUtils {
  ControllersUtils._();

  static void cleanControllers(BuildContext context){

    LoggingService.displayInfo("Limpando controllers");

    context.read<AuthController>().cleanController();
    context.read<ClassController>().cleanController();
    context.read<ScheduleController>().cleanController();
    context.read<EventFormController>().cleanController();
    context.read<ClassFormController>().cleanController();
    context.read<LoginFormController>().cleanController();
    context.read<DataLoadingController>().cleanController();
    context.read<ProfileFormController>().cleanController();
    context.read<RegisterFormController>().cleanController();
    context.read<EventDetailsController>().cleanController();
    context.read<RequestStatusController>().cleanController();
    context.read<EventProductsController>().cleanController();
    context.read<EventRequestsController>().cleanController();
    context.read<CreatedEventsController>().cleanController();
    context.read<CreateLocationController>().cleanController();
    context.read<ClassMigrationController>().cleanController();
    context.read<EventGraduationController>().cleanController();
    context.read<FeeExemptionRequestController>().cleanController();
    context.read<MembershipValidationController>().cleanController();
    context.read<FeeExemptionDocumentsController>().cleanController();
    context.read<StudentClassSelectionController>().cleanController();
    context.read<FeeExemptionComplementationController>().cleanController();

    LoggingService.displayInfo("Controllers limpos");

  }

}