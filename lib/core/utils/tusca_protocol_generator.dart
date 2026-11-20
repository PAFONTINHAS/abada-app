import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';

class TuscaProtocolGenerator {

  static String generateProtocolId(UserProfileEntity userProfile){

    final year = DateTime.now().year;
    final shortId = generateShortId(userProfile);

    return 'TUSCA-$year-$shortId';
  }

  static String generateShortId(UserProfileEntity userProfile){
    
    return userProfile.uid.length > 5 ? userProfile.uid.substring(0,5).toUpperCase() : '00000';
  }

  
}

