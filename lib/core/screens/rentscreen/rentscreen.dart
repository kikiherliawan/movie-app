import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RentListScreen extends StatelessWidget {
  const RentListScreen({super.key, required this.firestore});
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Sewa Film')),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('orders') // ambil data dari collection orders
            .orderBy('tanggalSewa', descending: true) // urutkan terbaru dulu
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada film yang disewa'));
          }

          final rentals = snapshot.data!.docs;

          return ListView.builder(
            itemCount: rentals.length,
            itemBuilder: (context, index) {
              final rental = rentals[index];
              return ListTile(
                leading: rental['posterPath'] != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w200${rental['posterPath']}',
                        width: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.movie),
                title: Text(rental['title']),
                subtitle: Text(
                  "Status: ${rental['status']} \nTanggal: ${rental['tanggalSewa'].toDate().toString().split(' ')[0]}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
