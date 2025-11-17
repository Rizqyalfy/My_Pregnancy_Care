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

            // ======================================
            // DASHBOARD KEHAMILAN
            // ======================================
            _buildSectionTitle("Dashboard Kehamilan"),
            _buildInfoCard(
              title: "Informasi Kehamilan",
              icon: Icons.pregnant_woman,
              color: const Color(0xFF4A90E2),
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

            // ======================================
            // INPUT DATA IBU
            // ======================================
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

            // ======================================
            // GRAFIK PERKEMBANGAN
            // ======================================
            _buildSectionTitle("Grafik Perkembangan"),
            _buildInfoCard(
              title: "Grafik Kondisi Ibu & Janin",
              icon: Icons.show_chart,
              color: Colors.deepPurple,
              children: [
                _buildGraph("Perkembangan Berat Badan Ibu"),
                const SizedBox(height: 16),
                _buildGraph("Tinggi Fundus / Pertumbuhan Janin"),
                const SizedBox(height: 16),
                _buildGraph("Tekanan Darah"),
                const SizedBox(height: 18),
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

  // =======================================================
  // HEADER
  // =======================================================
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

  // =======================================================
  // SECTION TITLE
  // =======================================================
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

  // =======================================================
  // CARD WRAPPER
  // =======================================================
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

  // =======================================================
  // ROW LABEL
  // =======================================================
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

  // =======================================================
  // GRAFIK (TRANSPARANT BACKGROUND)
  // =======================================================
  Widget _buildGraph(String title) {
    List<double> data = [110, 118, 125, 138, 145];

    List<FlSpot> spots = List.generate(
      data.length,
      (i) => FlSpot(i.toDouble(), data[i]),
    );

    Color getColor(double v) {
      if (v <= 120) return Colors.green;
      if (v <= 139) return Colors.yellow;
      return Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.transparent, // transparan
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blueGrey.shade400, width: 1.2),
          ),
          padding: const EdgeInsets.all(12),

          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 4,
              minY: 90,
              maxY: 160,

              backgroundColor: Colors.transparent, // tetap transparan

              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 10,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.25),
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.25),
                  strokeWidth: 1,
                ),
              ),

              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.shade600, width: 1),
              ),

              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 20,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
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
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),

              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  barWidth: 3,
                  color: Colors.blue,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, _, __, index) => FlDotCirclePainter(
                      radius: 5,
                      color: getColor(data[index]), // indikator warna
                      strokeWidth: 1,
                      strokeColor: Colors.black26,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: false,
                  ), // tidak ada background fill
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
