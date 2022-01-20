class Advert{

  String id;
  String image_url;
  String title;
  String added_on;
  String updated_on;
  String url;

  Advert({this.id, this.image_url, this.title, this.added_on, this.updated_on, this.url = 'https://flutter.io'});

  factory Advert.fromJson(Map<String, dynamic> item) {
    return Advert(
      id: item['id'],
      image_url: item['image_url'],
      title: item['title'],
      added_on: item['added_on'],
      updated_on: item['updated_on'],
      url: item['advert_url']
    );
  }


}