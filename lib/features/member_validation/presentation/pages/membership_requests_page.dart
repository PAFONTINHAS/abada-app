import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/membership_validation_controller.dart';
import '../widgets/membership_requests_body_widget.dart';

class MembershipRequestsPage extends StatefulWidget {
  final String professorId;

  const MembershipRequestsPage({
    super.key,
    required this.professorId,
  });

  @override
  State<MembershipRequestsPage> createState() =>
      _MembershipRequestsPageState();
}

class _MembershipRequestsPageState
    extends State<MembershipRequestsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<MembershipValidationController>()
          .loadRequests(widget.professorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          'Todas as solicitações de entrada',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF252334),
          ),
        ),
      ),
      body: MembershipRequestsBodyWidget(
        professorId: widget.professorId,
      ),
    );
  }
}