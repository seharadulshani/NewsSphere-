class Source {

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'],
      description:json['description'],
      category:json['category'],
    );
  }
  final String? id;
  final String name;
  final String? description;
  final String? category;

  Source({this.id, required this.name, this.description,this.category});


}
