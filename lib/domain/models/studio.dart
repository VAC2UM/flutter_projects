class Studio {
  final String id;
  final String name;
  final String? logoUrl;
  final int? foundedYear;
  final String? country;
  final String? description;

  Studio({
    required this.id,
    required this.name,
    this.logoUrl,
    this.foundedYear,
    this.country,
    this.description,
  });

  Studio.create({
    required this.name,
    this.logoUrl,
    this.foundedYear,
    this.country,
    this.description,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Studio &&
        other.id == id &&
        other.name == name &&
        other.logoUrl == logoUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ logoUrl.hashCode;
}