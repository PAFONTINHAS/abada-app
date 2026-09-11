import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class UserEventSubscriptionCardWidget extends StatelessWidget {
  const UserEventSubscriptionCardWidget({
    super.key,
    required this.eventName,
    required this.subscriptionConfirmed,
  });

  final String eventName;
  final bool subscriptionConfirmed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 3, horizontal: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: ColorConstants.whiteColor,
                  border: BoxBorder.all(color: Colors.black, width: 0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [

                    if(subscriptionConfirmed) const Icon(Icons.task_alt, color: Colors.green,),

                    if(!subscriptionConfirmed) const Icon(Icons.schedule, color: Colors.amber),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column( 
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          if(subscriptionConfirmed)  const Text("Inscrição confirmada", style: TextStyle(fontSize: 13),),
                          if(!subscriptionConfirmed) const Text("Inscrição pendente de pagamento", style: TextStyle(fontSize: 13),),
                        ],
                      ),
                    ),

                    const Icon(Icons.chevron_right, size: 35),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
