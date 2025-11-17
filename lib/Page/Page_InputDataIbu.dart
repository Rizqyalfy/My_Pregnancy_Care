import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class InputDataIbuPage extends StatefulWidget {
  const InputDataIbuPage({super.key});

  @override
  State<InputDataIbuPage> createState() => _InputDataIbuPageState();
}

class _InputDataIbuPageState extends State<InputDataIbuPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk input fields
  final tekananDarahController = TextEditingController();
  final beratBadanController = TextEditingController();
  final keluhanController = TextEditingController();
  final pergerakanJaninController = TextEditingController();
  final hasilLabController = TextEditingController();
  final hasilUSGController = TextEditingController();
  final catatanANCController = TextEditingController();

  // Variabel untuk tanggal dan dropdown
  DateTime _selectedDate = DateTime.now();
  String _selectedKunjungan = 'Kunjungan Rutin';
  String _selectedImunisasiTT = 'Belum';
  String _selectedTrimester = 'Trimester I';

  // Variabel untuk foto USG
  File? _fotoUSG;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Data Ibu"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Informasi
              _buildHeaderSection(),
              const SizedBox(height: 20),

              // Tanggal Pemeriksaan
              _buildDateSection(),
              const SizedBox(height: 20),

              // Data Harian/Mingguan
              _buildDataHarianSection(),
              const SizedBox(height: 20),

              // Catatan Pemeriksaan ANC
              _buildANCSection(),
              const SizedBox(height: 20),

              // Tombol Simpan
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
                  onPressed: _saveData,
                  child: const Text(
                    "Simpan Data",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Lengkapi data kesehatan Anda untuk memantau perkembangan kehamilan',
            style: TextStyle(color: Colors.blueGrey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal Pemeriksaan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.blue),
            title: Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: const TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: _selectDate,
          ),
        ),
      ],
    );
  }

  Widget _buildDataHarianSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.monitor_heart, color: Colors.green[700]),
                const SizedBox(width: 8),
                const Text(
                  "Data Harian/Mingguan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _inputField(
              "Tekanan Darah (mmHg)",
              tekananDarahController,
              Icons.favorite,
              isRequired: true,
              hintText: "Contoh: 120/80",
            ),
            _inputField(
              "Berat Badan (kg)",
              beratBadanController,
              Icons.monitor_weight,
              isRequired: true,
              keyboardType: TextInputType.number,
            ),
            _inputField(
              "Keluhan",
              keluhanController,
              Icons.health_and_safety,
              maxLines: 3,
              hintText: "Tuliskan keluhan yang dirasakan",
            ),
            _inputField(
              "Pergerakan Janin",
              pergerakanJaninController,
              Icons.child_care,
              maxLines: 2,
              hintText: "Deskripsi pergerakan janin",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildANCSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services, color: Colors.purple[700]),
                const SizedBox(width: 8),
                const Text(
                  "Catatan Pemeriksaan ANC",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Jenis Kunjungan
            _buildDropdownField("Jenis Kunjungan", _selectedKunjungan, [
              'Kunjungan Rutin',
              'Kunjungan Darurat',
              'Kontrol Hasil Lab',
              'USG',
            ], Icons.assignment),
            const SizedBox(height: 12),

            // Trimester
            _buildDropdownField("Trimester", _selectedTrimester, [
              'Trimester I',
              'Trimester II',
              'Trimester III',
            ], Icons.timeline),
            const SizedBox(height: 12),

            // Hasil Lab
            _inputField(
              "Hasil Lab",
              hasilLabController,
              Icons.science,
              maxLines: 2,
              hintText: "Hasil pemeriksaan laboratorium",
            ),
            const SizedBox(height: 12),

            // Hasil USG dengan Foto
            _buildUSGSection(),
            const SizedBox(height: 12),

            // Imunisasi TT
            _buildDropdownField("Imunisasi TT", _selectedImunisasiTT, [
              'Belum',
              'TT1',
              'TT2',
              'TT3',
              'TT4',
              'TT5',
              'Lengkap',
            ], Icons.vaccines),
            const SizedBox(height: 12),

            // Catatan Tambahan ANC
            _inputField(
              "Catatan Tambahan ANC",
              catatanANCController,
              Icons.note_add,
              maxLines: 4,
              hintText: "Catatan lain dari dokter/bidan",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUSGSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hasil USG",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        // Input Text untuk Hasil USG
        TextFormField(
          controller: hasilUSGController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: "Deskripsi hasil USG",
            prefixIcon: const Icon(Icons.description, color: Colors.blueAccent),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),

        // Upload Foto USG
        _buildFotoUSGSection(),
      ],
    );
  }

  Widget _buildFotoUSGSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Foto USG",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        // Container untuk foto
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[50],
          ),
          child: _fotoUSG == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.photo_camera,
                      size: 50,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Belum ada foto USG",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _pilihFotoUSG,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text("Upload Foto USG"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    // Tampilkan foto
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _fotoUSG!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Tombol hapus foto
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 16,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _fotoUSG = null;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),

        // Tombol pilih foto (jika sudah ada foto, tombol tetap muncul di bawah)
        if (_fotoUSG != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pilihFotoUSG,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Ganti Foto"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _ambilFotoDariKamera,
                  icon: const Icon(Icons.photo_camera),
                  label: const Text("Ambil Foto"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ] else ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pilihFotoUSG,
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Dari Galeri"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _ambilFotoDariKamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Kamera"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _pilihFotoUSG() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _fotoUSG = File(image.path);
      });
    }
  }

  Future<void> _ambilFotoDariKamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _fotoUSG = File(image.path);
      });
    }
  }

  Widget _inputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String hintText = "",
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isRequired)
                const Text(" *", style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(icon, color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (isRequired && (value == null || value.isEmpty)) {
                return '$label wajib diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(icon, color: Colors.blueAccent),
            title: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                      if (label == "Jenis Kunjungan") {
                        _selectedKunjungan = newValue;
                      } else if (label == "Imunisasi TT") {
                        _selectedImunisasiTT = newValue;
                      } else if (label == "Trimester") {
                        _selectedTrimester = newValue;
                      }
                    }
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // Tampilkan dialog konfirmasi
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Data Berhasil Disimpan"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSummaryItem(
                  "Tanggal Pemeriksaan",
                  "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                ),
                _buildSummaryItem("Tekanan Darah", tekananDarahController.text),
                _buildSummaryItem(
                  "Berat Badan",
                  "${beratBadanController.text} kg",
                ),
                if (keluhanController.text.isNotEmpty)
                  _buildSummaryItem("Keluhan", keluhanController.text),
                if (pergerakanJaninController.text.isNotEmpty)
                  _buildSummaryItem(
                    "Pergerakan Janin",
                    pergerakanJaninController.text,
                  ),
                _buildSummaryItem("Jenis Kunjungan", _selectedKunjungan),
                _buildSummaryItem("Trimester", _selectedTrimester),
                _buildSummaryItem("Imunisasi TT", _selectedImunisasiTT),
                if (hasilLabController.text.isNotEmpty)
                  _buildSummaryItem("Hasil Lab", hasilLabController.text),
                if (hasilUSGController.text.isNotEmpty)
                  _buildSummaryItem("Hasil USG", hasilUSGController.text),
                _buildSummaryItem(
                  "Foto USG",
                  _fotoUSG != null ? "Tersimpan" : "Tidak ada",
                ),
                if (catatanANCController.text.isNotEmpty)
                  _buildSummaryItem("Catatan ANC", catatanANCController.text),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Kembali ke dashboard
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tekananDarahController.dispose();
    beratBadanController.dispose();
    keluhanController.dispose();
    pergerakanJaninController.dispose();
    hasilLabController.dispose();
    hasilUSGController.dispose();
    catatanANCController.dispose();
    super.dispose();
  }
}
