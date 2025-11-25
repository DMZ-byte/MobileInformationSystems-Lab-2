class Category{
  int id;
  String name;
  String descr;
  String img;

  Category({
    required this.id,
    required this.name,
    required this.descr,
    required this.img,
});
  Map<String, dynamic> toJson() => {

  };
  Category.fromJson(Map<String, dynamic> data):
    id = data['idCategory'],
    name = data['strCategory'],
    img = data['strCategoryThumb'],
    descr = data['strCategoryDescription'];



}