// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_actor_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TmdbActorDto _$TmdbActorDtoFromJson(Map<String, dynamic> json) => TmdbActorDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  profilePath: json['profile_path'] as String?,
  character: json['character'] as String?,
  knownForDepartment: json['known_for_department'] as String?,
);

Map<String, dynamic> _$TmdbActorDtoToJson(TmdbActorDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_path': instance.profilePath,
      'character': instance.character,
      'known_for_department': instance.knownForDepartment,
    };

TmdbCreditsDto _$TmdbCreditsDtoFromJson(Map<String, dynamic> json) =>
    TmdbCreditsDto(
      id: (json['id'] as num).toInt(),
      cast: (json['cast'] as List<dynamic>)
          .map((e) => TmdbActorDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      crew: (json['crew'] as List<dynamic>)
          .map((e) => TmdbActorDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TmdbCreditsDtoToJson(TmdbCreditsDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cast': instance.cast,
      'crew': instance.crew,
    };
