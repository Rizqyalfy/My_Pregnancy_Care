import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'Page_InputDataIbu.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 25),

            // ============================
            // DASHBOARD KEHAMILAN
            // ============================
            _buildSectionTitle("Dashboard Kehamilan"),
            _buildInfoCard(
              title: "Informasi Kehamilan",
              icon: Icons.pregnant_woman,
              color: Colors.blueAccent,
              children: [
                _buildRow("Usia Kehamilan", "24 minggu (Trimester II)"),
                _buildRow("Tekanan Darah", "110/80 mmHg"),
                _buildRow("Berat Badan", "62 kg"),
                _buildRow("Kadar Hb", "12 g/dL"),
                const SizedBox(height: 6),
                _buildRow(
                  "Perkembangan Janin",
                  "Normal • Paru-paru mulai berkembang",
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ============================
            // INPUT DATA IBU
            // ============================
            _buildSectionTitle("Input Data Harian / Mingguan"),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InputDataIbuPage()),
                );
              },
              child: _buildInfoCard(
                title: "Input Data Ibu",
                icon: Icons.edit_note,
                color: Colors.green,
                children: [
                  _buildRow("Tekanan Darah", "Input setiap kunjungan"),
                  _buildRow("Berat Badan", "Update mingguan"),
                  _buildRow("Keluhan", "Catat jika muncul gejala"),
                  _buildRow("Pergerakan Janin", "Monitor harian"),
                  const Divider(height: 16),
                  _buildRow(
                    "Catatan ANC",
                    "Kunjungan • Hasil lab • USG • Imunisasi TT",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ============================
            // GRAFIK PERKEMBANGAN
            // ============================
            _buildSectionTitle("Grafik Perkembangan"),
            _buildInfoCard(
              title: "Grafik Kondisi Ibu & Janin",
              icon: Icons.show_chart,
              color: Colors.deepPurple,
              children: [
                _buildGraph("Perkembangan Berat Badan Ibu"),
                const SizedBox(height: 12),
                _buildGraph("Tinggi Fundus / Pertumbuhan Janin"),
                const SizedBox(height: 12),
                _buildGraph("Tekanan Darah & Keluhan"),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _ColorIndicator(color: Colors.green, label: "Normal"),
                    _ColorIndicator(color: Colors.yellow, label: "Waspada"),
                    _ColorIndicator(color: Colors.red, label: "Risiko"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ========================================================
  // HEADER
  // ========================================================
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "MyPregnancyCare",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: const [
            Text(
              "Hai, Ibu",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.waving_hand, color: Colors.amber, size: 26),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "Lihat kondisi terbaru kesehatan Anda dan perkembangan janin.",
          style: TextStyle(color: Colors.blueGrey[700]),
        ),
      ],
    );
  }

  // ========================================================
  // SECTION TITLE
  // ========================================================
  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[900],
        ),
      ),
    );
  }

  // ========================================================
  // CARD
  // ========================================================
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const Divider(thickness: 1, color: Color(0xFFB0BEC5)),
          ...children,
        ],
      ),
    );
  }

  // ========================================================
  // ROW
  // ========================================================
  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E5C9A),
            ),
          ),
        ],
      ),
    );
  }

  // ========================================================
  // GRAFIK (Line Chart) — FL_CHART
  // ========================================================
  Widget _buildGraph(String title) {
    List<FlSpot> dummyData = const [
      FlSpot(0, 50),
      FlSpot(1, 55),
      FlSpot(2, 58),
      FlSpot(3, 60),
      FlSpot(4, 62),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blueGrey.shade200),
          ),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 4,
              minY: 40,
              maxY: 70,
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (v, meta) => Text(
                      "M${v.toInt() + 1}",
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: dummyData,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ColorIndicator extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorIndicator({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 10, backgroundColor: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
