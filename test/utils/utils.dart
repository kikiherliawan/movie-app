import 'package:dio/dio.dart';
import 'package:movie_app/core/response/movie_detail_response.dart';

MovieDetailResponse dummyMovieDetailResponse = MovieDetailResponse(
  adult: false,
  backdropPath: '/dummy_backdrop.jpg',
  belongsToCollection: null,
  budget: 1000000,
  genres: [Genre(id: 1, name: 'Action')],
  homepage: 'https://example.com',
  id: 123,
  imdbId: 'tt1234567',
  originalLanguage: 'en',
  originalTitle: 'Dummy Original Title',
  overview: 'This is a dummy overview',
  popularity: 0.0,
  posterPath: '/dummy_poster.jpg',
  productionCompanies: [],
  productionCountries: [],
  releaseDate: DateTime(2023, 10, 1),
  revenue: 5000000,
  runtime: 120,
  spokenLanguages: [],
  status: 'Released',
  tagline: 'A Dummy Tagline',
  title: 'Dummy Movie',
  video: false,
  voteAverage: 7.5,
  voteCount: 200,
);

Map<String, dynamic> dummyMovieDetailJson = {
  'adult': false,
  'backdrop_path': '/dummy_backdrop.jpg',
  'belongs_to_collection': null,
  'budget': 1000000,
  'genres': [
    {'id': 1, 'name': 'Action'},
  ],
  'homepage': 'https://example.com',
  'id': 123,
  'imdb_id': 'tt1234567',
  'original_language': 'en',
  'original_title': 'Dummy Original Title',
  'overview': 'This is a dummy overview',
  'popularity': 0.0,
  'poster_path': '/dummy_poster.jpg',
  'production_companies': [],
  'production_countries': [],
  'release_date': '2023-10-01',
  'revenue': 5000000,
  'runtime': 120,
  'spoken_languages': [],
  'status': 'Released',
  'tagline': 'A Dummy Tagline',
  'title': 'Dummy Movie',
  'video': false,
  'vote_average': 7.5,
  'vote_count': 200,
};

Response<T> createSuccessResponse<T>(T data, String path) {
  return Response(
    data: data,
    statusCode: 200,
    requestOptions: RequestOptions(path: path),
  );
}
