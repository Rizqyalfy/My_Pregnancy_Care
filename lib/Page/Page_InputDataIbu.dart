import 'package:flutter/material.dart';

class InputDataIbuPage extends StatefulWidget {
  const InputDataIbuPage({super.key});

  @override
  State<InputDataIbuPage> createState() => _InputDataIbuPageState();
}

class _InputDataIbuPageState extends State<InputDataIbuPage> {
  final tekananDarahController = TextEditingController();
  final beratBadanController = TextEditingController();
  final keluhanController = TextEditingController();
  final pergerakanJaninController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Data Ibu"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Masukkan Data Harian/Mingguan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            _inputField(
              "Tekanan Darah (contoh: 110/80)",
              tekananDarahController,
            ),
            _inputField("Berat Badan (kg)", beratBadanController),
            _inputField("Keluhan", keluhanController),
            _inputField("Pergerakan Janin", pergerakanJaninController),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Sementara tampilkan data, nanti bisa disimpan ke backend
                  showDialog(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text("Data Berhasil Disimpan"),
                      content: Text(
                        "Tekanan Darah: ${tekananDarahController.text}\n"
                        "Berat Badan: ${beratBadanController.text}\n"
                        "Keluhan: ${keluhanController.text}\n"
                        "Pergerakan Janin: ${pergerakanJaninController.text}",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  "Simpan Data",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
