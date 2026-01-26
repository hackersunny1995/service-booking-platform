class ServiceCategory {
  final int id;
  final String name;
  final String description;
  final String? iconUrl;
  final bool isActive;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    required this.isActive,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      isActive: json['isActive'] ?? true,
    );
  }
}
