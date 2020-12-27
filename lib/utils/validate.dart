enum Type {
  normal,
  email,
  password,
  phone,
}

class UtilValidator {
  static const String error_empty = "value_not_empty";
  static const String error_range = "value_not_valid_range";
  static const String error_email = "value_not_valid_email";
  static const String error_phone = "value_not_valid_phone";
  static const String error_password = "value_not_valid_password";
  static const String error_id = "value_not_valid_id";

  static validate({
    String data,
    Type type = Type.normal,
    int min,
    int max,
    bool allowEmpty = false,
  }) {
    switch (type) {
      case Type.email:

        ///Empty
        if (!allowEmpty && data.isEmpty) {
          return error_empty;
        }

        ///Length
        if (min != null ||
            max != null && (data.length < min || data.length > max)) {
          return '$error_range ($min-$max)';
        }

        ///More pattern
        final Pattern _emailPattern =
            r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
        if (!RegExp(_emailPattern).hasMatch(data)) {
          return error_email;
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
