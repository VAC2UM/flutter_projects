class Actor {
  final String id;
  final String name;
  final String? imageUrl;

  Actor({required this.id, required this.name, this.imageUrl});

  Actor.create({required this.name, this.imageUrl})
      : id = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Actor &&
        other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ imageUrl.hashCode;
}