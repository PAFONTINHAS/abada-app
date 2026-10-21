import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/inputs/file_picker_widget.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_address_field_widget.dart';

class EventFormFirstPhaseWidget extends StatelessWidget {
  const EventFormFirstPhaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = context.read<EventFormController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          title: "Informações Básicas",
          icon: Icons.info_outline_rounded,
          children: [
            CustomTextInput(
              label: "Nome do Evento",
              controller: formController.eventName,
              hintText: "Batizado e Troca de Cordas 2026",
            ),
            const SizedBox(height: 16),
            CustomTextInput(
              label: "Descrição do Evento",
              controller: formController.eventDescription,
              hintText: "Descreva o que ocorrerá no evento...",
              maxLines: 3,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: "Localização",
          icon: Icons.location_on_outlined,
          children: [
            EventFormPageAddressFieldWidget(
              formController: formController,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: "Data e Horário",
          icon: Icons.calendar_today_rounded,
          children: [
            Row(
              children: [
                Expanded(
                  child: _DatePickerTile(
                    label: "Data de Início",
                    selector: Selector<EventFormController, DateTime?>(
                      selector: (_, controller) => controller.eventInitDate,
                      builder: (context, date, _) => Text(
                        date != null
                            ? DateController.formatDDMMYYYYHM(date)
                            : "Selecione",
                        style: TextStyle(
                          fontSize: 14,
                          color: date != null
                              ? ColorConstants.textPrimary
                              : ColorConstants.textSecondary,
                          fontWeight: date != null ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                    onTap: () async {
                      await DateController.selectDateAndHour(context, (selectedDate, selectedTime) {
                        formController.setEventInitDate(selectedDate, selectedTime);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DatePickerTile(
                    label: "Data Final",
                    selector: Selector<EventFormController, DateTime?>(
                      selector: (_, controller) => controller.eventEndingDate,
                      builder: (context, date, _) => Text(
                        date != null
                            ? DateController.formatDDMMYYYYHM(date)
                            : "Selecione",
                        style: TextStyle(
                          fontSize: 14,
                          color: date != null
                              ? ColorConstants.textPrimary
                              : ColorConstants.textSecondary,
                          fontWeight: date != null ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                    onTap: () async {
                      await DateController.selectDateAndHour(context,
                          (selectedDate, selectedTime) {
                        formController.setEventEndingDate(selectedDate, selectedTime);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: "Mídia do Evento",
          icon: Icons.image_outlined,
          children: [
            FilePickerWidget(
              label: 'Imagem do Evento (opcional)',
              hintText: 'Selecione a imagem de capa',
              fileType: FileType.image,
              imageOnly: true,
              showPreview: true,
              currentFile: formController.eventImage,
              onFileSelected: (file) {
                formController.setEventImage(file);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorConstants.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: ColorConstants.indigoColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textPrimary,
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: ColorConstants.borderColor),
          ...children,
        ],
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String label;
  final Widget selector;
  final VoidCallback onTap;

  const _DatePickerTile({
    required this.label,
    required this.selector,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: ColorConstants.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorConstants.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: ColorConstants.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: selector),
                const Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: ColorConstants.indigoColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}