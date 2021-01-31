enum TypeValidate {
  normal,
  email,
  password,
  phone,
  name,
  visaExp,
  mastercardExp,
  jcbExp,
  discoverExp
}

class UtilValidator {
  static const String error_empty = "value_not_empty";
  static const String error_range = "value_not_valid_range";
  static const String error_email = "value_not_valid_email";
  static const String error_phone = "value_not_valid_phone";
  static const String error_password = "value_not_valid_password";
  static const String error_id = "value_not_valid_id";
  static const String error_name = "value_not_valid_name";

  // PATTERN REGEXP
  static Pattern _visaExp = r'^4[0-9]{6,}$';
  static Pattern _mastercardExp =
      r'(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}';
  static Pattern _jcbExp = r'(^3[0-9]{15}$)|(^(2131|1800)[0-9]{11}$)';
  static Pattern _discoverExp = r'^6011-?\d{4}-?\d{4}-?\d{4}$';
  static Pattern _emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
  static Pattern _phonePattern = r"^(^62\s?|^08)(\d{5,13})$";
  static Pattern _namePattern = r"^([a-zA-Z `'.]*)$";

  static validate({
    String data,
    TypeValidate type = TypeValidate.normal,
    int min,
    int max,
    bool allowEmpty = false,
  }) {
    ///Empty
    if (!allowEmpty && data == null) {
      return error_empty;
    }

    ///Length
    if (min != null ||
        max != null && (data.length < min || data.length > max)) {
      return '$error_range ($min-$max)';
    }

    switch (type) {
      case TypeValidate.email:
        if (!RegExp(_emailPattern).hasMatch(data)) {
          return error_email;
        }
        return null;

      case TypeValidate.phone:
        if (!RegExp(_phonePattern).hasMatch(data)) {
          return error_phone;
        }
        return null;

      case TypeValidate.name:
        if (!RegExp(_namePattern).hasMatch(data)) {
          return error_name;
        }
        return null;

      case TypeValidate.visaExp:
        if (!RegExp(_visaExp).hasMatch(data)) {
          return error_name;
        }
        return null;

      case TypeValidate.discoverExp:
        if (!RegExp(_discoverExp).hasMatch(data)) {
          return error_name;
        }
        return null;

      case TypeValidate.jcbExp:
        if (!RegExp(_jcbExp).hasMatch(data)) {
          return error_name;
        }
        return null;
      case TypeValidate.mastercardExp:
        if (!RegExp(_mastercardExp).hasMatch(data)) {
          return error_name;
        }
        return null;

      default:
        if (!allowEmpty && data.isEmpty) {
          return error_empty;
        }
        if (min != null ||
            max != null && (data.length < min || data.length > max)) {
          return '$error_range ($min-$max)';
        }
        return null;
    }
  }

  ///Singleton factory
  static final UtilValidator _instance = UtilValidator._internal();

  factory UtilValidator() {
    return _instance;
  }

  UtilValidator._internal();
}
