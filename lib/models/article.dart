class Article{
  String id;
  String image_url;
  String title;
  String category;
  String article_url;
  int cost;
  String access_type;

  Article({this.id, this.image_url, this.title, this.category, this.article_url, this.cost, this.access_type='free'});


  factory Article.fromJson(Map<String, dynamic> map){
    return Article(
      id: map['id'],
      image_url: map['image_url'],
      title: map['title'],
      category: map['category'],
      article_url: map['article_url'],
      cost: int.parse(map['cost']),
      access_type: map['cost'] == '0'? 'free': 'paid'
    );
  }
}