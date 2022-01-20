class User{
  String phone;
  String pin;

  User({this.phone, this.pin});

  Map<String, dynamic> toJson(){
    return {
      'phone': phone,
      'pin': pin
    };
  }


}