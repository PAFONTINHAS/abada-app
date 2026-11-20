import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';

class EventSubscriptionViewEntity {

  const EventSubscriptionViewEntity({
    this.isMinor = false,
    required this.userName,
    required this.userNickname,
    required this.verificationCode,
    required this.subscription
  });

  final bool isMinor;
  final String userName;
  final String userNickname;
  final String verificationCode;
  final EventSubscriptionEntity subscription;
  
}