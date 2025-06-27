import 'package:diabary/features/medications/presentation/providers/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MedicationsCalendar extends StatefulWidget {
  const MedicationsCalendar({super.key});

  @override
  State<MedicationsCalendar> createState() => _MedicationsCalendarState();
}

class _MedicationsCalendarState extends State<MedicationsCalendar> {
  @override
  Widget build(BuildContext context) {
    final calendarProvider = context.watch<CalendarProvider>();
    final focusedDay = calendarProvider.focusedDay;
    final selectedDay = calendarProvider.selectedDay;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TableCalendar(
        headerVisible: true,
        locale: "pt_BR",
        focusedDay: focusedDay,
        firstDay: DateTime.utc(2010, 10, 14),
        lastDay: DateTime.utc(2030, 3, 14),
        availableGestures: AvailableGestures.all,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: ((day) => isSameDay(selectedDay, day)),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronVisible: true,
          rightChevronVisible: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.w600),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceTint,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          outsideDaysVisible: true,
        ),
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            final weekDaysLabel = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
            final text = weekDaysLabel[day.weekday % 7];
            final isWeekend =
                day.weekday == DateTime.saturday ||
                day.weekday == DateTime.sunday;

            return Center(
              child: Text(
                text,
                style: TextStyle(
                  color: isWeekend ? Colors.black54 : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
        onDaySelected: (selectedDay, focusedDay) {
          context.read<CalendarProvider>().setFocusedDay(focusedDay);
          context.read<CalendarProvider>().setSelectedDay(selectedDay);
        },
        onPageChanged: (focusedDay) {
          context.read<CalendarProvider>().setFocusedDay(focusedDay);
        },
      ),
    );
  }
}
