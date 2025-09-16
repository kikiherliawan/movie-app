import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/controller/movie_section_controller/movie_section_controller.dart';
import 'package:movie_app/core/services/movie_service.dart';

import '../utils/utils.dart';

class MockMovieService extends Mock implements MovieService {}

void main() {
  late MovieSectionController controller;
  late MockMovieService mockMovieService;

  setUp(() {
    mockMovieService = MockMovieService();
    controller = MovieSectionController(movieService: mockMovieService);
  });

  test('loadHomeData harus mengisi list movie dari service', () async {
    when(
      () => mockMovieService.fetchTrending(),
    ).thenAnswer((_) async => dummyMovieListResponse);

    when(
      () => mockMovieService.fetchMovies('popular', 1),
    ).thenAnswer((_) async => dummyMovieListResponse);

    when(
      () => mockMovieService.fetchMovies('upcoming', 1),
    ).thenAnswer((_) async => dummyMovieListResponse);

    when(
      () => mockMovieService.fetchKoreanDrama(),
    ).thenAnswer((_) async => dummyMovieListResponse);

    await controller.loadHomeData();

    expect(controller.trendingMovies.length, 1);
    expect(controller.popularMovies.first.title, 'Dummy Title');
    expect(controller.upcomingMovies.first.id, 1);
    expect(controller.koreanDramas.first.originalTitle, 'Dummy Movie');

    expect(controller.isLoading.value, false);

    verify(() => mockMovieService.fetchTrending()).called(1);
    verify(() => mockMovieService.fetchMovies('popular', 1)).called(1);
    verify(() => mockMovieService.fetchMovies('upcoming', 1)).called(1);
    verify(() => mockMovieService.fetchKoreanDrama()).called(1);
  });
}
