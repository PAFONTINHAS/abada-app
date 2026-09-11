import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/membership_validation_controller.dart';
import 'membership_request_item_widget.dart';
import 'membership_requests_empty_state_widget.dart';
import 'membership_requests_error_state_widget.dart';
import 'membership_requests_header_widget.dart';
import 'membership_requests_info_card_widget.dart';

class MembershipRequestsBodyWidget extends StatelessWidget {
  final String professorId;

  const MembershipRequestsBodyWidget({
    super.key,
    required this.professorId,
  });

 @override
Widget build(BuildContext context) {
  return Consumer<MembershipValidationController>(
    builder: (context, controller, child) {
      if (controller.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.errorMessage != null) {
        return MembershipRequestsErrorStateWidget(
          errorMessage: controller.errorMessage!,
          onRetry: () {
            controller.loadRequests(professorId);
          },
        );
      }

      return RefreshIndicator(
        onRefresh: () {
          return controller.loadRequests(professorId);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            const MembershipRequestsInfoCardWidget(),
            const SizedBox(height: 24),
            MembershipRequestsHeaderWidget(
              requestCount: controller.requests.length,
            ),
            const SizedBox(height: 14),
            if (controller.requests.isEmpty)
              const MembershipRequestsEmptyStateWidget()
            else
              ...controller.requests.map(
                (request) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MembershipRequestItemWidget(
                    request: request,
                    professorId: professorId,
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}
}