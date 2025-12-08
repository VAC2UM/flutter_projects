class Director {
  final String id;
  final String name;
  final String? imageUrl;
  final int? birthYear;
  final String? country;
  final String? biography;

  Director({
    required this.id,
    required this.name,
    this.imageUrl,
    this.birthYear,
    this.country,
    this.biography,
  });

  Director.create({
    required this.name,
    this.imageUrl,
    this.birthYear,
    this.country,
    this.biography,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Director &&
        other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ imageUrl.hashCode;
}