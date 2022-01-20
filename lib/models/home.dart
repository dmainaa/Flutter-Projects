class Home{
  String id;
  String image_url;
  String title;
  String category;
  String description;
  String added_on;
  String updated_on;
  List<String>  comments;

  Home({this.id, this.image_url, this.title, this.category, this.description, this.added_on, this.updated_on, this.comments});

  Map<String , dynamic> toJson(){
    return {
        'id': this.id,
        'image_url': this.image_url,
        'title': this.title,
        'category': this.category,
        'description': this.description,
        'added_on': this.added_on,
        'updated_on': this.updated_on
    };
  }

  factory Home.fromJson(Map<String, dynamic> item){
      return Home(
        id: item['id'],
        image_url: item['image_url'],
        title: item['title'],
        category: item['category'],
        description: item['description'],
        added_on: item['added_on'],
        updated_on: item['updated_on']
      );
  }

}