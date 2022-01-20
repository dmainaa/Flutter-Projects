class Church{
  final String id;
  final String added_on;
  final String name;

  Church({this.id, this.added_on, this.name});

  factory Church.fromJson(Map<String, dynamic> map){
    return Church(
      id: map['id'],
      name: map['name'],
      added_on: map['added_on']
    );
  }

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();

    if(id != null){
      map['id'] = id;
    }


    map['added_on'] = added_on;
    map['name'] = name;


    return map;
  }

}