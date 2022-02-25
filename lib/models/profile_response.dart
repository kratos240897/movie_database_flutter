class ProfileResponse {
  ProfileResponse({
    required this.birthday,
    required this.knownForDepartment,
     this.deathday,
    required this.id,
    required this.name,
    required this.alsoKnownAs,
    required this.gender,
    required this.biography,
    required this.popularity,
    required this.placeOfBirth,
    required this.profilePath,
    required this.adult,
    required this.imdbId,
     this.homepage,
  });
  late final String birthday;
  late final String knownForDepartment;
  late final String? deathday;
  late final int id;
  late final String name;
  late final List<String> alsoKnownAs;
  late final int gender;
  late final String biography;
  late final double popularity;
  late final String placeOfBirth;
  late final String profilePath;
  late final bool adult;
  late final String imdbId;
  late final String? homepage;
  
  ProfileResponse.fromJson(Map<String, dynamic> json){
    birthday = json['birthday'];
    knownForDepartment = json['known_for_department'];
    deathday = json['deathday'];
    id = json['id'];
    name = json['name'];
    alsoKnownAs = List.castFrom<dynamic, String>(json['also_known_as']);
    gender = json['gender'];
    biography = json['biography'];
    popularity = json['popularity'];
    placeOfBirth = json['place_of_birth'];
    profilePath = json['profile_path'];
    adult = json['adult'];
    imdbId = json['imdb_id'];
    homepage = json['homepage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['birthday'] = birthday;
    _data['known_for_department'] = knownForDepartment;
    _data['deathday'] = deathday;
    _data['id'] = id;
    _data['name'] = name;
    _data['also_known_as'] = alsoKnownAs;
    _data['gender'] = gender;
    _data['biography'] = biography;
    _data['popularity'] = popularity;
    _data['place_of_birth'] = placeOfBirth;
    _data['profile_path'] = profilePath;
    _data['adult'] = adult;
    _data['imdb_id'] = imdbId;
    _data['homepage'] = homepage;
    return _data;
  }
}