import '../../domain/models/favorite.dart';

class FavoriteDto extends Favorite {
  FavoriteDto({required super.id, required super.title, super.imageUrl});

  factory FavoriteDto.fromEntity(Favorite favorite) {
    return FavoriteDto(
      id: favorite.id,
      title: favorite.title,
      imageUrl: favorite.imageUrl,
    );
  }

  factory FavoriteDto.fromMap(Map<String, dynamic> map) {
    return FavoriteDto(
      id: map['id'] as String,
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'imageUrl': imageUrl};
  }

  Favorite toEntity() {
    return Favorite(id: id, title: title, imageUrl: imageUrl);
  }
}
