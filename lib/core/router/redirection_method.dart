// ignore_for_file: constant_identifier_names

enum RedirectionMethod{
  PUSH,
  PUSH_REPLACEMENT
}

extension RedirectionMethodExtension on RedirectionMethod{


  bool get isPushMethod => this == RedirectionMethod.PUSH;
  bool get isPushReplacementeMethod => this == RedirectionMethod.PUSH_REPLACEMENT;


}