class UserProfile{

  String username;

  String phoneNumber;

  String church;

  UserProfile({this.username, this.phoneNumber, this.church});

  factory UserProfile.fromJson(Map<String, dynamic> item){
    return UserProfile(
    username: item['username'],
    phoneNumber:  item['phone'],
    church: item['church']
    );
  }



}