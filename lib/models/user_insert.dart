class UserInsert{

  String churchName;

  String pin;



  String phoneNumber;

  String username;

  UserInsert({this.churchName, this.pin,  this.phoneNumber, this.username});

  Map<String, dynamic> toJson(){
    return {
        'username': this.username,
        'pin': this.pin,

        'phone': this.phoneNumber,

        'church': this.churchName,
    };
  }

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['username'] = username;
    map['pin'] = pin;
    map['church'] = churchName;
    map['phone'] = phoneNumber;

    return map;
  }


}