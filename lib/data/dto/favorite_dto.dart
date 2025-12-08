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

  Favorite toEntity() {
    return Favorite(id: id, title: title, imageUrl: imageUrl);
  }
}
