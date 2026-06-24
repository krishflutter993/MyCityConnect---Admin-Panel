class ServiceModel {
  final String id;
  final String name;
  final String category;
  final String phone;
  final String description;
  final String image;

  ServiceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.phone,
    required this.description,
    required this.image,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      phone: json['phone'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'phone': phone,
      'description': description,
      'image': image,
    };
  }
}
