import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MedicamentoLembrete {
  final String nome;
  final String notas;
  final TimeOfDay horario;
  final bool tomado;

  MedicamentoLembrete({
    required this.nome,
    required this.notas,
    required this.horario,
    this.tomado = false,
  });

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'notas': notas,
    'horario': '${horario.hour}:${horario.minute}',
    'tomado': tomado,
  };

  factory MedicamentoLembrete.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['horario'] as String).split(':');
    return MedicamentoLembrete(
      nome: json['nome'],
      notas: json['notas'],
      horario: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      tomado: json['tomado'] ?? false,
    );
  }
}

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<String, List<MedicamentoLembrete>> _lembretes = {};
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initNotifications();
    _loadLembretes();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Criação do canal (necessário para Android 8+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'medicamentos', // id
      'Medicamentos', // name
      description: 'Notificações de lembrete de medicamentos',
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _loadLembretes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('lembretes') ?? '{}';
    final decoded = json.decode(data) as Map<String, dynamic>;
    setState(() {
      _lembretes = decoded.map(
        (key, value) => MapEntry(
          key,
          (value as List)
              .map((item) => MedicamentoLembrete.fromJson(item))
              .toList(),
        ),
      );
    });
  }

  Future<void> _saveLembretes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _lembretes.map(
      (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
    );
    await prefs.setString('lembretes', json.encode(data));
  }

  void _addLembrete(DateTime day, MedicamentoLembrete lembrete) async {
    final key = _formatDate(day);
    setState(() {
      _lembretes.putIfAbsent(key, () => []);
      _lembretes[key]!.add(lembrete);
    });
    await _saveLembretes();
    _scheduleNotification(day, lembrete);
  }

  void _toggleTomado(DateTime day, int index) async {
    final key = _formatDate(day);
    setState(() {
      _lembretes[key]![index] = MedicamentoLembrete(
        nome: _lembretes[key]![index].nome,
        notas: _lembretes[key]![index].notas,
        horario: _lembretes[key]![index].horario,
        tomado: !_lembretes[key]![index].tomado,
      );
    });
    await _saveLembretes();
  }

  Future<void> _scheduleNotification(
    DateTime day,
    MedicamentoLembrete lembrete,
  ) async {
    final scheduledDate = tz.TZDateTime.local(
      day.year,
      day.month,
      day.day,
      lembrete.horario.hour,
      lembrete.horario.minute,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      scheduledDate.hashCode,
      'Hora do medicamento',
      'Tomar: ${lembrete.nome}',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicamentos',
          'Medicamentos',
          channelDescription: 'Notificações de lembrete de medicamentos',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle, // <-- Adicione esta linha
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Color _getDayColor(DateTime day) {
    final key = _formatDate(day);
    if (!_lembretes.containsKey(key)) return Colors.transparent;
    final lembretes = _lembretes[key]!;
    if (lembretes.any(
      (l) =>
          !l.tomado &&
          DateTime.now().isAfter(
            DateTime(
              day.year,
              day.month,
              day.day,
              l.horario.hour,
              l.horario.minute,
            ),
          ),
    )) {
      return Colors.red; // Não tomou
    }
    if (lembretes.every((l) => l.tomado)) {
      return Colors.green; // Tomou todos
    }
    if (lembretes.isNotEmpty) {
      return Colors.green.shade900; // Tem lembrete, mas ainda não chegou a hora
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final key = _formatDate(_selectedDay);
    final lembretesDoDia = _lembretes[key] ?? [];
    int selectedIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Medicamentos',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromRGBO(138, 136, 82, 10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Calendário
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 229, 225, 217),
              ),
              child: TableCalendar(
                locale: 'pt_BR',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                availableCalendarFormats: const {CalendarFormat.month: 'Mês'},
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final color = _getDayColor(day);
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: color == Colors.transparent ? null : color,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text('${day.day}'),
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 3.5,
                            blurRadius: 5,
                            offset: Offset(0, 3), // Sombra na parte inferior
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color.fromRGBO(131, 128, 66, 0.965),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lista de lembretes do dia
            Expanded(
              child: ListView.builder(
                itemCount: lembretesDoDia.length,
                itemBuilder: (context, index) {
                  final lembrete = lembretesDoDia[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        lembrete.nome,
                        style: const TextStyle(
                          fontSize: 20, // Tamanho maior para o nome
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lembrete.notas,
                            style: const TextStyle(
                              fontSize: 16, // Tamanho maior para as notas
                            ),
                          ),
                          Text(
                            lembrete.horario.format(context),
                            style: const TextStyle(
                              fontSize: 18, // Tamanho maior para o horário
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: lembrete.tomado,
                        onChanged: (_) => _toggleTomado(_selectedDay, index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final novo = await showDialog<MedicamentoLembrete>(
            context: context,
            builder: (context) => _DialogNovoLembrete(),
          );
          if (novo != null) {
            _addLembrete(_selectedDay, novo);
          }
        },
        icon: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 0, 0)),
        label: const Text(
          'Criar Lembrete',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        backgroundColor: const Color(0xFFE5E1D9),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Configurações',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Sobre'),
        ],
        currentIndex: selectedIndex, // Define o índice selecionado
        selectedItemColor: Colors.blue, // Cor do item selecionado
        unselectedItemColor: Colors.grey, // Cor dos itens não selecionados
        onTap: (int index) {
          setState(() {
            selectedIndex = index; // Atualiza o índice selecionado
          });
        },
      ),
    );
  }
}

// Dialog para adicionar lembrete
class _DialogNovoLembrete extends StatefulWidget {
  @override
  State<_DialogNovoLembrete> createState() => _DialogNovoLembreteState();
}

class _DialogNovoLembreteState extends State<_DialogNovoLembrete> {
  final _nomeController = TextEditingController();
  final _notasController = TextEditingController();
  TimeOfDay _horario = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Novo Lembrete'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do medicamento',
              ),
            ),
            TextField(
              controller: _notasController,
              decoration: const InputDecoration(labelText: 'Notas adicionais'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Horário:'),
                const SizedBox(width: 8),
                Text(_horario.format(context)),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _horario,
                    );
                    if (picked != null) {
                      setState(() {
                        _horario = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nomeController.text.isNotEmpty) {
              Navigator.pop(
                context,
                MedicamentoLembrete(
                  nome: _nomeController.text,
                  notas: _notasController.text,
                  horario: _horario,
                ),
              );
            }
          },
          child: const Text('Criar'),
        ),
      ],
    );
  }
}
