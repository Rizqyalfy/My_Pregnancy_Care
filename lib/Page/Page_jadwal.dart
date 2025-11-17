// lib/Page/Page_jadwal.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CatatanPage extends StatefulWidget {
  const CatatanPage({super.key});

  @override
  State<CatatanPage> createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  // ---------- sample data ----------
  DateTime _visibleMonth = DateTime.now();
  int currentWeek = 24; // contoh: 24/40 minggu
  final int totalWeeks = 40;

  // schedules keyed by yyyy-MM-dd
  final Map<String, List<Map<String, String>>> schedules = {
    '2025-01-10': [
      {'title': 'ANC Minggu 12', 'type': 'ANC', 'note': 'Bawa hasil lab'},
    ],
    '2025-03-07': [
      {'title': 'ANC Minggu 20', 'type': 'ANC', 'note': 'USG level 2'},
    ],
    '2025-05-02': [
      {'title': 'ANC Minggu 28', 'type': 'ANC', 'note': 'Vaksin TT jika perlu'},
    ],
  };

  // reminder toggles
  bool reminderVitamin = true;
  bool reminderTT = false;
  bool reminderRest = true;

  // riwayat kunjungan
  final List<Map<String, String>> history = [
    {'date': '2024-10-10', 'result': 'BP:110/80 • BB:62kg • HB:12'},
    {'date': '2024-09-25', 'result': 'BP:115/85 • BB:60kg • HB:11.8'},
  ];

  // ---------- helpers ----------
  String _keyFromDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
  int _daysInMonth(DateTime m) => DateTime(m.year, m.month + 1, 0).day;
  DateTime _firstDayOfMonth(DateTime m) => DateTime(m.year, m.month, 1);

  void _prevMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    });
  }

  List<Widget> _buildCalendarGrid() {
    final first = _firstDayOfMonth(_visibleMonth);
    final totalDays = _daysInMonth(_visibleMonth);
    final startWeekday = first.weekday;
    final List<Widget> cells = [];

    // 7 header titles
    const names = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    for (final n in names) {
      cells.add(
        Container(
          padding: const EdgeInsets.all(4),
          child: Center(
            child: Text(
              n,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      );
    }

    // leading empty cells
    final leadingEmpty = startWeekday - 1;
    for (var i = 0; i < leadingEmpty; i++) {
      cells.add(Container());
    }

    // hari dalam bulan
    for (var d = 1; d <= totalDays; d++) {
      final dt = DateTime(_visibleMonth.year, _visibleMonth.month, d);
      final key = _keyFromDate(dt);
      final hasSchedule =
          schedules.containsKey(key) && schedules[key]!.isNotEmpty;
      final isToday =
          DateTime.now().day == d &&
          DateTime.now().month == _visibleMonth.month &&
          DateTime.now().year == _visibleMonth.year;

      cells.add(
        Container(
          margin: const EdgeInsets.all(2),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => _openDayBottomSheet(dt),
            child: Container(
              decoration: BoxDecoration(
                color: isToday ? const Color(0xFFE3F2FD) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: isToday ? Border.all(color: Colors.blue) : null,
              ),
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    d.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: hasSchedule
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: hasSchedule ? Colors.blue[800] : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (hasSchedule)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.pink[400],
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // fill trailing blanks
    while (cells.length % 7 != 0) {
      cells.add(Container());
    }

    return cells;
  }

  void _openDayBottomSheet(DateTime date) {
    final key = _keyFromDate(date);
    final daySchedules = schedules[key] ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                DateFormat.yMMMMEEEEd().format(date),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              if (daySchedules.isEmpty)
                const Text("Belum ada jadwal pada tanggal ini.")
              else
                Column(
                  children: daySchedules.map((s) {
                    return ListTile(
                      leading: Icon(
                        s['type'] == 'ANC'
                            ? Icons.favorite
                            : Icons.notifications,
                        color: Colors.blue[700],
                      ),
                      title: Text(s['title'] ?? ''),
                      subtitle: Text(s['note'] ?? ''),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showAddScheduleDialog(date);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Jadwal'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showAllSchedulesForMonth();
                      },
                      icon: const Icon(Icons.list),
                      label: const Text('Lihat Bulan'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showAddScheduleDialog(DateTime date) {
    final titleCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String type = 'ANC';
    int week = currentWeek;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tambah Jadwal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Judul'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: noteCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Catatan (opsional)',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Tipe: '),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: type,
                      items: const [
                        DropdownMenuItem(value: 'ANC', child: Text('ANC')),
                        DropdownMenuItem(value: 'Lab', child: Text('Lab')),
                        DropdownMenuItem(
                          value: 'Vitamin',
                          child: Text('Vitamin'),
                        ),
                        DropdownMenuItem(
                          value: 'Kontrol',
                          child: Text('Kontrol'),
                        ),
                      ],
                      onChanged: (v) => setState(() => type = v ?? 'ANC'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Minggu: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Slider(
                        value: week.toDouble(),
                        min: 1,
                        max: totalWeeks.toDouble(),
                        divisions: totalWeeks - 1,
                        label: '$week',
                        onChanged: (v) {
                          setState(() => week = v.toInt());
                        },
                      ),
                    ),
                    Text('$week'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final key = _keyFromDate(date);
                final entry = {
                  'title': titleCtrl.text.isEmpty
                      ? 'Jadwal baru'
                      : titleCtrl.text,
                  'note': noteCtrl.text,
                  'type': type,
                  'week': week.toString(),
                };
                setState(() {
                  schedules.putIfAbsent(key, () => []).add(entry);
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jadwal tersimpan')),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showAllSchedulesForMonth() {
    final totalDays = _daysInMonth(_visibleMonth);
    final items = <MapEntry<String, List<Map<String, String>>>>[];

    for (var d = 1; d <= totalDays; d++) {
      final dt = DateTime(_visibleMonth.year, _visibleMonth.month, d);
      final key = _keyFromDate(dt);
      if (schedules.containsKey(key)) {
        items.add(MapEntry(key, schedules[key]!));
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Jadwal Bulan ${DateFormat.yMMMM().format(_visibleMonth)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (items.isEmpty) const Text('Belum ada jadwal di bulan ini.'),
              ...items.map((e) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Colors.blue),
                    title: Text(e.value.first['title'] ?? ''),
                    subtitle: Text('${e.key} • ${e.value.first['note'] ?? ''}'),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // ---------- quick reminder action ----------
  void _quickScheduleReminder(String text) {
    final dt = DateTime.now().add(const Duration(seconds: 5));
    final key = _keyFromDate(dt);
    final entry = {'title': text, 'note': 'Reminder cepat', 'type': 'Reminder'};
    setState(() {
      schedules.putIfAbsent(key, () => []).add(entry);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengingat singkat dijadwalkan (5s)')),
    );
  }

  // ---------- UI build ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            _buildHeader(),
            const SizedBox(height: 12),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressBar(),
                    const SizedBox(height: 16),
                    _buildCalendarCard(),
                    const SizedBox(height: 12),
                    _buildMiniStatsRow(),
                    const SizedBox(height: 12),
                    _buildTimelineCard(),
                    const SizedBox(height: 12),
                    _buildReminderPanel(),
                    const SizedBox(height: 12),
                    _buildBigCards(),
                    const SizedBox(height: 12),
                    _buildHistorySection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jadwal & Pengingat',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Atur jadwal pemeriksaan ANC, pengingat, dan catatan kesehatan.',
                  style: TextStyle(color: Colors.blueGrey[700], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final ratio = currentWeek / totalWeeks;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Kehamilan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: ratio.clamp(0.0, 1.0),
                        child: Container(
                          height: 14,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4A90E2),
                                Color.fromARGB(255, 6, 1, 78),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$currentWeek/$totalWeeks mgg',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    final monthTitle = DateFormat.yMMMM().format(_visibleMonth);
    final cells = _buildCalendarGrid();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // header month & nav
            Row(
              children: [
                IconButton(
                  onPressed: _prevMonth,
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      monthTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // grid - FIXED
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.9,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: cells.length,
              itemBuilder: (context, index) => cells[index],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStatsRow() {
    // dummy data for mini stats
    final bpData = [110, 112, 115, 113, 110];
    final weightData = [60, 61, 61.5, 62, 62];

    return SizedBox(
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: _miniStatCard(
              'Tekanan Darah (BP)',
              '110/80',
              bpData.map((e) => e.toDouble()).toList(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _miniStatCard(
              'Berat Badan (kg)',
              '62',
              weightData.map((e) => e.toDouble()).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStatCard(String title, String value, List<double> data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: data.map((d) {
                final h = (d % 10) + 6;
                return Container(
                  width: 6,
                  height: h,
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard() {
    // create items from schedules sorted by date
    final items = schedules.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Timeline Kunjungan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (items.isEmpty)
              const Text('Belum ada jadwal.')
            else
              Column(
                children: items.map((e) {
                  final dt = DateTime.parse(e.key);
                  final label = DateFormat('dd MMM yyyy').format(dt);
                  final first = e.value.first;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // timeline indicator
                      Column(
                        children: [
                          Container(
                            width: 2,
                            height: 8,
                            color: Colors.grey[300],
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.blue[700],
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 60,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      first['title'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      label,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(first['note'] ?? ''),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(first['type'] ?? ''),
                                      backgroundColor: Colors.blue[50],
                                    ),
                                    const SizedBox(width: 8),
                                    if (first.containsKey('week'))
                                      Text(
                                        'Minggu ${first['week']}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        _quickScheduleReminder(
                                          first['title'] ?? 'Pengingat',
                                        );
                                      },
                                      child: const Text('Ingatkan'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderPanel() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengingat & Reminder',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _reminderTile(
                    'Vitamin Harian',
                    Icons.local_pharmacy,
                    reminderVitamin,
                    (v) => setState(() => reminderVitamin = v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _reminderTile(
                    'Vaksin/TT',
                    Icons.healing,
                    reminderTT,
                    (v) => setState(() => reminderTT = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _reminderTile(
                    'Istirahat Cukup',
                    Icons.bedtime,
                    reminderRest,
                    (v) => setState(() => reminderRest = v),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _reminderTile(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: Colors.green),
        ],
      ),
    );
  }

  Widget _buildBigCards() {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.event_note, size: 36, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jadwal Pemeriksaan Berikutnya',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '🗓️ ${_nextScheduleText()}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showAddScheduleDialog(
                      DateTime.now().add(const Duration(days: 7)),
                    );
                  },
                  child: const Text('Tambah / Ubah'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _nextScheduleText() {
    final today = DateTime.now();
    final futureKeys = schedules.keys.where((k) {
      final dt = DateTime.parse(k);
      return dt.isAfter(today) || dt.isAtSameMomentAs(today);
    }).toList();
    if (futureKeys.isEmpty) return 'Belum ada jadwal terdekat';
    futureKeys.sort();
    final k = futureKeys.first;
    final dt = DateTime.parse(k);
    return '${DateFormat.yMMMd().format(dt)} • ${schedules[k]!.first['title'] ?? ''}';
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Riwayat Kunjungan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          children: history.map((h) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.history, color: Colors.orange),
                title: Text(h['date'] ?? ''),
                subtitle: Text(h['result'] ?? ''),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
