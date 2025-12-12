import 'package:json_annotation/json_annotation.dart';

part 'tmdb_actor_dto.g.dart';

@JsonSerializable()
class TmdbActorDto {
  final int id;
  final String name;
  @JsonKey(name: 'profile_path')
  final String? profilePath;
  final String? character;
  @JsonKey(name: 'known_for_department')
  final String? knownForDepartment;

  TmdbActorDto({
    required this.id,
    required this.name,
    this.profilePath,
    this.character,
    this.knownForDepartment,
  });

  factory TmdbActorDto.fromJson(Map<String, dynamic> json) =>
      _$TmdbActorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TmdbActorDtoToJson(this);

  String? get fullProfilePath => profilePath != null
      ? 'https://image.tmdb.org/t/p/w500$profilePath'
      : null;
}

@JsonSerializable()
class TmdbCreditsDto {
  final int id;
  final List<TmdbActorDto> cast;
  final List<TmdbActorDto> crew;

  TmdbCreditsDto({required this.id, required this.cast, required this.crew});

  factory TmdbCreditsDto.fromJson(Map<String, dynamic> json) =>
      _$TmdbCreditsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TmdbCreditsDtoToJson(this);
}

