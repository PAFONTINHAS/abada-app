
import 'dart:math';

class Generator {

  Generator._();

  static String generateImageFileName(String requesterId){

    String shortId = requesterId.length > 5 ? requesterId.substring(0,5).toLowerCase() : '00000';
    int now = DateTime.now().millisecondsSinceEpoch;

    String shortTime = now.toString().substring(0, 5).toUpperCase();

    return "$shortId$shortTime";
  }

  static String generateVerificationCode(String userId, String eventId){
    final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36);

    final randomHex = Random().nextInt(0XFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();

    String shortUID = userId.substring(0, 5).toUpperCase();
    String shortEventId = eventId.substring(0, 5).toUpperCase();

    return "ABD-$shortUID-$shortEventId-${timestamp.substring(timestamp.length - 4).toUpperCase()}-$randomHex";
  
  }



}