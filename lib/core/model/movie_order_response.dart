import 'package:movie_app/core/response/movie_list_response.dart';

class RentMovie {
  final int id;
  final String title;
  final String posterPath;
  final DateTime releaseDate;

  RentMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
  });
}

// Converter dari RentMovie ke Result
extension RentMovieMapper on RentMovie {
  Result toResult() {
    return Result(
      adult: false,
      backdropPath: '',
      genreIds: const [],
      id: id,
      originalLanguage: '',
      originalTitle: title,
      overview: '',
      popularity: 0,
      posterPath: posterPath,
      releaseDate: releaseDate,
      title: title,
      video: false,
      voteAverage: 0,
      voteCount: 0,
    );
  }
}
