import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/response/movie_list_response.dart';

class OrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  Future<void> sewaFilm(Result movie, int rentalDays) async {
    try {
      isLoading.value = true;

      final now = DateTime.now();

      final snapshot = await _firestore
          .collection('orders')
          .where('movieId', isEqualTo: movie.id)
          .where('status', isEqualTo: 'disewa')
          .get();

      bool masihAktif = false;
      for (var doc in snapshot.docs) {
        final endDate = (doc['endDate'] as Timestamp).toDate();
        if (now.isBefore(endDate)) {
          masihAktif = true;
          break;
        }
      }

      if (masihAktif) {
        Get.snackbar(
          'Gagal',
          'Lo masih nyewa film ini, tunggu masa sewanya abis',
        );
        return;
      }

      await _firestore.collection('orders').add({
        'movieId': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'tanggalSewa': now,
        'endDate': now.add(Duration(days: rentalDays)),
        'lamaSewa': rentalDays,
        'status': 'disewa',
      });

      Get.snackbar('Berhasil', 'Film berhasil disewa');
    } catch (_) {
      Get.snackbar('Error', 'Anda Masih Menyewa Film Ini');
    } finally {
      isLoading.value = false;
    }
  }
}
