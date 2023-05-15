class Episodes {
  List<Episode> items = new List();

  Episodes();

  Episodes.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (final item in jsonList) {
      final episode = new Episode.fromJson(item);
      items.add(episode);
    }
  }
}

class Episode {
  int id;
  int tmdbId;
  int seasonId;
  String name;
  String overview;
  String stillPath;
  double voteAverage;
  int voteCount;
  String airDate;
  String createdAt;
  String updatedAt;

  Episode({
    this.id,
    this.tmdbId,
    this.seasonId,
    this.name,
    this.overview,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
    this.airDate,
    this.createdAt,
    this.updatedAt,
  });

  Episode.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    tmdbId = json["tmdb_id"];
    seasonId = json["season_id"];
    name = json["name"];
    overview = json["overview"];
    stillPath = json["still_path"];
    voteAverage = json["vote_average"] / 1;
    voteCount = json["vote_count"];
    airDate = json["air_date"];
  }

  getStill() {
    if (stillPath == null) {
      return 'http://isabelpaz.com/wp-content/themes/nucleare-pro/images/no-image-box.png';
    } else {
      return stillPath;
    }
  }
}
