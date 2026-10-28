import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/section_detail_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_widgets/revision_phase_info_row_widget.dart';

class RevisionPhaseAditionalProductsWidget extends StatelessWidget {
  const RevisionPhaseAditionalProductsWidget({
    super.key,
    required this.eventValue,
    required this.products,
  });

  final String eventValue;
  final List<EventProductItem> products;

  @override
  Widget build(BuildContext context) {

    bool isFree = eventValue == "0.00";

    return SectionDetailCardWidget(
      title: "Investimento & Produtos",
      icon: Icons.shopping_bag_outlined,
      children: [
        RevisionPhaseInfoRowWidget(
          label: "Valor da Inscrição",
          value: isFree ? 'GRATUITO' : MaskFormatter.convertToReais(eventValue),
        ),
        const Divider(height: 20, color: ColorConstants.borderColor),
        const Text(
          "Produtos Cadastrados",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: ColorConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        if (products.isEmpty)
          const Text(
            "Nenhum produto adicional vinculado.",
            style: TextStyle(
              fontSize: 13,
              color: ColorConstants.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorConstants.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorConstants.borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.product,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: ColorConstants.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.mandatory ? "Obrigatório" : "Opcional",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: product.mandatory
                                  ? ColorConstants.indigoColor
                                  : ColorConstants.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(

                      MaskFormatter.convertToReais(
                        MaskFormatter.convertMoneyDoubleToString(product.price),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: ColorConstants.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
