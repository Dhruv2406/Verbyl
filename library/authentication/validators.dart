RegExp regExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
RegExp regExpMobile = RegExp("[6789][0-9]{9}");

class PhoneValidator {
  static String? validate(String value) {
    if(value.isEmpty) {
      return "Phone number can't be empty!";
    }
    if(!regExpMobile.hasMatch(value)){
      return "Please enter a valid Phone number";
    }
    if(value.length != 10){
      return "Please enter a valid 10-digit Phone number";
    }
    return null;
  }
}

class EmailValidator {
  static String? validate(String value) {
    if(value.isEmpty) {
      return "Email-id can't be empty!";
    }
    if(!regExp.hasMatch(value)){
      return "Please enter a valid Email-id";
    }
    return null;
  }
}

class NameValidator {
  static String? validate(String value) {
    if(value.isEmpty) {
      return "Name can't be empty!";
    }
    if(value.length < 3){
      return "Please enter a valid Name";
    }
    return null;
  }
}

class PasswordValidator {
  static String? validate(String value) {
    if(value.isEmpty) {
      return "Password can't be empty!";
    }
    if(value.length < 8){
      return "Please enter a valid password";
    }
    return null;
  }
}


