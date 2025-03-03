

class RegisterDetails{
  RegisterDetails({
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
});
  String firstname;
  String lastname;
  String username;
  String phone;
  String email;
  String password;


  bool validateCredentials() {
    // TODO: will add  validation logic here (e.g., check against a database)
    return email.isNotEmpty && password.isNotEmpty;
  }
}