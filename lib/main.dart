//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sistema_abada_capoeira/features/member_validation/data/datasource/membership_validation_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/member_validation/data/repository/membership_validation_repository_impl.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/usecases/approve_membership_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/usecases/get_professor_membership_requests_usecase.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/usecases/reject_membership_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/usecases/request_membership_changes_usecase.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/controllers/membership_validation_controller.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/pages/membership_requests_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final remoteDataSource =
      MembershipValidationRemoteDataSourceImpl();

  final repository =
      MembershipValidationRepositoryImpl(
    remoteDataSource,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => MembershipValidationController(
        getProfessorRequests:
            GetProfessorMembershipRequests(repository),
        approveMembershipRequest:
            ApproveMembershipRequest(repository),
        requestMembershipChanges:
            RequestMembershipChanges(repository),
        rejectMembershipRequest:
            RejectMembershipRequest(repository),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MembershipRequestsPage(
        professorId: 'ProfMarmelo',
      ),
    );
  }
}