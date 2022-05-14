class ModelOfCategory{
  int? id;
  String? title;
  dynamic price;
  String? description;
  String? category;
  String? image;
  ModelOfCategory(this.id,this.title,this.price,this.description,this.category,this.image);
  ModelOfCategory.fromJson(Map<String,dynamic> json){
    this.id=json["id"];
    this.title=json["title"];
    this.price=json["price"];
    this.description=json["description"];
    this.category=json["category"];
    this.image=json["image"];
  }
}