class ArticleContent{
  final String title;
  final String paragraph;

  ArticleContent({this.title, this.paragraph});

  factory ArticleContent.fromJson(Map<String, dynamic> map){
    return ArticleContent(
      title: map['sub_title'],
      paragraph: map['paragraph']
    );
  }


}