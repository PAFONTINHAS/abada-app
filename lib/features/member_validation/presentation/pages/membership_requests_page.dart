import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/controllers/membership_validation_controller.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/membership_request_item_widget.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/membership_requests_empty_state_widget.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/membership_requests_error_state_widget.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/membership_requests_header_widget.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/membership_requests_info_card_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

class MembershipRequestsPage extends StatelessWidget {
  const MembershipRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = context.read<ProfileController>();
    final userId = profileController.userProfile.uid;

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
      body: Consumer<MembershipValidationController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return MembershipRequestsErrorStateWidget(
              errorMessage: controller.errorMessage!,
              onRetry: () {
                controller.loadRequests(userId);
              },
            );
          }

          final requestsLength = controller.requests.length;

          return RefreshIndicator(
            onRefresh: () {
              return controller.loadRequests(userId);
            },
            child: Column(
              children: [
                const MembershipRequestsInfoCardWidget(),

                const SizedBox(height: 24),

                MembershipRequestsHeaderWidget(requestCount: requestsLength),

                const SizedBox(height: 14),

                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    itemCount: controller.requests.length,
                    itemBuilder: (context, index) {
                      if (controller.requests.isEmpty) return const MembershipRequestsEmptyStateWidget();

                      final request = controller.requests[index];

                      return Padding(
                        padding: const EdgeInsetsGeometry.only(bottom: 22),

                        child: MembershipRequestItemWidget(
                          request: request,
                          professorId: userId,
                        ),
                      );
                    },
                  ),
                )
              ],
            )
          );
        },
      ),
    );
  }
}
