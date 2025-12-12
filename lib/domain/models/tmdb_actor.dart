class TmdbActor {
  final int id;
  final String name;
  final String? profilePath;
  final String? character;
  final String? knownForDepartment;

  const TmdbActor({
    required this.id,
    required this.name,
    this.profilePath,
    this.character,
    this.knownForDepartment,
  });
}

