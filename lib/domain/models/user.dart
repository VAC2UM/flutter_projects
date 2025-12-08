class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime joinDate;
  final int favoriteMoviesCount;
  final int watchlistCount;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.joinDate,
    this.favoriteMoviesCount = 0,
    this.watchlistCount = 0,
  });

  User.create({
    required this.name,
    required this.email,
    this.avatarUrl,
  })  : id = DateTime.now().millisecondsSinceEpoch.toString(),
        joinDate = DateTime.now(),
        favoriteMoviesCount = 0,
        watchlistCount = 0;

  User copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    int? favoriteMoviesCount,
    int? watchlistCount,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinDate: joinDate,
      favoriteMoviesCount: favoriteMoviesCount ?? this.favoriteMoviesCount,
      watchlistCount: watchlistCount ?? this.watchlistCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode ^ avatarUrl.hashCode;
}