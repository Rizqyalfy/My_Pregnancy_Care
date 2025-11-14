import 'package:flutter/material.dart';

class EdukasiPage extends StatefulWidget {
  const EdukasiPage({super.key});

  @override
  State<EdukasiPage> createState() => _EdukasiPageState();
}

class _EdukasiPageState extends State<EdukasiPage> {
  String selectedTrimester = "Trimester I (0–12 minggu)";

  final List<Map<String, String>> dataEdukasi = [
    {
      "trimester": "Trimester I (0–12 minggu)",
      "fokus": "Adaptasi tubuh & nutrisi awal",
      "materi":
          "- Mual muntah, kelelahan\n- Pola makan sehat\n- Pentingnya asam folat",
      "color": "0xFFD6EAF8", // biru muda
    },
    {
      "trimester": "Trimester II (13–28 minggu)",
      "fokus": "Pertumbuhan janin & kesejahteraan ibu",
      "materi":
          "- Senam hamil\n- Tanda bahaya kehamilan\n- Kesehatan gigi & mulut",
      "color": "0xFFB3E5FC", // biru langit lembut
    },
    {
      "trimester": "Trimester III (29–40 minggu)",
      "fokus": "Persiapan persalinan & menyusui",
      "materi":
          "- Tanda persalinan\n- Perawatan payudara\n- Persiapan mental ibu",
      "color": "0xFFFFF8E1", // krem lembut
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedData = dataEdukasi.firstWhere(
      (e) => e["trimester"] == selectedTrimester,
      orElse: () => dataEdukasi[0],
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(
          10,
        ), // Padding utama dikurangi dari 20 ke 10 untuk ukuran lebih kecil
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Judul halaman
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: Colors.blue[600],
                  size: 24, // Ukuran ikon dikurangi dari 30 ke 24
                ),
                const SizedBox(width: 6), // Jarak dikurangi dari 8 ke 6
                Text(
                  "Edukasi Berdasarkan Trimester",
                  style: TextStyle(
                    fontSize: 18, // Ukuran font dikurangi dari 22 ke 18
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Jarak dikurangi dari 25 ke 20
            // Dropdown untuk memilih trimester
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ), // Padding dikurangi
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  12,
                ), // Radius dikurangi dari 14 ke 12
                border: Border.all(color: Colors.blue.shade200, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedTrimester,
                  dropdownColor: Colors.blue[50],
                  isExpanded: true,
                  items: dataEdukasi.map((e) {
                    return DropdownMenuItem<String>(
                      value: e["trimester"],
                      child: Text(
                        e["trimester"]!,
                        style: const TextStyle(
                          fontSize: 14,
                        ), // Ukuran font dikurangi dari 15 ke 14
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedTrimester = newValue!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20), // Jarak dikurangi dari 30 ke 20
            // Kotak tabel edukasi dengan animasi
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(
                12,
              ), // Padding dikurangi dari 16 ke 12
              decoration: BoxDecoration(
                color: Color(int.parse(selectedData["color"]!)),
                borderRadius: BorderRadius.circular(
                  12,
                ), // Radius dikurangi dari 16 ke 12
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Table(
                border: TableBorder.all(
                  color: Colors.blueGrey.shade200,
                  width: 1.2,
                  borderRadius: BorderRadius.circular(8),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(3),
                },
                children: [
                  // Header tabel
                  TableRow(
                    decoration: BoxDecoration(color: Colors.blue[100]),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(
                          8,
                        ), // Padding dikurangi dari 10 ke 8
                        child: Center(
                          child: Text(
                            "Trimester",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  14, // Ukuran font dikurangi dari 15 ke 14
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                          8,
                        ), // Padding dikurangi dari 10 ke 8
                        child: Center(
                          child: Text(
                            "Fokus Edukasi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  14, // Ukuran font dikurangi dari 15 ke 14
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                          8,
                        ), // Padding dikurangi dari 10 ke 8
                        child: Center(
                          child: Text(
                            "Contoh Materi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  14, // Ukuran font dikurangi dari 15 ke 14
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Isi tabel
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.white),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          8,
                        ), // Padding dikurangi dari 10 ke 8
                        child: Text(
                          selectedData["trimester"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E5C9A),
                            fontSize:
                                14, // Ukuran font ditambahkan untuk konsistensi
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(
                          8,
                        ), // Padding dikurangi dari 10 ke 8
                        child: Text(
                          selectedData["fokus"]!,
                          style: const TextStyle(
                            color: Color(0xFF2E5C9A),
                            height: 1.4,
                            fontSize:
                                14, // Ukuran font ditambahkan untuk konsistensi
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(
                          8,
                        ), // Padding dikurangi dari 10 ke 8
                        child: Text(
                          selectedData["materi"]!,
                          style: const TextStyle(
                            color: Color(0xFF2E5C9A),
                            height: 1.4,
                            fontSize:
                                14, // Ukuran font ditambahkan untuk konsistensi
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
