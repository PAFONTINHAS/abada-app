import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/membership_validation_controller.dart';
import '../widgets/membership_request_card.dart';
import '../widgets/reject_request_dialog.dart';
import '../widgets/request_changes_dialog.dart';
import '../widgets/request_result_dialog.dart';

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
    final controller =
        context.watch<MembershipValidationController>();

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
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(
    MembershipValidationController controller,
  ) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.errorMessage != null) {
      return _buildErrorState(controller);
    }

    return RefreshIndicator(
      onRefresh: () {
        return controller.loadRequests(
          widget.professorId,
        );
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          32,
        ),
        children: [
          _buildInfoCard(),

          const SizedBox(height: 24),

          _buildPendingTitle(
            controller.requests.length,
          ),

          const SizedBox(height: 14),

          if (controller.requests.isEmpty)
            _buildEmptyState()
          else
            ...controller.requests.map(
              (request) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: MembershipRequestCard(
                    request: request,

                    onApprove: () async {
                      await controller.approve(
                        request.id,
                        widget.professorId,
                      );

                      if (!mounted) {
                        return;
                      }

                      await showDialog(
                        context: context,
                        builder: (_) {
                          return const RequestResultDialog(
                            type:
                                RequestResultType.approved,
                          );
                        },
                      );
                    },

                    onRequestChanges: () async {
                      final confirmed =
                          await showDialog<bool>(
                        context: context,
                        builder: (_) {
                          return RequestChangesDialog(
                            onConfirm: (reason) async {
                              await controller
                                  .requestChanges(
                                request.id,
                                reason,
                                widget.professorId,
                              );
                            },
                          );
                        },
                      );

                      if (confirmed != true ||
                          !mounted) {
                        return;
                      }

                      await showDialog(
                        context: context,
                        builder: (_) {
                          return const RequestResultDialog(
                            type: RequestResultType
                                .changesRequested,
                          );
                        },
                      );
                    },

                    onReject: () async {
                      final confirmed =
                          await showDialog<bool>(
                        context: context,
                        builder: (_) {
                          return RejectRequestDialog(
                            onConfirm: (reason) async {
                              await controller.reject(
                                request.id,
                                reason,
                                widget.professorId,
                              );
                            },
                          );
                        },
                      );

                      if (confirmed != true ||
                          !mounted) {
                        return;
                      }

                      await showDialog(
                        context: context,
                        builder: (_) {
                          return const RequestResultDialog(
                            type:
                                RequestResultType.rejected,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 22,
            color: Color(0xFF252334),
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sobre as solicitações',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF252334),
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  'Aprove, solicite correções ou recuse as solicitações de entrada na sua turma. O aluno será notificado sobre sua decisão.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF6B6877),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTitle(
    int requestCount,
  ) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Solicitações pendentes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF252334),
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            requestCount.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5B3FD0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 48,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 12),

          const Text(
            'Nenhuma solicitação pendente.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B6877),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    MembershipValidationController controller,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),

            const SizedBox(height: 12),

            const Text(
              'Não foi possível carregar as solicitações.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              controller.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 16),

            FilledButton(
              onPressed: () {
                controller.loadRequests(
                  widget.professorId,
                );
              },
              child: const Text(
                'Tentar novamente',
              ),
            ),
          ],
        ),
      ),
    );
  }
}