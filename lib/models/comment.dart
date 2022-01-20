class Comment{
  String article_id;
  String commment;

  Comment({this.article_id, this.commment});

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = new Map();

    map['article_id'] = this.article_id;
    map['comment'] = this.commment;

    return map;
  }
}