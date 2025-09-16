import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/core/controller/movie_detail_controller/movie_detail_controller.dart';
import 'package:movie_app/core/network/dio_api_client.dart';

import '../utils/utils.dart';
import 'movie_detail_controller_test.mocks.dart';

@GenerateMocks([DioApiClient, Dio])
void main() {
  late MovieDetailController controller;
  late MockDioApiClient mockApiClient;
  late MockDio mockDio;

  setUp(() {
    mockApiClient = MockDioApiClient();
    mockDio = MockDio();

    when(mockApiClient.dio).thenReturn(mockDio);

    controller = MovieDetailController(client: mockApiClient);
  });

  tearDown(() {
    Get.reset();
  });

  group('MovieDetailController Tests', () {
    test('should have correct initial state', () {
      expect(controller.isLoading.value, false);
      expect(controller.movieDetail.value, null);
      expect(controller.errorMessage.value, '');
    });

    test('should fetch movie detail successfully', () async {
      const movieId = 123;
      final response = createSuccessResponse(
        dummyMovieDetailJson,
        '/movie/$movieId',
      );

      when(mockDio.get('/movie/$movieId')).thenAnswer((_) async => response);

      await controller.fetchMovieDetail(movieId);

      expect(controller.isLoading.value, false);
      expect(controller.movieDetail.value, isNotNull);
      expect(controller.movieDetail.value!.title, 'Dummy Movie');
      expect(controller.movieDetail.value!.id, 123);
      expect(controller.errorMessage.value, '');

      verify(mockDio.get('/movie/$movieId')).called(1);
    });

    test('should handle error when API call fails', () async {
      const movieId = 123;
      const errorMessage = 'Network Error';

      when(mockDio.get('/movie/$movieId')).thenThrow(Exception(errorMessage));

      await controller.fetchMovieDetail(movieId);

      expect(controller.isLoading.value, false);
      expect(controller.movieDetail.value, null);
      expect(controller.errorMessage.value, contains(errorMessage));

      verify(mockDio.get('/movie/$movieId')).called(1);
    });

    test('should show loading state during API call', () async {
      const movieId = 123;
      final response = createSuccessResponse(
        dummyMovieDetailJson,
        '/movie/$movieId',
      );

      when(mockDio.get('/movie/$movieId')).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 100));
        return response;
      });

      final future = controller.fetchMovieDetail(movieId);

      await Future.delayed(Duration(milliseconds: 50));
      expect(controller.isLoading.value, true);

      await future;
      expect(controller.isLoading.value, false);
    });

    test('should reset error message after successful call', () async {
      const movieId = 123;

      when(
        mockDio.get('/movie/$movieId'),
      ).thenThrow(Exception('Network Error'));

      await controller.fetchMovieDetail(movieId);
      expect(controller.errorMessage.value, isNotEmpty);

      final response = createSuccessResponse(
        dummyMovieDetailJson,
        '/movie/$movieId',
      );
      when(mockDio.get('/movie/$movieId')).thenAnswer((_) async => response);

      await controller.fetchMovieDetail(movieId);

      expect(controller.errorMessage.value, '');
      expect(controller.movieDetail.value, isNotNull);
    });
  });
}
