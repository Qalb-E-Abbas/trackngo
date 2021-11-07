class FormValidator {
  static FormValidator _instance;

  factory FormValidator() => _instance ??= new FormValidator._();

  FormValidator._();

  String validateName(String value) {
    if (value.isEmpty) {
      return "Imię jest wymagane";
    }
    return null;
  }

  String validateKwota(String value) {
    if (value.isEmpty) {
      return "Kwota is Required";
    }
    return null;
  }

  String validateLicence(String value) {
    if (value.isEmpty) {
      return "LicensePlate is Required";
    }
    return null;
  }

  String validatedesc(String value) {
    if (value.isEmpty) {
      return "Opis is Required";
    }
    return null;
  }

  String validateHours(String value) {
    if (double.parse(value) > 8) {
      return "Hours can not be more than 8";
    }
    return null;
  }

  String validateMessage(String value) {
    if (value.isEmpty) {
      return "Message is Required";
    }
    return null;
  }

  String validateaccept(String value) {
    if (value.isEmpty) {
      return "The accepted must be accepted.";
    }
    return null;
  }

  String validatetitle(String value) {
    if (value.isEmpty) {
      return "Tytuł jest wymagany";
    }
    return null;
  }

  String validatedescription(String value) {
    if (value.isEmpty) {
      return "Opis jest wymagany";
    }
    return null;
  }

  String validatelocation(String value) {
    if (value.isEmpty) {
      return "Lokalizacja jest wymagana";
    }
    return null;
  }

  String validatePhone(String value) {
    if (value.isEmpty) {
      return "Numer telefonu jest wymagany";
    }
    return null;
  }

  String validateCard(String value) {
//    String patttern patttern= r'(^(?=.*[0-9])$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Ticket Number is Required";
    }
    return null;
  }

  String validateVendor(String value) {
    if (value.isEmpty) {
      return "Vendor Id is Required";
    }
    return null;
  }

  String validatePassword(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Hasło is jest wymagane";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validateCPassword(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Powtórz hasło jest wymagane";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validateOPassword(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Obecne hasło jest wymagane";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validateNPassword(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Nowe hasło jest wymagane";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validateRPassword(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Powtórz nowe hasło jest wymagane";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "E-mail jest wymagany";
    } else if (!regExp.hasMatch(value)) {
      return "Błędny E-mail";
    } else {
      return null;
    }
  }

  String validateTelephone(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Telefon jest wymagany";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validateUwagi(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Uwagi is required";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validateGodzina(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Godzina dostawy is required";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validatepincode(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Kod pocztowy jest wymagany";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validateaddress(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Ulica i numer lokalu jest wymagany";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validatecity(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Miasto jest wymagane";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validateapartment(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Numer mieszkania jest wymagany";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validatestreet(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Ulica jest wymagana";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validatecomment(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Uwagi są wymagane";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }

  String validatetown(String value) {
//    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
//    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Miejscowość jest wymagana";
    }
//    else if (value.length < 8) {
//      return "Password must minimum eight characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "Password at least one uppercase letter, one lowercase letter and one number";
//    }
    return null;
  }
}
