class Actor {
  final String id;
  final String name;

  Actor({required this.id, required this.name});

  Actor.create({required this.name})
    : id = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Actor && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
