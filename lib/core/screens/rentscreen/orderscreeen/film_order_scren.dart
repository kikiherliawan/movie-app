import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/controller/order_controller/order_controller.dart';
import 'package:movie_app/core/response/movie_list_response.dart';

class FilmOrderScreen extends StatefulWidget {
  final Result movie; // model film yang udah lo punya

  const FilmOrderScreen({super.key, required this.movie});

  @override
  State<FilmOrderScreen> createState() => _FilmOrderScreenState();
}

class _FilmOrderScreenState extends State<FilmOrderScreen> {
  int rentalDays = 1;
  final int pricePerDay = 5000;
  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sewa ${widget.movie.title}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pilih lama sewa:"),
            DropdownButton<int>(
              value: rentalDays,
              items: List.generate(7, (i) => i + 1)
                  .map(
                    (day) =>
                        DropdownMenuItem(value: day, child: Text("$day hari")),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  rentalDays = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Text("Total Harga: Rp ${pricePerDay * rentalDays}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                orderController.sewaFilm(widget.movie, rentalDays);
              },
              child: const Text("Konfirmasi Sewa"),
            ),
          ],
        ),
      ),
    );
  }
}
