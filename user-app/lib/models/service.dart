class ServiceModel {
  final int id;
  final String name;
  final String description;
  final double basePrice;
  final int durationMinutes;
  final String? imageUrl;
  final bool isActive;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.durationMinutes,
    this.imageUrl,
    required this.isActive,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      basePrice: (json['basePrice'] as num).toDouble(),
      durationMinutes: json['durationMinutes'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? true,
    );
  }
}
