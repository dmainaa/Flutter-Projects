class Scripture{
  String id;
  String title;
  String description;
  String source;

  Scripture({this.id, this.title, this.description, this.source});


  factory Scripture.fromJson(Map<String, dynamic> map){
    return Scripture(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      source: map['source']
    );
  }
}