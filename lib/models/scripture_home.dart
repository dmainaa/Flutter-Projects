class ScriptureHome{
  String id;
  String image_url;
  String title;
  String description;
  String source;
  String added_on;
  String updated_on;

  ScriptureHome({this.id, this.image_url, this.title, this.description, this.source, this.added_on, this.updated_on});

  factory ScriptureHome.fromJson(Map<String, dynamic> item){
    return ScriptureHome(
      id: item['id'],
      image_url: item['image_url'],
      title: item['title'],
      description: item['description'],
      source: item['source'],
      added_on: item['added_on'],
      updated_on: item['updated_on']

    );
  }


}