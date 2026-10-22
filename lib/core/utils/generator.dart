class Generator {

  Generator._();

  static String generateImageFileName(String requesterId){

    String shortId = requesterId.length > 5 ? requesterId.substring(0,5).toLowerCase() : '00000';
    int now = DateTime.now().millisecondsSinceEpoch;

    String shortTime = now.toString().substring(0, 5).toUpperCase();

    return "$shortId$shortTime";
  }



}