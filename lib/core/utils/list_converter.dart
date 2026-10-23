class ListConverter{

  ListConverter._();

  static List<T> fromDynamicList<T>(dynamic rawList, T Function(Map<String, dynamic> map) itemParser){

    if(rawList == null || rawList is! List){
      return [];
    }
    
    return rawList
      .whereType<Map<String, dynamic>>()
      .map((item) => itemParser(item))
      .toList();
  }
}